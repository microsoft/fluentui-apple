//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSDatePickerHeaderStyle

@objc enum MSDatePickerHeaderStyle: Int {
    case light
    case dark
}

// MARK: - MSDatePickerController

/// Represents a date picker, that enables the user to scroll through years vertically week by week.
/// The user can select a date or a range of dates.
class MSDatePickerController: UIViewController, DateTimePicker {
    private struct Constants {
        static let idealWidth: CGFloat = 343
        // TODO: Make title button width dynamic
        static let titleButtonWidth: CGFloat = 160
    }

    var startDate = Date() {
        didSet {
            startDate = mode.includesTime ? startDate : startDate.startOfDay
            selectionManager.startDate = startDate
            // If endDate goes past the visible dates, scroll the startDate up
            if let visibleDates = visibleDates,
                selectionManager.endDate > visibleDates.endDate {
                scrollToStartDate(animated: true)
            }
            updateSelectionOfVisibleCells()
            updateNavigationBar()
        }
    }

    var endDate = Date() {
        didSet {
            endDate = mode.includesTime ? endDate : endDate.startOfDay
            selectionManager.endDate = endDate
            updateSelectionOfVisibleCells()
            updateNavigationBar()
        }
    }

    var visibleDates: (startDate: Date, endDate: Date)? {
        let contentOffset = calendarView.collectionView.contentOffset
        return visibleDates(at: CGPoint(x: 0, y: contentOffset.y))
    }

    var focusDate: Date {
        return selectionManager.selectionMode == .start ? startDate : endDate
    }

    private(set) var selectionManager: MSDatePickerSelectionManager!

    weak var delegate: DateTimePickerDelegate?

    private let mode: MSDateTimePickerMode

    private var titleView: MSTwoLinesTitleView!
    private let subtitle: String?

    private var monthOverlayIsShown: Bool = false
    private var reloadDataAfterOverlayIsNeeded: Bool = false

    private let calendarView = MSCalendarView()
    private var calendarViewDataSource: MSCalendarViewDataSource!

    // TODO: Add availability back in? - contactAvailabilitySummaryDataSource: ContactAvailabilitySummaryDataSource?,

    /// Creates and sets up a calendar-style date picker, with a specified date shown first.
    ///
    /// - Parameters:
    ///   - startDate: A date object for the start day or day/time to be initially selected.
    ///   - endDate: A date object for an end day or day/time to be initially selected.
    ///   - datePickerMode: The MSDateTimePicker mode this is presented in.
    ///   - selectionMode: The side (start or end) of the current range to be selected on this picker.
    ///   - subtitle: An optional string describing an optional subtitle for this date picker.
    init(startDate: Date, endDate: Date, mode: MSDateTimePickerMode, selectionMode: MSDatePickerSelectionManager.SelectionMode = .start, subtitle: String? = nil) {
        self.subtitle = subtitle
        self.mode = mode
        super.init(nibName: nil, bundle: nil)

        defer {
            self.startDate = startDate
            self.endDate = endDate
        }

        calendarViewDataSource = MSCalendarViewDataSource(styleDataSource: self)

        let startDate = startDate.startOfDay
        selectionManager = MSDatePickerSelectionManager(
            dataSource: calendarViewDataSource,
            startDate: startDate,
            endDate: endDate,
            selectionMode: selectionMode
        )

        initTitleView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.weekdayHeadingView.setup(horizontalSizeClass: traitCollection.horizontalSizeClass, firstWeekday: MSCalendarConfiguration.default.firstWeekday)

        let collectionView = calendarView.collectionView

        collectionView.register(MSCalendarViewMonthBannerView.self, forSupplementaryViewOfKind: MSCalendarViewMonthBannerView.supplementaryElementKind, withReuseIdentifier: MSCalendarViewMonthBannerView.reuseIdentifier)

        collectionView.register(MSCalendarViewDayCell.self, forCellWithReuseIdentifier: MSCalendarViewDayCell.identifier)
        collectionView.register(MSCalendarViewDayMonthCell.self, forCellWithReuseIdentifier: MSCalendarViewDayMonthCell.identifier)
        collectionView.register(MSCalendarViewDayMonthYearCell.self, forCellWithReuseIdentifier: MSCalendarViewDayMonthYearCell.identifier)
        collectionView.register(MSCalendarViewDayTodayCell.self, forCellWithReuseIdentifier: MSCalendarViewDayTodayCell.identifier)

        collectionView.dataSource = calendarViewDataSource
        collectionView.delegate = self

        calendarView.collectionViewLayout.delegate = self

        view.addSubview(calendarView)

        initNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollToStartDate(animated: false)

        // Hide default bottom border of navigation bar
        navigationController?.navigationBar.hideBottomBorder()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        calendarView.frame = view.bounds
    }

    private func initTitleView() {
        titleView = MSTwoLinesTitleView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTitleButtonTapped))
        titleView.addGestureRecognizer(tapRecognizer)

        updateNavigationBar()
    }

    private func initNavigationBar() {
        if let image = UIImage.staticImageNamed("checkmark-blue-25x25"),
            let landscapeImage = UIImage.staticImageNamed("checkmark-blue-thin-20x20") {
            let doneButton = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: self, action: #selector(handleDidTapDone))
            doneButton.accessibilityLabel = "Accessibility.Done.Label".localized
            navigationItem.rightBarButtonItem = doneButton
        }
        navigationItem.titleView = titleView
    }

    private func updateNavigationBar() {
        let title = String.dateString(from: focusDate, compactness: .shortDaynameShortMonthnameDay)
        titleView.setup(title: title, subtitle: subtitle)
        updateTitleFrame()
    }

    private func updateTitleFrame() {
        if let navigationController = navigationController {
            titleView.frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: Constants.titleButtonWidth,
                height: navigationController.navigationBar.height
            )
        }
    }

    private func scrollToStartDate(animated: Bool) {
        let targetIndexPath = IndexPath(item: 0, section: max(selectionManager.startDateIndexPath.section - 1, 0))
        calendarView.collectionView.scrollToItem(at: targetIndexPath, at: [.top], animated: animated)
        // TODO: Notify of visible date?
    }

    private func setNeedsReloadAvailability() {
        reloadDataAfterOverlayIsNeeded = true
        reloadDataAfterOverlayHiddenIfNeeded()
    }

    private func reloadDataAfterOverlayHiddenIfNeeded() {
        if reloadDataAfterOverlayIsNeeded && !monthOverlayIsShown {
            reloadDataAfterOverlayIsNeeded = false
            calendarView.collectionView.reloadData()
        }
    }

    private func reloadData() {
        calendarViewDataSource.reload()
        calendarView.collectionView.reloadData()
    }

    private func visibleDates(at contentOffset: CGPoint) -> (startDate: Date, endDate: Date)? {
        let collectionView = calendarView.collectionView
        let maxStartContentOffsetY = collectionView.contentSize.height - collectionView.height
        let startPoint = CGPoint(x: contentOffset.x, y: min(max(contentOffset.y, 0), maxStartContentOffsetY))
        let endPoint = CGPoint(x: collectionView.width - 1, y: startPoint.y + collectionView.height - 1)

        guard let startIndexPath = collectionView.indexPathForItem(at: startPoint),
            let endIndexPath = collectionView.indexPathForItem(at: endPoint) else {
            return nil
        }

        let startDate = calendarViewDataSource.dayStart(forDayAt: startIndexPath)
        let endDate = calendarViewDataSource.dayEnd(forDayAt: endIndexPath)
        return (startDate: startDate, endDate: endDate)
    }

    // MARK: Handlers

    @objc private func handleTitleButtonTapped() {
        scrollToStartDate(animated: true)
    }

    @objc private func handleDidTapDone() {
        dismiss()
    }
}

// MARK: - MSDatePickerController: UICollectionViewDelegate

extension MSDatePickerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let monthBannerView = view as? MSCalendarViewMonthBannerView else {
            return
        }

        monthBannerView.setVisible(monthOverlayIsShown, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let dayCell = cell as? MSCalendarViewDayCell else {
            return
        }

        dayCell.setVisualState((monthOverlayIsShown ? .fadedWithDots : .normal), animated: false)

        updateSelectionOfVisibleCells()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didTapItem(at: indexPath)
    }

    func didTapItem(at indexPath: IndexPath) {
        // Update selection of visible cells
        selectionManager.setSelectedIndexPath(indexPath)
        updateDates()
        updateSelectionOfVisibleCells()

        delegate?.dateTimePicker(self, didSelectStartDate: startDate, endDate: endDate)

        updateNavigationBar()
    }

    private func updateDates() {
        // If time is included, combine the day/month/year components of selectionManager with the time components from the old date. Ensures we don't lose the time, since selection manager only holds day releated components.
        if mode.includesTime, let newStartDate = selectionManager.startDate.combine(withTime: startDate) {
            startDate = newStartDate
        } else {
            startDate = selectionManager.startDate
        }
        if mode.singleSelection {
            endDate = startDate
        } else if mode.includesTime, let newEndDate = selectionManager.endDate.combine(withTime: endDate) {
            endDate = newEndDate
        } else {
            endDate = selectionManager.endDate
        }
    }

    private func updateSelectionOfVisibleCells() {
        for visibleIndexPath in calendarView.collectionView.indexPathsForVisibleItems {
            updateSelectionOfCell(at: visibleIndexPath)
        }
    }

    private func updateSelectionOfCell(at indexPath: IndexPath) {
        let collectionView = calendarView.collectionView

        if let selectionType = selectionManager.selectionType(for: indexPath),
            let cell = collectionView.cellForItem(at: indexPath) as? MSCalendarViewDayCell {
            cell.setSelectionType(selectionType)

            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition())
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
}

// MARK: - MSDatePickerController: UIScrollViewDelegate

extension MSDatePickerController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        changeMonthOverlayVisibility(true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // TODO: Notify of moving to date?
        // if let (startDate, endDate) = visibleDatesOnContentOffset(CGPoint(x: 0, y: targetContentOffset.pointee.y)) { }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
           changeMonthOverlayVisibility(false)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeMonthOverlayVisibility(false)
    }

    private func changeMonthOverlayVisibility(_ visible: Bool) {
        guard visible != monthOverlayIsShown else {
            return
        }
        monthOverlayIsShown = visible

        for monthBannerViewValue in calendarViewDataSource.monthBannerViewSet {
            if let monthBannerView = monthBannerViewValue.nonretainedObjectValue as? MSCalendarViewMonthBannerView {
                monthBannerView.setVisible(visible, animated: true)
            }
        }

        for cell in calendarView.collectionView.visibleCells {
            if let dayCell = cell as? MSCalendarViewDayCell {
                dayCell.setVisualState(visible ? .fadedWithDots : .normal, animated: true)
            }
        }
    }
}

// MARK: - MSDatePickerController: MSCalendarViewLayoutDelegate

extension MSDatePickerController: MSCalendarViewLayoutDelegate {
    func calendarViewLayout(_ calendarViewLayout: MSCalendarViewLayout, shouldShowMonthBannerForSectionIndex sectionIndex: Int) -> Bool {
        let firstDayStartDateOfWeek = calendarViewDataSource.dayStart(forDayAt: IndexPath(item: 0, section: sectionIndex))
        let weekOfMonth = calendarViewDataSource.calendar.component(.weekOfMonth, from: firstDayStartDateOfWeek)
        return weekOfMonth == 3
    }
}

// MARK: - MSDatePickerController: MSCalendarViewStyleDataSource

extension MSDatePickerController: MSCalendarViewStyleDataSource {
    func calendarViewDataSource(_ dataSource: MSCalendarViewDataSource, textStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents) -> MSCalendarViewDayCellTextStyle {

        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: MSCalendarViewDataSource, backgroundStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents
        ) -> MSCalendarViewDayCellBackgroundStyle {

        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: MSCalendarViewDataSource, selectionStyleForDayWithStart dayStartDate: Date, end: Date) -> MSCalendarViewDayCellSelectionStyle {
        return .normal
    }
}

// MARK: - MSDatePickerController: MSCardPresentable

extension MSDatePickerController: MSCardPresentable {
    func idealSize() -> CGSize {
        return CGSize(width: Constants.idealWidth, height: calendarView.height(for: .extraTall, in: view.bounds))
    }
}
