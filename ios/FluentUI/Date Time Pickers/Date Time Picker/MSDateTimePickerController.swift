//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSDateTimePickerControllerMode

enum MSDateTimePickerControllerMode {
    case single, start, end
}

// MARK: - MSDateTimePickerController

/// A view controller that allows a user to select either a date or a combination of date and time using a custom control similar in appearance to UIDatePicker.
/// Has support for a start and end time/date.
class MSDateTimePickerController: UIViewController, DateTimePicker {
    private struct Constants {
        static let idealRowCount: Int = 7
        static let idealWidth: CGFloat = 320
        static let titleButtonWidth: CGFloat = 160
    }

    var startDate: Date {
        didSet {
            startDate = startDate.rounded(toNearestMinutes: MSDateTimePickerViewDataSourceConstants.minuteInterval) ?? startDate
            switch mode {
            case .single:
                dateTimePickerView.setDate(startDate, animated: false)
                endDate = startDate
            case .start:
                dateTimePickerView.setDate(startDate, animated: false)
            case .end:
                break
            }
            updateNavigationBar()
        }
    }
    var endDate: Date {
        didSet {
            if mode != .single {
                endDate = endDate.rounded(toNearestMinutes: MSDateTimePickerViewDataSourceConstants.minuteInterval) ?? endDate
            }
            switch mode {
            case .single:
                endDate = startDate
            case .start:
                break
            case .end:
                dateTimePickerView.setDate(endDate, animated: false)
                updateNavigationBar()
            }

        }
    }

    private(set) var mode: MSDateTimePickerControllerMode {
        didSet {
            switch mode {
            case .start:
                dateTimePickerView.setDate(startDate, animated: false)
            case .end:
                dateTimePickerView.setDate(endDate, animated: false)
            case .single:
                dateTimePickerView.setDate(startDate, animated: false)
                endDate = startDate
            }
            updateNavigationBar()
        }
    }

    weak var delegate: DateTimePickerDelegate?

    private let customTitle: String?
    private let customSubtitle: String?
    private let customStartTabTitle: String?
    private let customEndTabTitle: String?
    private let dateTimePickerView: MSDateTimePickerView
    private let titleView = MSTwoLineTitleView()
    private var segmentedControl: MSSegmentedControl?

    // TODO: Add availability back in? - contactAvailabilitySummaryDataSource: ContactAvailabilitySummaryDataSource?,
    init(startDate: Date, endDate: Date, mode: MSDateTimePickerMode, titles: MSDateTimePicker.Titles?) {
        self.mode = mode.singleSelection ? .single : .start
        self.startDate = startDate.rounded(toNearestMinutes: MSDateTimePickerViewDataSourceConstants.minuteInterval) ?? startDate
        self.endDate = self.mode == .single ? self.startDate : (endDate.rounded(toNearestMinutes: MSDateTimePickerViewDataSourceConstants.minuteInterval) ?? endDate)

        let datePickerMode: MSDateTimePickerViewMode = mode.includesTime ? .dateTime : .date(startYear: MSDateTimePickerViewMode.defaultStartYear, endYear: MSDateTimePickerViewMode.defaultEndYear)
        dateTimePickerView = MSDateTimePickerView(mode: datePickerMode)
        dateTimePickerView.setDate(self.startDate, animated: false)

        customTitle = titles?.dateTimeTitle
        customSubtitle = titles?.dateTimeSubtitle
        customStartTabTitle = titles?.startTab
        customEndTabTitle = titles?.endTab

        super.init(nibName: nil, bundle: nil)

        dateTimePickerView.addTarget(self, action: #selector(handleDidSelectDate(_:)), for: .valueChanged)

        updateNavigationBar()

        if self.mode != .single {
            initSegmentedControl(includesTime: mode.includesTime)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let segmentedControl = segmentedControl {
            view.addSubview(segmentedControl)
        }
        view.addSubview(dateTimePickerView)
        initNavigationBar()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let segmentedControl = segmentedControl {
            segmentedControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: segmentedControl.intrinsicContentSize.height)
        }
        let verticalOffset = segmentedControl?.frame.height ?? 0
        dateTimePickerView.frame = CGRect(x: 0, y: verticalOffset, width: view.frame.width, height: view.frame.height - verticalOffset)
    }

    override func accessibilityPerformEscape() -> Bool {
        dismiss()
        return true
    }

    private func initSegmentedControl(includesTime: Bool) {
        let titles: [String]
        if includesTime {
            titles = [customStartTabTitle ?? "MSDateTimePicker.StartTime".localized,
                      customEndTabTitle ?? "MSDateTimePicker.EndTime".localized]
        } else {
            titles = [customStartTabTitle ?? "MSDateTimePicker.StartDate".localized,
                      customEndTabTitle ?? "MSDateTimePicker.EndDate".localized]
        }
        segmentedControl = MSSegmentedControl(items: titles)
        segmentedControl?.addTarget(self, action: #selector(handleDidSelectStartEnd(_:)), for: .valueChanged)
    }

    private func initNavigationBar() {
        navigationItem.rightBarButtonItem = MSBarButtonItems.confirm(target: self, action: #selector(handleDidTapDone))
        navigationItem.titleView = titleView
    }

    private func updateNavigationBar() {
        let titleDate = mode == .end ? endDate : startDate
        let title = customTitle ?? String.dateString(from: titleDate, compactness: .shortDaynameShortMonthnameDay)
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

    @objc private func handleDidSelectDate(_ datePicker: MSDateTimePickerView) {
        switch mode {
        case .single:
            startDate = datePicker.date
        case .start:
            let duration = endDate.timeIntervalSince(startDate)
            endDate = datePicker.date.addingTimeInterval(duration)
            startDate = datePicker.date
        case .end:
            endDate = datePicker.date
            if endDate < startDate {
                startDate = endDate
            }
        }
        delegate?.dateTimePicker(self, didSelectStartDate: startDate, endDate: endDate)
    }

    @objc private func handleDidSelectStartEnd(_ segmentedControl: MSSegmentedControl) {
        mode = segmentedControl.selectedSegmentIndex == 0 ? .start : .end
    }

    @objc private func handleDidTapDone(_ item: UIBarButtonItem) {
        dismiss()
    }

}

// MARK: - MSDateTimePickerController: MSCardPresentable

extension MSDateTimePickerController: MSCardPresentable {
    func idealSize() -> CGSize {
        return CGSize(
            width: Constants.idealWidth,
            height: MSDateTimePickerViewLayout.height(forRowCount: Constants.idealRowCount) + (segmentedControl?.frame.height ?? 0)
        )
    }
}
