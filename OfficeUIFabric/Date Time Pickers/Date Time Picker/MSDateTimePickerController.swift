//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSDateTimePickerController

class MSDateTimePickerController: UIViewController, DateTimePicker {
    private struct Constants {
        static let idealRowCount: Int = 7
        static let idealWidth: CGFloat = 320
        static let titleButtonWidth: CGFloat = 160
    }

    var mode: MSDateTimePickerViewMode { return dateTimePickerView.mode }

    var date: Date {
        didSet {
            dateTimePickerView.setDate(date, animated: false)
            updateNavigationBar()
        }
    }

    weak var delegate: DateTimePickerDelegate?

    private let dateTimePickerView: MSDateTimePickerView
    private let titleView = MSTwoLinesTitleView()

    // TODO: Add availability back in? - contactAvailabilitySummaryDataSource: ContactAvailabilitySummaryDataSource?,
    init(date: Date, showsTime: Bool = true) {
        self.date = date

        let datePickerMode: MSDateTimePickerViewMode = showsTime ? .dateTime : .date(startYear: MSDateTimePickerViewMode.defaultStartYear, endYear: MSDateTimePickerViewMode.defaultEndYear)
        dateTimePickerView = MSDateTimePickerView(mode: datePickerMode)

        super.init(nibName: nil, bundle: nil)

        dateTimePickerView.addTarget(self, action: #selector(handleDidSelectDate(_:)), for: .valueChanged)

        updateNavigationBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background

        view.addSubview(dateTimePickerView)
        initNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        dateTimePickerView.frame = view.bounds
    }

    override func accessibilityPerformEscape() -> Bool {
        dismiss(accept: true)
        return true
    }

    // TODO: Refactor this to reuse for any modal that needs a cancel/confirm
    private func initNavigationBar() {
        if let image = UIImage.staticImageNamed("checkmark-blue-25x25"),
            let landscapeImage = UIImage.staticImageNamed("checkmark-blue-thin-20x20") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: self, action: #selector(handleDidTapDone))
        }
        navigationItem.titleView = titleView
    }

    private func updateNavigationBar() {
        let title = String.dateString(from: date, compactness: .shortDaynameShortMonthnameDay)
        titleView.setup(title: title)
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

    private func dismiss(accept: Bool) {
        if accept {
            delegate?.dateTimePicker(self, didPickDate: date)
        }
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func handleDidSelectDate(_ datePicker: MSDateTimePickerView) {
        date = datePicker.date
        delegate?.dateTimePicker(self, didSelectDate: date)
    }

    @objc private func handleDidTapDone(_ item: UIBarButtonItem) {
        dismiss(accept: true)
    }
}

// MARK: - MSDateTimePickerController: MSCardPresentable

extension MSDateTimePickerController: MSCardPresentable {
    func idealSize() -> CGSize {
        let height = MSDateTimePickerViewLayout.height(forRowCount: Constants.idealRowCount)
        return CGSize(width: Constants.idealWidth, height: height)
    }
}
