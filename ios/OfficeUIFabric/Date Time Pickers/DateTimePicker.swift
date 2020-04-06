//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DateTimePicker

protocol DateTimePicker: class {
    var startDate: Date { get set }
    var endDate: Date { get set }
    var delegate: DateTimePickerDelegate? { get set }
}

extension DateTimePicker where Self: UIViewController {
    func dismiss() {
        if delegate?.dateTimePicker(self, shouldEndPickingStartDate: startDate, endDate: endDate) ?? true {
            delegate?.dateTimePicker(self, didPickStartDate: startDate, endDate: endDate)
            presentingViewController?.dismiss(animated: true)
        }
    }
}

// MARK: - DateTimePickerDelegate

protocol DateTimePickerDelegate: class {
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didPickStartDate startDate: Date, endDate: Date)
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didSelectStartDate startDate: Date, endDate: Date)
    func dateTimePicker(_ dateTimePicker: DateTimePicker, shouldEndPickingStartDate startDate: Date, endDate: Date) -> Bool
}
