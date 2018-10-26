//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class MSDatePickerDemoController: DemoController {
    private var dateLabel: MSLabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel = MSLabel(style: .headline, colorStyle: .primary)
        dateLabel?.text = "No date selected"
        container.addArrangedSubview(dateLabel!)
        container.addArrangedSubview(createButton(title: "Show date picker", action: #selector(presentDatePicker)))
    }

    @objc func presentDatePicker() {
        let datePicker = MSDatePicker(initialDate: Date())
        datePicker.delegate = self
        datePicker.present(from: self)
    }
}

// MARK: - MSDatePickerDemoController: MSDatePickerDelegate

extension MSDatePickerDemoController: MSDatePickerDelegate {
    func datePicker(_ datePicker: MSDatePicker, didPickDate date: Date) {
        dateLabel?.text = String.dateString(from: date, compactness: .longDaynameDayMonthYear)
        dismiss(animated: true)
    }
}
