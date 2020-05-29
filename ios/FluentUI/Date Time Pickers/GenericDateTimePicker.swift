//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: GenericDateTimePicker

protocol GenericDateTimePicker: AnyObject {
    var startDate: Date { get set }
    var endDate: Date { get set }
    var delegate: GenericDateTimePickerDelegate? { get set }
}

extension GenericDateTimePicker where Self: UIViewController {
    func dismiss() {
        if delegate?.dateTimePicker(self, shouldEndPickingStartDate: startDate, endDate: endDate) ?? true {
            delegate?.dateTimePicker(self, didPickStartDate: startDate, endDate: endDate)
            presentingViewController?.dismiss(animated: true)
        }
    }
}

// MARK: - GenericDateTimePickerDelegate

protocol GenericDateTimePickerDelegate: AnyObject {
    func dateTimePicker(_ dateTimePicker: GenericDateTimePicker, didPickStartDate startDate: Date, endDate: Date)
    func dateTimePicker(_ dateTimePicker: GenericDateTimePicker, didSelectStartDate startDate: Date, endDate: Date)
    func dateTimePicker(_ dateTimePicker: GenericDateTimePicker, shouldEndPickingStartDate startDate: Date, endDate: Date) -> Bool
}
