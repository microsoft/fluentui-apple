//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSDateTimePickerDelegate

@objc protocol MSDateTimePickerDelegate: class {
    @objc func dateTimePicker(_ dateTimePicker: MSDateTimePicker, didPickDate date: Date)
    @objc optional func dateTimePicker(_ dateTimePicker: MSDateTimePicker, didSelectDate date: Date)
}

// MARK: - MSDateTimePicker

class MSDateTimePicker: UIViewController {
    private struct Constants {
        static let idealRowCount: Int = 7
        static let idealWidth: CGFloat = 320
    }

    var mode: MSDateTimePickerViewMode { return dateTimePickerView.mode }

    weak var delegate: MSDateTimePickerDelegate?

    private var date: Date

    private let dateTimePickerView: MSDateTimePickerView

    // TODO: Add availability back in? - contactAvailabilitySummaryDataSource: ContactAvailabilitySummaryDataSource?,
    init(date: Date, showsTime: Bool = true) {
        self.date = date

        let datePickerMode: MSDateTimePickerViewMode = showsTime ? .dateTime : .date(startYear: MSDateTimePickerViewMode.defaultStartYear, endYear: MSDateTimePickerViewMode.defaultEndYear)
        dateTimePickerView = MSDateTimePickerView(mode: datePickerMode)

        super.init(nibName: nil, bundle: nil)

        dateTimePickerView.addTarget(self, action: #selector(handleDidSelectDate(_:)), for: .valueChanged)

        initNavigationBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Presents this date time picker over the selected view controller, using a card modal style.
    ///
    /// - Parameter presentingViewController: The view controller the date picker will be presented on top of
    func present(from presentingViewController: UIViewController) {
        let navController = MSCardPresenterNavigationController(rootViewController: self)
        let pageCardPresenterVC = MSPageCardPresenterController(viewControllers: [navController], startingIndex: 0)

        pageCardPresenterVC.onDismiss = {
            self.dismiss(accept: false)
        }

        presentingViewController.present(pageCardPresenterVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background

        view.addSubview(dateTimePickerView)
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
        if let image = UIImage.staticImageNamed("back-25x25") {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDidTapBack))
            navigationItem.leftBarButtonItem?.tintColor = MSColors.buttonImage
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
        delegate?.dateTimePicker?(self, didSelectDate: date)
    }

    @objc private func handleDidTapDone(_ item: UIBarButtonItem) {
        dismiss(accept: true)
    }

    @objc private func handleDidTapBack(_ item: UIBarButtonItem) {
        dismiss(accept: false)
    }
}

// MARK: - MSDateTimePicker: MSCardPresentable

extension MSDateTimePicker: MSCardPresentable {
    func idealSize() -> CGSize {
        let height = MSDateTimePickerViewLayout.height(forRowCount: Constants.idealRowCount)
        return CGSize(width: Constants.idealWidth, height: height)
    }
}
