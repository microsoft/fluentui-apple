//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSDateTimePickerMode

@objc public enum MSDateTimePickerMode: Int {
    case date
    case dateTime
}

// MARK: - MSDateTimePickerDelegate

@objc public protocol MSDateTimePickerDelegate: class {
    /// Allows a class to be notified when a user confirms their selected date
    func dateTimePicker(_ dateTimePicker: MSDateTimePicker, didPickDate date: Date)
}

// MARK: - DateTimePicker

protocol DateTimePicker: class {
    var date: Date { get set }
    var delegate: DateTimePickerDelegate? { get set }
}

// MARK: - DateTimePickerDelegate

protocol DateTimePickerDelegate: class {
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didPickDate date: Date)
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didSelectDate date: Date)
}

// MARK: - MSDateTimePicker

/// Manages the presentation and coordination of different date and time pickers
public class MSDateTimePicker: NSObject {
    public private(set) var mode: MSDateTimePickerMode?
    @objc public weak var delegate: MSDateTimePickerDelegate?

    private var presentingController: UIViewController?
    private var presentedPickers: [DateTimePicker]?

    /// Presents a picker or set of pickers from a `presentingController` depending on the mode selected. Also handles accessibility replacement presentation.
    ///
    /// - Parameters:
    ///   - presentingController: The view controller that is presenting these pickers
    ///   - mode: Enum describing which mode of pickers should be presented
    ///   - date: The initial date selected on the presented pickers
    @objc public func present(from presentingController: UIViewController, with mode: MSDateTimePickerMode, for date: Date = Date()) {
        self.presentingController = presentingController
        if UIAccessibility.isVoiceOverRunning {
            presentDateTimePickerForAccessibility(initialDate: date, showsTime: mode == .dateTime)
            return
        }
        self.mode = mode
        switch mode {
        case .date:
            presentDatePicker(initialDate: date)
        case .dateTime:
            presentDateTimePicker(initialDate: date)
        }
    }

    @objc public func dismiss() {
        presentingController?.dismiss(animated: true)
        mode = nil
        presentedPickers = nil
        presentingController = nil
    }

    private func presentDatePicker(initialDate: Date) {
        let datePicker = MSDatePickerController(startDate: initialDate)
        present([datePicker])
    }

    private func presentDateTimePicker(initialDate: Date) {
        let datePicker = MSDatePickerController(startDate: initialDate)
        let dateTimePicker = MSDateTimePickerController(date: initialDate, showsTime: true)
        present([datePicker, dateTimePicker])
    }

    private func presentDateTimePickerForAccessibility(initialDate: Date, showsTime: Bool) {
        let dateTimePicker = MSDateTimePickerController(date: initialDate, showsTime: showsTime)
        present([dateTimePicker])
    }

    private func present(_ pickers: [DateTimePicker]) {
        pickers.forEach { $0.delegate = self }
        presentedPickers = pickers

        let viewControllers = pickers.map { MSCardPresenterNavigationController(rootViewController: $0 as! UIViewController) }
        let pageCardPresenter = MSPageCardPresenterController(viewControllers: viewControllers, startingIndex: 0)
        pageCardPresenter.onDismiss = {
            self.dismiss()
        }
        presentingController?.present(pageCardPresenter, animated: true)
    }
}

// MARK: - MSDateTimePicker: DateTimePickerDelegate

extension MSDateTimePicker: DateTimePickerDelegate {
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didPickDate date: Date) {
        delegate?.dateTimePicker(self, didPickDate: date)
    }

    func dateTimePicker(_ dateTimePicker: DateTimePicker, didSelectDate date: Date) {
        guard let presentedPickers = presentedPickers else {
            return
        }
        for picker in presentedPickers where picker !== dateTimePicker {
            picker.date = date
        }
    }
}
