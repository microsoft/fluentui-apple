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
        static let calendarHeightStyle: CalendarViewHeightStyle = .extraTall
    }

    var startDate = Date() {
        didSet {
            startDate = mode.includesTime ? startDate : startDate.startOfDay
            selectionManager.startDate = startDate
            if !entireRangeIsVisible {
                scrollToFocusDate(animated: true)
            }
            updateSelectionOfVisibleCells()
            updateNavigationBar()
        }
    }

    var endDate = Date() {
        didSet {
            endDate = mode.includesTime ? endDate : endDate.startOfDay
            selectionManager.endDate = endDate
            if !entireRangeIsVisible {
                scrollToFocusDate(animated: true)
            }
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

    private var titleView: MSTwoLineTitleView!
    private let customTitle: String?
    private let customSubtitle: String?
    private let customStartTabTitle: String?
    private let customEndTabTitle: String?

    private var monthOverlayIsShown: Bool = false
    private var reloadDataAfterOverlayIsNeeded: Bool = false

    private let calendarView = CalendarView()
    private var calendarViewDataSource: CalendarViewDataSource!
    private var segmentedControl: MSSegmentedControl?

    private var entireRangeIsVisible: Bool {
        guard let visibleDates = visibleDates else {
            return false
        }
        return selectionManager.endDate <= visibleDates.endDate && selectionManager.startDate >= visibleDates.startDate
    }

    // TODO: Add availability back in? - contactAvailabilitySummaryDataSource: ContactAvailabilitySummaryDataSource?,

    /// Creates and sets up a calendar-style date picker, with a specified date shown first.
    ///
    /// - Parameters:
    ///   - startDate: A date object for the start day or day/time to be initially selected.
    ///   - endDate: A date object for an end day or day/time to be initially selected.
    ///   - datePickerMode: The MSDateTimePicker mode this is presented in.
    ///   - selectionMode: The side (start or end) of the current range to be selected on this picker.
    ///   - rangePresentation: The `DateRangePresentation` in which this controller is being presented if `mode` is `.dateRange` or `.dateTimeRange`.
    ///   - titles: A `Titles` object that holds strings for use in overriding the default picker title, subtitle, and tab titles. If title is not provided, titleview will show currently selected date. If tab titles are not provided, they will default to "Start Date" and "End Date".
    init(startDate: Date, endDate: Date, mode: MSDateTimePickerMode, selectionMode: MSDatePickerSelectionManager.SelectionMode = .start, rangePresentation: MSDateTimePicker.DateRangePresentation, titles: MSDateTimePicker.Titles?) {
        if !mode.singleSelection && rangePresentation == .paged {
            customTitle = selectionMode == .start ? titles?.startTitle : titles?.endTitle
            customSubtitle = selectionMode == .start ?
                titles?.startSubtitle ?? "MSDateTimePicker.StartDate".localized :
                titles?.endSubtitle ?? "MSDateTimePicker.EndDate".localized
        } else {
            customTitle = titles?.dateTitle
            customSubtitle = titles?.dateSubtitle
        }
        customStartTabTitle = titles?.startTab
        customEndTabTitle = titles?.endTab
        self.mode = mode

        super.init(nibName: nil, bundle: nil)

        defer {
            self.startDate = startDate
            self.endDate = endDate
        }

        calendarViewDataSource = CalendarViewDataSource(styleDataSource: self)

        let startDate = startDate.startOfDay
        selectionManager = MSDatePickerSelectionManager(
            dataSource: calendarViewDataSource,
            startDate: startDate,
            endDate: endDate,
            selectionMode: selectionMode
        )

        initTitleView()

        if !mode.singleSelection && rangePresentation == .tabbed {
            initSegmentedControl()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.weekdayHeadingView.setup(horizontalSizeClass: traitCollection.horizontalSizeClass, firstWeekday: MSCalendarConfiguration.default.firstWeekday)

        let collectionView = calendarView.collectionView

        collectionView.register(MSCalendarViewMonthBannerView.self, forSupplementaryViewOfKind: MSCalendarViewMonthBannerView.supplementaryElementKind, withReuseIdentifier: MSCalendarViewMonthBannerView.reuseIdentifier)

        collectionView.register(CalendarViewDayCell.self, forCellWithReuseIdentifier: CalendarViewDayCell.identifier)
        collectionView.register(MSCalendarViewDayMonthCell.self, forCellWithReuseIdentifier: MSCalendarViewDayMonthCell.identifier)
        collectionView.register(MSCalendarViewDayMonthYearCell.self, forCellWithReuseIdentifier: MSCalendarViewDayMonthYearCell.identifier)
        collectionView.register(MSCalendarViewDayTodayCell.self, forCellWithReuseIdentifier: MSCalendarViewDayTodayCell.identifier)

        collectionView.dataSource = calendarViewDataSource
        collectionView.delegate = self

        calendarView.collectionViewLayout.delegate = self

        if let segmentedControl = segmentedControl {
            view.addSubview(segmentedControl)
        }
        view.addSubview(calendarView)

        initNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollToFocusDate(animated: false)

        if segmentedControl == nil {
            // Hide default bottom border of navigation bar
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var calendarFrame = view.bounds
        if let segmentedControl = segmentedControl {
            var frame = calendarFrame
            frame.size.height = segmentedControl.intrinsicContentSize.height
            calendarFrame = calendarFrame.inset(by: UIEdgeInsets(top: frame.height, left: 0, bottom: 0, right: 0))

            segmentedControl.frame = frame
        }
        calendarView.frame = calendarFrame
    }

    private func initTitleView() {
        titleView = MSTwoLineTitleView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTitleButtonTapped))
        titleView.addGestureRecognizer(tapRecognizer)

        updateNavigationBar()
    }

    private func initNavigationBar() {
        navigationItem.rightBarButtonItem = MSBarButtonItems.confirm(target: self, action: #selector(handleDidTapDone))
        navigationItem.titleView = titleView
    }

    private func initSegmentedControl() {
        let titles = [customStartTabTitle ?? "MSDateTimePicker.StartDate".localized,
                      customEndTabTitle ?? "MSDateTimePicker.EndDate".localized]
        segmentedControl = MSSegmentedControl(items: titles)
        segmentedControl?.addTarget(self, action: #selector(handleDidSelectStartEnd(_:)), for: .valueChanged)
    }

    private func updateNavigationBar() {
        let title = customTitle ?? String.dateString(from: focusDate, compactness: .shortDaynameShortMonthnameDay)
        titleView.setup(title: title, subtitle: customSubtitle)
        updateTitleFrame()
    }

    private func updateTitleFrame() {
        if let navigationController = navigationController {
            titleView.frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: Constants.titleButtonWidth,
                height: navigationController.navigationBar.frame.height
            )
        }
    }

    private func scrollToFocusDate(animated: Bool) {
        let numberOfRows = Int(calendarView.rows(for: Constants.calendarHeightStyle))
        let selectionFitsInCalendar = selectionManager.endDateIndexPath.section - selectionManager.startDateIndexPath.section <= numberOfRows - 1
        let focusDateRow: Int
        let rowOffset: Int
        if selectionManager.selectionMode == .start || selectionFitsInCalendar {
            focusDateRow = selectionManager.startDateIndexPath.section
            rowOffset = 1
        } else {
            focusDateRow = selectionManager.endDateIndexPath.section
            rowOffset = max(numberOfRows - 2, 1)
        }
        guard focusDateRow < calendarView.collectionView.numberOfSections else {
            return
        }
        let targetIndexPath = IndexPath(item: 0, section: max(focusDateRow - rowOffset, 0))
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
        let maxStartContentOffsetY = collectionView.contentSize.height - collectionView.frame.height
        let startPoint = CGPoint(x: contentOffset.x, y: min(max(contentOffset.y, 0), maxStartContentOffsetY))
        let endPoint = CGPoint(x: collectionView.frame.width - 1, y: startPoint.y + collectionView.frame.height - 1)

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
        scrollToFocusDate(animated: true)
    }

    @objc private func handleDidTapDone() {
        dismiss()
    }

    @objc private func handleDidSelectStartEnd(_ segmentedControl: MSSegmentedControl) {
        selectionManager.selectionMode = segmentedControl.selectedSegmentIndex == 0 ? .start : .end
        updateNavigationBar()
        if let visibleDates = visibleDates, focusDate > visibleDates.endDate || focusDate < visibleDates.startDate {
            scrollToFocusDate(animated: false)
        }
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
        guard let dayCell = cell as? CalendarViewDayCell else {
            return
        }

        dayCell.setVisualState((monthOverlayIsShown ? .fadedWithDots : .normal), animated: false)

        updateSelectionOfCell(dayCell, at: indexPath)
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

        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewDayCell else {
            return
        }

        updateSelectionOfCell(cell, at: indexPath)
    }

    private func updateSelectionOfCell(_ cell: CalendarViewDayCell, at indexPath: IndexPath) {
        let collectionView = calendarView.collectionView

        if let selectionType = selectionManager.selectionType(for: indexPath) {
            cell.setSelectionType(selectionType)
            if !cell.isSelected {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        } else {
            if cell.isSelected {
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: false)
            }
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
            if let dayCell = cell as? CalendarViewDayCell {
                dayCell.setVisualState(visible ? .fadedWithDots : .normal, animated: true)
            }
        }
    }
}

// MARK: - MSDatePickerController: CalendarViewLayoutDelegate

extension MSDatePickerController: CalendarViewLayoutDelegate {
    func calendarViewLayout(_ calendarViewLayout: CalendarViewLayout, shouldShowMonthBannerForSectionIndex sectionIndex: Int) -> Bool {
        let firstDayStartDateOfWeek = calendarViewDataSource.dayStart(forDayAt: IndexPath(item: 0, section: sectionIndex))
        let weekOfMonth = calendarViewDataSource.calendar.component(.weekOfMonth, from: firstDayStartDateOfWeek)
        return weekOfMonth == 3
    }
}

// MARK: - MSDatePickerController: MSCalendarViewStyleDataSource

extension MSDatePickerController: CalendarViewStyleDataSource {
    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, textStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents) -> CalendarViewDayCellTextStyle {

        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, backgroundStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents
        ) -> CalendarViewDayCellBackgroundStyle {

        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, selectionStyleForDayWithStart dayStartDate: Date, end: Date) -> CalendarViewDayCellSelectionStyle {
        return .normal
    }
}

// MARK: - MSDatePickerController: MSCardPresentable

extension MSDatePickerController: MSCardPresentable {
    func idealSize() -> CGSize {
        return CGSize(
            width: Constants.idealWidth,
            height: calendarView.height(for: Constants.calendarHeightStyle, in: view.bounds) + (segmentedControl?.frame.height ?? 0)
        )
    }
}
