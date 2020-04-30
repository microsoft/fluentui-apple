//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ColorDemoController: DemoController {
      override func loadView() {
        super.loadView()

        addTitle(text: "App specific color")
        addRow(text: "Shade30", color: Colors.primaryShade30)
        addRow(text: "Shade20", color: Colors.primaryShade20)
        addRow(text: "Shade10", color: Colors.primaryShade10)
        addRow(text: "Primary", color: Colors.primary)
        addRow(text: "Tint10", color: Colors.primaryTint10)
        addRow(text: "Tint20", color: Colors.primaryTint20)
        addRow(text: "Tint30", color: Colors.primaryTint30)
        addRow(text: "Tint40", color: Colors.primaryTint40)

        addTitle(text: "Neutral colors")
        addRow(text: "gray950", color: Colors.gray950)
        addRow(text: "gray900", color: Colors.gray900)
        addRow(text: "gray800", color: Colors.gray800)
        addRow(text: "gray700", color: Colors.gray700)
        addRow(text: "gray600", color: Colors.gray600)
        addRow(text: "gray500", color: Colors.gray500)
        addRow(text: "gray400", color: Colors.gray400)
        addRow(text: "gray300", color: Colors.gray300)
        addRow(text: "gray200", color: Colors.gray200)
        addRow(text: "gray100", color: Colors.gray100)
        addRow(text: "gray50", color: Colors.gray50)
        addRow(text: "gray25", color: Colors.gray25)

        addTitle(text: "Shared colors")
        let sharedColors = [
            Colors.Palette.pinkRed10,
            Colors.Palette.red20,
            Colors.Palette.red10,
            Colors.Palette.orange30,
            Colors.Palette.orange20,
            Colors.Palette.orangeYellow20,
            Colors.Palette.green20,
            Colors.Palette.green10,
            Colors.Palette.cyan30,
            Colors.Palette.cyan20,
            Colors.Palette.cyanBlue20,
            Colors.Palette.cyanBlue10,
            Colors.Palette.blue10,
            Colors.Palette.blueMagenta30,
            Colors.Palette.blueMagenta20,
            Colors.Palette.magenta20,
            Colors.Palette.magenta10,
            Colors.Palette.magentaPink10,
            Colors.Palette.gray40,
            Colors.Palette.gray30,
            Colors.Palette.gray20
        ]

        for palette in sharedColors {
            addRow(text: palette.name, color: palette.color)
        }

        addTitle(text: "Message colors")
        let messageColors = [
            Colors.Palette.dangerPrimary,
            Colors.Palette.dangerTint40,
            Colors.Palette.dangerTint10,
            Colors.Palette.dangerShade40,
            Colors.Palette.dangerShade10,
            Colors.Palette.warningPrimary,
            Colors.Palette.warningTint40,
            Colors.Palette.warningTint10,
            Colors.Palette.warningShade40,
            Colors.Palette.warningShade30
        ]
        for palette in messageColors {
            addRow(text: palette.name, color: palette.color)
        }

    }

    private func addRow(text: String, color: UIColor) {
        addRow(text: text, items: [DemoColorView(color: color)], textStyle: .footnote, textWidth: 150)
    }
}

class DemoColorView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }

    public init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
