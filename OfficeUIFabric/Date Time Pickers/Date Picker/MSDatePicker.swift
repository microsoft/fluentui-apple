//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSDatePickerHeaderStyle

@objc public enum MSDatePickerHeaderStyle: Int {
    case light
    case dark
}

// MARK: - MSDatePickerDelegate

/// Allows a class to be notified when a user confirms their selected date
public protocol MSDatePickerDelegate: class {
    func datePicker(_ datePicker: MSDatePicker, didPickDate date: Date)
}

// MARK: - MSDatePicker

/// A view controller that can present itself modally to display a calendar used for picking a date, with a navigation bar with title.
open class MSDatePicker: UIViewController {
    private struct Constants {
        // TODO: Make title button width dynamic
        static let titleButtonWidth: CGFloat = 160
        static let preloadAvailabilityDaysOffset = 30
    }

    /// The currently selected whole date. Automatically changes to start of day when set.
    open var date: Date {
        get {
            return contentController.startDate as Date
        }
        set {
            let startDate = newValue.startOfDay
            contentController.setup(startDate: startDate, endDate: startDate.adding(hours: 23, minutes: 59))
            updateNavigationBar()
        }
    }

    public weak var delegate: MSDatePickerDelegate?

    private var titleView: MSTwoLinesTitleView!
    private let subtitle: String?
    private var contentController: MSDatePickerController!

    // TODO: Add availability back in? - contactAvailabilitySummaryDataSource: ContactAvailabilitySummaryDataSource?,

    /// Creates and sets up a calendar-style date picker, with a specified date shown first.
    ///
    /// - Parameters:
    ///   - initialDate: A date object on the day chosen to be selected.
    ///   - overrideSubtitle: An optional string describing an optional subtitle for this date picker.
    public init(initialDate: Date, subtitle: String? = nil) {
        self.subtitle = subtitle

        super.init(nibName: nil, bundle: nil)

        let selectedDate = initialDate.startOfDay
        initContentController(startDate: selectedDate, endDate: selectedDate.adding(hours: 23, minutes: 59), selectionMode: .start)
        initTitleView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Presents this date picker over the selected view controller, using a card modal style.
    ///
    /// - Parameter parentViewController: The view controller the date picker will be presented on top of
    public func present(from presentingViewController: UIViewController) {
        let navController = MSCardPresenterNavigationController(rootViewController: self)
        let pageCardPresenterVC = MSPageCardPresenterController(viewControllers: [navController], startingIndex: 0)

        pageCardPresenterVC.onDismiss = {
            presentingViewController.dismiss(animated: true)
        }

        presentingViewController.present(pageCardPresenterVC, animated: true)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        addChildController(contentController)
        initNavigationBar()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateTitleFrame()

        contentController.view.frame = view.bounds
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide default bottom border of navigation bar
        navigationController?.navigationBar.hideBottomBorder()
    }

    // MARK: Create components

    private func initTitleView() {
        titleView = MSTwoLinesTitleView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTitleButtonTapped))
        titleView.addGestureRecognizer(tapRecognizer)

        updateNavigationBar()
    }

    private func initContentController(startDate: Date, endDate: Date, selectionMode: MSDatePickerSelectionManager.SelectionMode) {
        contentController = MSDatePickerController(
            startDate: startDate,
            endDate: endDate,
            selectionMode: selectionMode
        )
        contentController.delegate = self
    }

    // MARK: Add components to hierarchy

    private func initNavigationBar() {
        let bundle = Bundle(for: MSDatePicker.self)
        if let image = UIImage(named: "checkmark-blue-25x25", in: bundle, compatibleWith: nil),
            let landscapeImage = UIImage(named: "checkmark-blue-thin-20x20", in: bundle, compatibleWith: nil) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: self, action: #selector(handleDidTapDone))
        }
        if let image = UIImage(named: "back-25x25", in: bundle, compatibleWith: nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDidTapBack))
            navigationItem.leftBarButtonItem?.tintColor = MSColors.gray
        }
        navigationItem.titleView = titleView
    }

    // MARK: Update components

    private func updateNavigationBar() {
        let title = String.dateString(from: contentController.focusDate, compactness: .shortDaynameShortMonthnameDay)
        titleView.setup(title: title, subtitle: subtitle)
        updateTitleFrame()
    }

    private func updateTitleFrame() {
        // Title
        if let navigationController = navigationController {
            titleView.frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: Constants.titleButtonWidth,
                height: navigationController.navigationBar.height
            )
        }
    }

    // MARK: Handlers

    @objc private func handleTitleButtonTapped() {
        contentController.scrollToStartDate(animated: true)
    }

    @objc private func handleDidTapDone() {
        delegate?.datePicker(self, didPickDate: date)
    }

    @objc private func handleDidTapBack() {
        parent?.dismiss(animated: true)
    }
}

// MARK: - MSDatePicker: MSDatePickerControllerDelegate

extension MSDatePicker: MSDatePickerControllerDelegate {
    func datePickerController(_ datePickerController: MSDatePickerController, didSelectDate: Date) {
        updateNavigationBar()
        // TODO: Add delegate call for notifying date did change
    }
}

// MARK: - MSDatePicker: MSCardPresentable

extension MSDatePicker: MSCardPresentable {
    public func idealSize() -> CGSize {
        return contentController.idealSize()
    }
}
