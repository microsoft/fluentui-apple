//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DatePickerHeaderStyle

enum DatePickerHeaderStyle: Int {
    case light
    case dark
}

// MARK: - DatePickerController

/// Represents a date picker, that enables the user to scroll through years vertically week by week.
/// The user can select a date or a range of dates.
class DatePickerController: UIViewController, GenericDateTimePicker {
    private struct Constants {
        static let idealWidth: CGFloat = 343
        // TODO: Make title button width dynamic
        static let titleButtonWidth: CGFloat = 160
        static let calendarHeightStyle: CalendarViewHeightStyle = .extraTall
        static let verticalPaddingFromSegmentControl: CGFloat = 4.0
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

    private(set) var selectionManager: DatePickerSelectionManager!

    weak var delegate: GenericDateTimePickerDelegate?

    private let mode: DateTimePickerMode
    private let leftBarButtonItem: UIBarButtonItem?
    private let rightBarButtonItem: UIBarButtonItem?

    private var titleView: TwoLineTitleView!
    private let customTitle: String?
    private let customSubtitle: String?
    private let customStartTabTitle: String?
    private let customEndTabTitle: String?

    private var monthOverlayIsShown: Bool = false
    private var reloadDataAfterOverlayIsNeeded: Bool = false

    private let calendarView = CalendarView()
    private var calendarViewDataSource: CalendarViewDataSource!
    private var segmentedControl: SegmentedControl?

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
    ///   - leftBarButtonItem: optional UIBarButtonItem to be presented as left bar-button.
    ///   - rightBarButtonItem: optional UIBarButtonItem to be presented oas right bar-button. Note that if this view is presented, the Confirm button is not generated automatically.
    init(startDate: Date, endDate: Date, mode: DateTimePickerMode, selectionMode: DatePickerSelectionManager.SelectionMode = .start, rangePresentation: DateTimePicker.DateRangePresentation, titles: DateTimePicker.Titles?, leftBarButtonItem: UIBarButtonItem?, rightBarButtonItem: UIBarButtonItem?) {
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
        self.leftBarButtonItem = leftBarButtonItem
        self.rightBarButtonItem = rightBarButtonItem

        super.init(nibName: nil, bundle: nil)

        defer {
            self.startDate = startDate
            self.endDate = endDate
        }

        calendarViewDataSource = CalendarViewDataSource(styleDataSource: self)

        let startDate = startDate.startOfDay
        selectionManager = DatePickerSelectionManager(
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

        calendarView.weekdayHeadingView.setup(horizontalSizeClass: traitCollection.horizontalSizeClass, firstWeekday: CalendarConfiguration.default.firstWeekday)

        let collectionView = calendarView.collectionView

        collectionView.register(CalendarViewMonthBannerView.self, forSupplementaryViewOfKind: CalendarViewMonthBannerView.supplementaryElementKind, withReuseIdentifier: CalendarViewMonthBannerView.reuseIdentifier)

        collectionView.register(CalendarViewDayCell.self, forCellWithReuseIdentifier: CalendarViewDayCell.identifier)
        collectionView.register(CalendarViewDayMonthCell.self, forCellWithReuseIdentifier: CalendarViewDayMonthCell.identifier)
        collectionView.register(CalendarViewDayMonthYearCell.self, forCellWithReuseIdentifier: CalendarViewDayMonthYearCell.identifier)
        collectionView.register(CalendarViewDayTodayCell.self, forCellWithReuseIdentifier: CalendarViewDayTodayCell.identifier)

        collectionView.dataSource = calendarViewDataSource
        collectionView.delegate = self

        calendarView.collectionViewLayout.delegate = self

        if let segmentedControl = segmentedControl {
            view.addSubview(segmentedControl)
            view.backgroundColor = Colors.Toolbar.background
        }
        view.addSubview(calendarView)

        initNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollToFocusDate(animated: false)

        // Hide default bottom border of navigation bar
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var verticalOffset: CGFloat = 0
        if let segmentedControl = segmentedControl {
            segmentedControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: segmentedControl.intrinsicContentSize.height)
            verticalOffset = segmentedControl.frame.height + Constants.verticalPaddingFromSegmentControl
        }

        calendarView.frame = CGRect(x: 0, y: verticalOffset, width: view.frame.width, height: view.frame.height - verticalOffset)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = view.window {
            navigationItem.rightBarButtonItem?.tintColor = UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if let segmentedControl = segmentedControl, previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            segmentedControl.style = (traitCollection.userInterfaceStyle == .dark) ? .onBrandPill : .primaryPill
        }
    }

    private func initTitleView() {
        titleView = TwoLineTitleView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTitleButtonTapped))
        titleView.addGestureRecognizer(tapRecognizer)

        updateNavigationBar()
    }

    private func initNavigationBar() {
        if let leftBarButtonItem = leftBarButtonItem {
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        if let rightBarButtonItem = rightBarButtonItem {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = BarButtonItems.confirm(target: self, action: #selector(handleDidTapDone))
        }
        navigationItem.titleView = titleView
    }

    private func initSegmentedControl() {
        let items = [SegmentItem(title: customStartTabTitle ?? "MSDateTimePicker.StartDate".localized),
                     SegmentItem(title: customEndTabTitle ?? "MSDateTimePicker.EndDate".localized)]
        segmentedControl = SegmentedControl(items: items,
                                            style: traitCollection.userInterfaceStyle == .dark ? .onBrandPill : .primaryPill)
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

        // There may be no items in the 0th section if we are constraining the calendar to today's date.
        // Attempting to scroll in that case will throw an exception. But that's okay, there's no need
        // to scroll there anyway, since the view will start at that date.
        if calendarView.collectionView.numberOfItems(inSection: targetIndexPath.section) > targetIndexPath.item {
            calendarView.collectionView.scrollToItem(at: targetIndexPath, at: [.top], animated: animated)
        }
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

    @objc private func handleDidSelectStartEnd(_ segmentedControl: SegmentedControl) {
        selectionManager.selectionMode = segmentedControl.selectedSegmentIndex == 0 ? .start : .end
        updateNavigationBar()
        if let visibleDates = visibleDates, focusDate > visibleDates.endDate || focusDate < visibleDates.startDate {
            scrollToFocusDate(animated: false)
        }
    }
}

// MARK: - DatePickerController: UICollectionViewDelegate

extension DatePickerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let monthBannerView = view as? CalendarViewMonthBannerView else {
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

// MARK: - DatePickerController: UIScrollViewDelegate

extension DatePickerController: UIScrollViewDelegate {
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
            if let monthBannerView = monthBannerViewValue.nonretainedObjectValue as? CalendarViewMonthBannerView {
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

// MARK: - DatePickerController: CalendarViewLayoutDelegate

extension DatePickerController: CalendarViewLayoutDelegate {
    func calendarViewLayout(_ calendarViewLayout: CalendarViewLayout, shouldShowMonthBannerForSectionIndex sectionIndex: Int) -> Bool {
        let firstDayStartDateOfWeek = calendarViewDataSource.dayStart(forDayAt: IndexPath(item: 0, section: sectionIndex))
        let weekOfMonth = calendarViewDataSource.calendar.component(.weekOfMonth, from: firstDayStartDateOfWeek)
        return weekOfMonth == 3
    }
}

// MARK: - DatePickerController: MSCalendarViewStyleDataSource

extension DatePickerController: CalendarViewStyleDataSource {
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

// MARK: - DatePickerController: CardPresentable

extension DatePickerController: CardPresentable {
    func idealSize() -> CGSize {
        var extraHeight: CGFloat = 0
        if let segmentedControlHeight = segmentedControl?.frame.height {
            extraHeight = segmentedControlHeight + Constants.verticalPaddingFromSegmentControl
        }
        return CGSize(
            width: Constants.idealWidth,
            height: calendarView.height(for: Constants.calendarHeightStyle, in: view.bounds) + extraHeight
        )
    }
}
