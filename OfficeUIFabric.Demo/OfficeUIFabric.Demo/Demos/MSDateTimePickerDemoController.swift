//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSDateTimePickerDemoController: DemoController {
    private let dateLabel = MSLabel(style: .headline, colorStyle: .primary)
    private let dateTimePicker = MSDateTimePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTimePicker.delegate = self
        dateLabel.text = "No date selected"
        container.addArrangedSubview(dateLabel)
        container.addArrangedSubview(createButton(title: "Show date picker", action: #selector(presentDatePicker)))
        container.addArrangedSubview(createButton(title: "Show date time picker", action: #selector(presentDateTimePicker)))
    }

    @objc func presentDatePicker() {
        dateTimePicker.present(from: self, with: .date)
    }

    @objc func presentDateTimePicker() {
        dateTimePicker.present(from: self, with: .dateTime)
    }
}

// MARK: - MSDateTimePickerDemoController: MSDatePickerDelegate

extension MSDateTimePickerDemoController: MSDateTimePickerDelegate {
    func dateTimePicker(_ dateTimePicker: MSDateTimePicker, didPickDate date: Date) {
        var compactness = MSDateStringCompactness.longDaynameDayMonthYear
        if dateTimePicker.mode == .dateTime {
            compactness = .longDaynameDayMonthHoursColumnsMinutes
        }
        dateLabel.text = String.dateString(from: date, compactness: compactness)
        dateTimePicker.dismiss()
    }
}
