//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PageCardPresenter Colors

private extension Colors {
    struct PageCardPresenter {
        // Should use physical color because page indicators are shown on physical blurred dark background
        static var currentPageIndicator: UIColor = .white
        static var pageIndicator = UIColor.white.withAlphaComponent(0.5)
    }
}

// MARK: - CardPresentable

protocol CardPresentable: AnyObject {
    func idealSize() -> CGSize
}

// MARK: - PageCardPresenterController

@available(*, deprecated, renamed: "PageCardPresenterController")
public typealias MSPageCardPresenterController = PageCardPresenterController

/**
 Presents viewController views as "cards" in a paged scrollView
 */
@objc(MSFPageCardPresenterController)
open class PageCardPresenterController: UIViewController {
    private struct Constants {
        static let cornerRadius: CGFloat = 14
        static let minMargin: CGFloat = 16
        static let maxWidth: CGFloat = 353
        static let pageControlVerticalMargin: CGFloat = 20
        static let pageControlVerticalMarginCompact: CGFloat = 5
    }

    open override var modalPresentationStyle: UIModalPresentationStyle { get { return .custom } set { } }
    open override var transitioningDelegate: UIViewControllerTransitioningDelegate? { get { return self } set { } }

    var onDismiss: (() -> Void)?
    var onSwitchToNewViewController: ((UIViewController, Int) -> Void)?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = Colors.PageCardPresenter.pageIndicator
        pageControl.currentPageIndicatorTintColor = Colors.PageCardPresenter.currentPageIndicator
        return pageControl
    }()

    private let dismissView: UIView = {
        let view = UIView()
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Accessibility.Dismiss.Label".localized
        view.accessibilityHint = "Accessibility.Dismiss.Hint".localized
        view.accessibilityTraits = .button
        return view
    }()

    private let viewControllers: [UIViewController]
    private let startingIndex: Int
    private var currentlyVisibleIndex: Int

    init(viewControllers: [UIViewController], startingIndex: Int = 0) {
        self.viewControllers = viewControllers
        self.startingIndex = startingIndex
        self.currentlyVisibleIndex = startingIndex

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        pageControl.numberOfPages = viewControllers.count

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissViewTapped))
        tapRecognizer.cancelsTouchesInView = false
        dismissView.addGestureRecognizer(tapRecognizer)

        pageControl.addTarget(self, action: #selector(handlePageControlChanged), for: .valueChanged)

        scrollView.addSubview(dismissView)

        view.addSubview(scrollView)
        view.addSubview(pageControl)

        for viewController in viewControllers {
            addChild(viewController)
            scrollView.addSubview(viewController.view)
            styleCardView(viewController.view)
            viewController.didMove(toParent: self)
        }

        updateViewAccessibilityElements()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        pageControl.currentPage = startingIndex
        handlePageControlChanged()
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let positionRatio = scrollView.contentOffset.x / max(1, scrollView.contentSize.width)

        // Use bounds and position because CardPresenterTransitionAnimator applies a transform on the scrollView
        scrollView.bounds = view.bounds
        scrollView.layer.position = CGPoint(
            x: round(view.frame.width * scrollView.layer.anchorPoint.x),
            y: round(view.frame.height * scrollView.layer.anchorPoint.y)
        )
        scrollView.contentSize = CGSize(width: CGFloat(viewControllers.count) * scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.contentOffset = CGPoint(x: positionRatio * scrollView.contentSize.width, y: 0)

        dismissView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.frame.height)

        pageControl.sizeToFit()
        pageControl.frame.origin.y = view.frame.maxY - Constants.pageControlVerticalMargin - pageControl.frame.height

        for (index, viewController) in viewControllers.enumerated() {
            guard let cardView = viewController.view else {
                continue
            }
            if let card = viewController as? CardPresentable {
                cardView.frame = frameForCard(card)
            } else {
                cardView.frame = view.bounds
            }

            // Use bounds because scroll view might have a transform applied on it
            cardView.frame.origin.x += round(CGFloat(index) * scrollView.bounds.width)

            // Check if the pageControl has at least equal spacing between
            // the bottom of the view and the bottom of the cardView
            let currentPageControlBottomMargin = view.frame.maxY - pageControl.frame.maxY
            if cardView.frame.maxY + currentPageControlBottomMargin > pageControl.frame.origin.y {
                // Use smaller spacing between view bottom
                pageControl.frame.origin.y = view.frame.maxY - Constants.pageControlVerticalMarginCompact - pageControl.frame.height

                // adjust the height of the cardView to acommodate the pageControl
                let maxHeight = view.frame.height - 2 * (pageControl.frame.height + 2 * Constants.pageControlVerticalMarginCompact)
                cardView.frame.size.height = min(cardView.frame.height, maxHeight)
                cardView.frame.origin.y = round((view.frame.height - cardView.frame.height) / 2)
            }
        }

        scrollView.flipSubviewsForRTL()
    }

    private func styleCardView(_ view: UIView) {
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
    }

    private func sizeForCard(_ card: CardPresentable) -> CGSize {
        var size = card.idealSize()
        let idealWidth = min(size.width, view.frame.width - Constants.minMargin * 2)
        let idealHeight = min(size.height, view.frame.height - Constants.minMargin * 2)
        size.width = min(idealWidth, Constants.maxWidth)
        size.height = idealHeight
        return size
    }

    private func frameForCard(_ card: CardPresentable) -> CGRect {
        let size = sizeForCard(card)
        return CGRect(
            x: UIScreen.main.roundToDevicePixels((view.frame.width - size.width) / 2),
            y: UIScreen.main.roundToDevicePixels((view.frame.height - size.height) / 2),
            width: size.width,
            height: size.height
        )
    }

    @objc private func handlePageControlChanged() {
        let pageIndex = flipPageIndexForRTL(pageControl.currentPage)
        view.layoutIfNeeded()
        scrollView.contentOffset = CGPoint(x: CGFloat(pageIndex) * scrollView.bounds.width, y: 0)
        updateViewAccessibilityElements()
    }

    @objc private func handleDismissViewTapped() {
        onDismiss?()
    }

    private func flipPageIndexForRTL(_ pageIndex: Int) -> Int {
        if scrollView.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            return pageControl.numberOfPages - 1 - pageIndex
        } else {
            return pageIndex
        }
    }

    private func updateViewAccessibilityElements() {
        let currentViewController = viewControllers[pageControl.currentPage]
        view.accessibilityElements = [currentViewController.view!, dismissView]
    }

    private func switchToNewViewControllerIfNeeded() {
        let newIndex = pageControl.currentPage

        if newIndex == currentlyVisibleIndex {
            return
        }

        let newVC = viewControllers[newIndex]
        onSwitchToNewViewController?(newVC, newIndex)
    }
}

// MARK: - PageCardPresenterController: UIScrollViewDelegate

extension PageCardPresenterController: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = scrollView.frame.width
        let targetIndex = Int(targetContentOffset.pointee.x / pageWidth)
        pageControl.currentPage = flipPageIndexForRTL(targetIndex)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switchToNewViewControllerIfNeeded()
        currentlyVisibleIndex = pageControl.currentPage
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            switchToNewViewControllerIfNeeded()
            currentlyVisibleIndex = pageControl.currentPage
        }
    }
}

// MARK: - PageCardPresenterController: UIViewControllerTransitioningDelegate

extension PageCardPresenterController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardTransitionAnimator(presenting: true, scaledView: scrollView, sourceView: nil, sourceRect: .zero)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardTransitionAnimator(presenting: false, scaledView: scrollView, sourceView: nil, sourceRect: .zero)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
