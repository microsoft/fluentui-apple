//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSShyHeaderController

/// Container VC defining a content area beneath a custom header container for a ShyHeader and a ContentVC, enabling "scroll to hide header" behavior
/// Manages logic around contained scroll views, using the offset to animate the exposure of the header view
class MSShyHeaderController: UIViewController {
    private struct Constants {
        static let headerShowHideAnimationDuration: TimeInterval = 0.2 //how long a full expansion should take, when not defined by a gesture interaction
        static let swipeThresholdVelocity: CGFloat = 10.0 //swipes under this threshold will not expose the header view. Above (faster than) this threshold will begin expansion
        static let shyHeaderShowHideDecisionProgressThreshold: CGFloat = 0.4 // the threshold for which an incomplete expansion will move towards completion/contraction on a no-velocity release of a scrollView pan gesture
    }

    // The contained ViewController
    // Setting this property will remove the previous content VC, and add the new VC's view
    // Setting will also update the current layout as necessary, in accordance with the protocol conformer's return values
    var contentVC: UIViewController? {
        willSet {
            contentVC?.view.removeFromSuperview()
        }
        didSet {
            loadViewIfNeeded()
            didSetContentViewController()
        }
    }

    // We have no interest in this container view's navigation item, so we pass the contentVC's navigation item, if available
    //since the contentVC's nav item is optional, we provide a default value if necessary
    override var navigationItem: UINavigationItem {
        get {
            return contentVC?.navigationItem ?? _navigationItem
        }
        set {
            _navigationItem = newValue
        }
    }
    private var _navigationItem = UINavigationItem(title: "container") //default navigation item, defined as a psuedo-ivar to avoid property conflict

    override var childForStatusBarStyle: UIViewController? {
        return contentVC
    }

    private let contentContainerView: UIView = { // within the gesture-based configuration, houses the contentVC.view
        let contentContainerView = UIView()
        contentContainerView.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        return contentContainerView
    }()
    private let shyHeaderView = MSShyHeaderView() //header view, displayed above the content view
    private var shyViewTopConstraint: NSLayoutConstraint? //animatable constraint used to show/hide the header

    private var previousContentScrollViewTraits = MSContentScrollViewTraits() //properties of the scroll view at the last scrollDidOccurIn: update. Used with current traits to understand user action

    init(contentVC: UIViewController) {
        defer {
            self.contentVC = contentVC
        }
        shyHeaderView.accessoryView = contentVC.navigationItem.accessoryView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Avoid the accessory view from showing above this container view.
        view.clipsToBounds = true

        setupBaseLayout()
        setupNotificationObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBarStyle = msNavigationController?.msNavigationBar.actualStyle(for: navigationItem) {
            shyHeaderView.navigationBarStyle = navBarStyle
        }
    }

    // MARK: - Base Construction

    /// Constructs the UI for the gesture-based configuration
    /// Uses autolayout and a container view to layout the shy header in relation to the contentVC view
    private func setupBaseLayout() {
        var constraints = [NSLayoutConstraint]()

        // ShyHeaderView

        shyHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shyHeaderView)

        let shyHeight = shyHeaderView.heightAnchor.constraint(equalToConstant: shyHeaderView.maxHeight)
        shyHeight.identifier = "shyView_height"
        constraints.append(shyHeight)

        let shyLeading = shyHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        shyLeading.identifier = "shyView_leading"
        constraints.append(shyLeading)

        let shyTrailing = shyHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        shyTrailing.identifier = "shyView_trailing"
        constraints.append(shyTrailing)

        let shyTop = shyHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: MSNavigationController.showsShyHeaderByDefault ? 0.0 : -shyHeaderView.maxHeight)
        shyTop.identifier = "shyView_top"
        constraints.append(shyTop)
        self.shyViewTopConstraint = shyTop

        // ContentContainerView

        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainerView)

        let contentLeading = contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        contentLeading.identifier = "contentContainer_leading"
        constraints.append(contentLeading)

        let contentTrailing = contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        contentTrailing.identifier = "contentContainer_trailing"
        constraints.append(contentTrailing)

        let shyBottomToContentTop = shyHeaderView.bottomAnchor.constraint(equalTo: contentContainerView.topAnchor)
        shyBottomToContentTop.identifier = "shyBottomToContentTop"
        constraints.append(shyBottomToContentTop)

        let contentBottom = contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        contentBottom.identifier = "contentContainer_bottom"
        constraints.append(contentBottom)

        NSLayoutConstraint.activate(constraints)

        // Make sure shy header is always on top so it can show a shadow which is positioned outside of its bounds
        view.bringSubviewToFront(shyHeaderView)
    }

    /// Observed Notifications:
    ///  1. accessoryContentViewExpansionRequestedNotification
    ///  2. accessoryContentViewContractionRequestedNotification
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MSShyHeaderController.accessoryContentViewExpansionRequestedNotificationReceived(notification:)),
                                               name: NSNotification.Name.accessoryContentViewExpansionRequested,
                                               object: nil)
    }

    /// Shows the accessoryContent, if the content provider has given us one
    ///
    /// - Parameter notification: accessoryContentViewExpansionRequestedNotificationReceived
    @objc private func accessoryContentViewExpansionRequestedNotificationReceived(notification: NSNotification) {
        guard shouldAcceptRequest(from: notification.object) else {
            return
        }
        expandAccessory()
    }

    /// Determines if the provided expansion RequestOriginator should be allowed to act on this ShyContainer
    /// Because the app can have any number of shy header hierarchies, we want any given shyheader to respond only to those which come from its hierarchy
    /// Check against various possible originators to make sure that we are correctly filtering requests
    ///
    /// - Parameter originator: the object requesting an expansion/contraction
    /// - Returns: whether to proceed with the request
    private func shouldAcceptRequest(from requestOriginator: Any?) -> Bool {
        // we expect an object from all request notifications
        guard let expansionRequestOriginator = requestOriginator else {
            fatalError("expansion request notification should have originator")
        }

        // if the originator is a VC, make sure it belongs to this heirarchy
        if let originatorVC = expansionRequestOriginator as? UIViewController,
            let contentVC = contentVC {
            guard originatorVC == contentVC || contentVC.isAncestor(ofViewController: originatorVC) else {
                return false
            }
        }

        // if the originator is a LargeTitleView, make sure it belongs to this heirarchy
        if let originatorTitleView = expansionRequestOriginator as? MSLargeTitleView {
            guard originatorTitleView == msNavigationController?.msNavigationBar.titleView else {
                return false
            }
        }

        return true
    }

    // MARK: - GestureBased Configuration Handling

    /// Adds the contentVC to the view hierarchy and constructs objects as required for Gesture-based shy behaviors
    /// Differentiated from the scroll-inset based setup
    private func didSetContentViewController() {
        if let contentVC = contentVC,
            let contentView = contentVC.view {

            contentVC.willMove(toParent: self)
            self.addChild(contentVC)

            contentContainerView.contain(view: contentView)

            if let scrollView = navigationItem.contentScrollView {
                scrollView.panGestureRecognizer.addTarget(self, action: #selector(contentScrollViewPanGestureRecognizerRecognized(gesture:)))
            } else {
                // We wont be scrolling, adjust the accessory container and title as needed
                updateHeader(with: 1.0, expanding: true)
                msNavigationController?.msNavigationBar.expand(true)
            }
            contentVC.didMove(toParent: self)
        }
    }

    // MARK: - Gesture-Based Shy Behavior Methods

    /// Adds self as a target for the pan gesture in the provided scrollview
    /// add target does nothing if the gesture is already targeting self
    ///
    /// - Parameter scrollView: the new shy-behavior driving scrollview
    private func shyBehaviorDrivingScrollViewChanged(toScrollView scrollView: UIScrollView) {
        scrollView.panGestureRecognizer.addTarget(self, action: #selector(contentScrollViewPanGestureRecognizerRecognized(gesture:)))
    }

    /// Directs the gesture to the relevant shy-driving layout methods, depending on the state
    /// Ignores beginning, cancelled, and failed gestures
    ///
    /// - Parameter gesture: the pan gesture that fired
    @objc private func contentScrollViewPanGestureRecognizerRecognized(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            processMovingPanGesture(gesture: gesture)
        case .ended:
            processEndingPanGesture(gesture: gesture)
        default:
            return
        }
    }

    /// Converts the properties of a UIPanGesture with a .changed state into the proper shy behaviors
    ///
    /// Task: 738134, refactor method for legibility
    ///
    /// - Parameter gesture: the changing pan gesture
    private func processMovingPanGesture(gesture: UIPanGestureRecognizer) {
        guard let scrollView = navigationItem.contentScrollView else {
            return
        }

        let offset = scrollView.contentOffset
        let yOffset = offset.y // positive offsets are associated with upward-scrolled content
        // a negative offset is indicates the user is "pulling the content down" past its origin (i.e. Pull to Refresh)
        let previousYOffset = previousContentScrollViewTraits.yOffset

        // check for redundant firings, not all changed events update the y-axis
        guard previousYOffset != yOffset else {
            return
        }

        let newScrollDirection: UIScrollView.VerticalScrollDirection = previousYOffset > yOffset ? .up : .down
        let swipeDirection: UIScrollView.VerticalScrollDirection = newScrollDirection == .up ? .down : .up

        var switchedDirection = false

        if let previousScrollDirection = previousContentScrollViewTraits.scrollDirection {
            switchedDirection = previousScrollDirection != newScrollDirection
        }

        let velocity = gesture.velocity(in: scrollView).y

        let logUpdatedTraits: () -> Void = {
            self.previousContentScrollViewTraits = MSContentScrollViewTraits(yVelocity: velocity,
                                                                             userScrolling: scrollView.userIsScrolling,
                                                                             scrollDirection: newScrollDirection,
                                                                             switchedDirection: switchedDirection,
                                                                             yOffset: yOffset,
                                                                             scrollLocationDescriptor: scrollView.scrollLocationDescriptor)
        }

        guard shyBehaviorCalculationsShouldProceed(inScrollView: scrollView, forGestureRecognizer: gesture, withExpectedState: .changed) else {
            logUpdatedTraits()
            return
        }

        let wouldExpandHeader = swipeDirection == .down

        //if we're excessively scrolling upward preceding the content, contracting isn't allowed
        let intendedContractionShouldNotOccur = !wouldExpandHeader
            && scrollView.scrollLocationDescriptor == .excessivelyPrecedingContent

        // if we're excessively scrolling *down* beyond the content, expanding isn't allowed
        let intendedExpansionShouldNotOccur = wouldExpandHeader
            && scrollView.scrollLocationDescriptor == .excessivelyBeyondContent
            && newScrollDirection != .up

        // if the header exposure and the directionality of the swipe should cause no change in layout, we fall out
        let redundantSwipeAction = (wouldExpandHeader && shyHeaderView.exposure.progress == 1.0
            || wouldExpandHeader == false && shyHeaderView.exposure.progress == 0)

        if intendedContractionShouldNotOccur || intendedExpansionShouldNotOccur || redundantSwipeAction {
            logUpdatedTraits()
            return
        }

        guard scrollView.userIsScrolling else { //if the user stops scrolling, we decide if to finish the animation based on the velocity of the scrollView
            if previousContentScrollViewTraits.userIsScrolling { //user not scrolling now, but was previously, indicates a release
                if abs(previousContentScrollViewTraits.yVelocity) > MSShyHeaderController.Constants.swipeThresholdVelocity { //hot release (exceeds threshold, a "toss")

                    let newProgress: CGFloat = swipeDirection == .up ? 0.0 : 1.0
                    self.updateHeader(with: newProgress, expanding: wouldExpandHeader)
                }
            }
            logUpdatedTraits()
            return
        }

        guard let topConstraint = shyViewTopConstraint else {
            fatalError("Proper shyView autolayout was not constructed")
        }

        let currentHeight: CGFloat = shyHeaderView.maxHeight - abs(topConstraint.constant) // current height of the header, calculated using the negative autolayout constraint constant
        let newOffset = yOffset - previousContentScrollViewTraits.yOffset
        let offsetDiff = abs(newOffset) // calculate the change in offset since the last update

        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: previousContentScrollViewTraits.yOffset)

        var newHeight: CGFloat?

        if swipeDirection == .down && scrollView.scrollLocationDescriptor != .excessivelyPrecedingContent { //if the user is swiping down, but not past the content origin
            newHeight = min(shyHeaderView.maxHeight, currentHeight + offsetDiff) //the new height, no greater than the max height
        } else if swipeDirection == .up { //else if the user is swiping up
            newHeight = max(-1.0, currentHeight - offsetDiff) //the new height, no lesser than 0
        }

        if let newHeight = newHeight {
            let newProgress = newHeight / shyHeaderView.maxHeight //progress, based on 0.0 being concealed and 1.0 being exposed
            self.updateHeader(with: newProgress, expanding: wouldExpandHeader)
        }

        self.previousContentScrollViewTraits = MSContentScrollViewTraits(yVelocity: velocity,
                                                                         userScrolling: scrollView.userIsScrolling,
                                                                         scrollDirection: newScrollDirection,
                                                                         switchedDirection: switchedDirection,
                                                                         yOffset: previousContentScrollViewTraits.yOffset,
                                                                         scrollLocationDescriptor: scrollView.scrollLocationDescriptor)

    }

    /// Converts the properties of a UIPanGesture with a .ended state into the proper shy behaviors
    ///
    /// - Parameter gesture: the ending gesture
    private func processEndingPanGesture(gesture: UIPanGestureRecognizer) {
        guard let scrollView = navigationItem.contentScrollView else {
            return
        }

        guard shyBehaviorCalculationsShouldProceed(inScrollView: scrollView, forGestureRecognizer: gesture, withExpectedState: .ended) else {
            return
        }

        // use the velocity to generate a momentum
        // momentum is compared to a max value so that we don't go too fast
        let velocity = gesture.velocity(in: gesture.view)
        let momentum: CGFloat = abs(velocity.y)
        let springVelocity = min(momentum, 3.0) // 3.0 arbitrarily decided through manual testing

        /// if the user's finger is not moving, we expand/collapse based on current progress
        /// otherwise, we use velocity to determine which direction to move the header
        let expanding: Bool
        if velocity.y == 0.0 {
            let currentProgress = shyHeaderView.exposure.progress
            expanding = currentProgress >= 0.5
        } else {
            expanding = velocity.y >= 0.0
        }

        let progress: CGFloat = expanding ? 1.0 : 0.0

        UIView.animate(withDuration: MSShyHeaderController.Constants.headerShowHideAnimationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: springVelocity,
                       options: [.curveLinear, .allowUserInteraction],
                       animations: {
                        self.updateHeader(with: progress, expanding: expanding)
        }, completion: nil)
    }

    // MARK: - Shy Behavior Helpers

    /// Shows the accessoryContent, if the content provider has given us one
    func expandAccessory() {
        UIView.animate(withDuration: MSShyHeaderController.Constants.headerShowHideAnimationDuration,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.updateHeader(with: 1.0, expanding: true)
        }, completion: nil)
    }

    /// Hides the accessoryContent, if the content provider has given us one
    func contractAccessory() {
        // Note: unlike the expansion request, we don't care if the accessory container is empty for contractions
        UIView.animate(withDuration: MSShyHeaderController.Constants.headerShowHideAnimationDuration,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.updateHeader(with: 0.0, expanding: false)
        }, completion: nil)
    }

    /// Sets the animation progress, using progress as a fraction not a percent
    /// 0.0 == concealed, 1.0 == exposed
    ///
    /// - Parameter progress: progress, represented as a fraction (0.5) not a percent (50.0)
    private func updateHeader(with progress: CGFloat, expanding: Bool) {
        //fall out to ignore repeated animations resulting in the same layout
        guard shyHeaderView.exposure.progress != progress else {
            return
        }

        calculateAndSetNewShyContainerTopConstraint(withProgress: progress)

        //passes appropriate call to delegate
        if expanding { //we always want to begin the expansion animations if the progress is expanding
            msNavigationController?.msNavigationBar.expand(true)
        } else if progress <= 0.0 { //we only want to contract if the progress is contracting AND zero/negative AKA never contract during positive progress
            msNavigationController?.msNavigationBar.contract(true)
        }

        shyHeaderView.exposure = MSShyHeaderView.ShyViewExposure(withProgress: progress)
    }

    /// Calculates and sets the shy container's top constraint's constant value, moving the header
    ///
    /// - Parameter progress: fraction of exposure, used to calculate the top constraint's constant
    private func calculateAndSetNewShyContainerTopConstraint(withProgress progress: CGFloat) {
        let prospectiveHeight = shyHeaderView.maxHeight * progress //fraction of the height value
        let newHeight = prospectiveHeight > 0.0 ? prospectiveHeight : 0.0 //guarantee its above a min value (0.0)
        let constant = (-1.0 * shyHeaderView.maxHeight) + newHeight //the layout is acheived by raising the top of the shyHeader, so layout constants are negative

        shyViewTopConstraint?.constant = constant
        shyHeaderView.setNeedsLayout()
        view.layoutIfNeeded()
    }

    /// We can occasionally find ourselves in scenarios where the header is concealed when a collection's contentSize is updated to a smaller-than-driving-shy-behavior size
    /// To guarantee that the user will be able to get the header exposed in such a scenario, we perform a check here
    ///
    /// If the header is concealed, and the swipe is down PAST the top of the content, we expose the header again
    /// This check occurs within the guard for "shouldDriveShyBehavior", so that this does not interfere with normal shy behavior
    ///
    /// - Parameter scrollView: the scrollView driving shy behavior
    private func confirmProperExposure(givenScrollView scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let yOffset = offset.y
        let scrollDirection: UIScrollView.VerticalScrollDirection = previousContentScrollViewTraits.yOffset > yOffset ? .up : .down

        if shyHeaderView.exposure == MSShyHeaderView.ShyViewExposure.concealed
            && scrollDirection == .up
            && yOffset < 0 { // if we encounter a scenario where we're concealed, but the content doesn't support shy behavior, we want to guarantee we've expanded if the user scrolls down the list
            UIView.animate(withDuration: MSShyHeaderController.Constants.headerShowHideAnimationDuration,
                           delay: 0.0,
                           options: .allowUserInteraction,
                           animations: {
                            self.updateHeader(with: 1.0, expanding: true)
            }, completion: nil)
        }
    }

    /// Evaluates if the provided parameters should drive the shy behavior (opening/closing the Large Header accessory)
    ///
    /// Decision making:
    /// 1. if the gesture is in the expected state
    /// 2. if we have a contentVC
    /// 3. if the contentVC wants shy behavior at all (some don't)
    /// 4. if the scrollView has enough content to warrant shy behavior (size < frame == no shy)
    ///
    /// - Parameter scrollView: the scrollView in which the gesture is occurring
    /// - Parameter gesture: the current user-interacted gesture, which may need to power a shy behavior
    /// - Parameter expectedState: the state in which the gesture should be, given the caller of the method
    /// - Returns: true if the parameters provided should drive shy behavior
    private func shyBehaviorCalculationsShouldProceed(inScrollView scrollView: UIScrollView) -> Bool {
        // unchanged offset, no action needed
        guard scrollView.contentOffset.y != previousContentScrollViewTraits.yOffset else {
            return false
        }

        // fall out if we dont need to worry about the shy behavior based on content size
        guard scrollViewContentSizeShouldDriveShyBehavior(scrollView: scrollView) else {
            confirmProperExposure(givenScrollView: scrollView)
            return false
        }

        return true
    }

    /// Evaluates if the provided parameters should drive the shy behavior (opening/closing the Large Header accessory)
    ///
    /// Decision making:
    /// 1. if the gesture is in the expected state
    /// 2. if we have a contentVC
    /// 3. if the contentVC wants shy behavior at all (some don't)
    /// 4. if the scrollView has enough content to warrant shy behavior (size < frame == no shy)
    ///
    /// - Parameter scrollView: the scrollView in which the gesture is occurring
    /// - Parameter gesture: the current user-interacted gesture, which may need to power a shy behavior
    /// - Parameter expectedState: the state in which the gesture should be, given the caller of the method
    /// - Returns: true if the parameters provided should drive shy behavior
    private func shyBehaviorCalculationsShouldProceed(inScrollView scrollView: UIScrollView, forGestureRecognizer gesture: UIGestureRecognizer, withExpectedState expectedState: UIGestureRecognizer.State) -> Bool {
        guard gesture.state == expectedState else {
            return false
        }

        // fall out if we dont need to worry about the shy behavior based on content size
        guard scrollViewContentSizeShouldDriveShyBehavior(scrollView: scrollView) else {
            confirmProperExposure(givenScrollView: scrollView)
            return false
        }

        return true
    }

    /// Determines if the provided scrollview has enoguh content to drive a shy behavior
    ///
    /// returns false if the content of the scroll view is smaller than or equal to the size of the scrollView, minus the value of the shy header
    ///
    /// - Parameter scrollView: the scrollview driving shy behavior
    /// - Returns: if the scrollview contains enough content to drive shy behavior
    private func scrollViewContentSizeShouldDriveShyBehavior(scrollView: UIScrollView) -> Bool {
        // shyHeader.height has to be subtracted because when the header has been hidden, the scrollView's height increases by that size
        // in that scenario, the height that allowed a contraction will differ from the height calculated in the expansion
        // you can end up with a scenario where the contraction occurs but the subsequent expansion cannot
        let totalContentHeight = scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom
        let progress = shyHeaderView.exposure.progress
        let availableScrollHeight = scrollView.frame.size.height - scrollView.safeAreaInsets.bottom - (shyHeaderView.frame.size.height * (1.0 - progress))

        return totalContentHeight > availableScrollHeight
    }
}
