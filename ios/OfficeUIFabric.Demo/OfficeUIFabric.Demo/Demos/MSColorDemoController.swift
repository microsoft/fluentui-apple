//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSColorDemoController: DemoController {
      override func loadView() {
        super.loadView()

        addTitle(text: "App specific color")
        addRow(text: "Primary", color: MSColors.primary)
        addRow(text: "Tint10", color: MSColors.primaryTint10)
        addRow(text: "Tint20", color: MSColors.primaryTint20)
        addRow(text: "Tint30", color: MSColors.primaryTint30)
        addRow(text: "Tint40", color: MSColors.primaryTint40)
        addRow(text: "Shade10", color: MSColors.primaryShade10)
        addRow(text: "Shade20", color: MSColors.primaryShade20)
        addRow(text: "Shade30", color: MSColors.primaryShade30)
        addRow(text: "Shade40", color: MSColors.primaryShade40)

        addTitle(text: "Neutral colors")
        addRow(text: "gray950", color: MSColors.gray950)
        addRow(text: "gray900", color: MSColors.gray900)
        addRow(text: "gray800", color: MSColors.gray800)
        addRow(text: "gray700", color: MSColors.gray700)
        addRow(text: "gray600", color: MSColors.gray600)
        addRow(text: "gray500", color: MSColors.gray500)
        addRow(text: "gray400", color: MSColors.gray400)
        addRow(text: "gray300", color: MSColors.gray300)
        addRow(text: "gray200", color: MSColors.gray200)
        addRow(text: "gray100", color: MSColors.gray100)
        addRow(text: "gray50", color: MSColors.gray50)
        addRow(text: "gray25", color: MSColors.gray25)

        addTitle(text: "Shared colors")
        let sharedColors = [
            MSColors.Palette.pinkRed10,
            MSColors.Palette.red20,
            MSColors.Palette.red10,
            MSColors.Palette.orange30,
            MSColors.Palette.orange20,
            MSColors.Palette.orangeYellow20,
            MSColors.Palette.green20,
            MSColors.Palette.green10,
            MSColors.Palette.cyan30,
            MSColors.Palette.cyan20,
            MSColors.Palette.cyanBlue20,
            MSColors.Palette.cyanBlue10,
            MSColors.Palette.blue10,
            MSColors.Palette.blueMagenta30,
            MSColors.Palette.blueMagenta20,
            MSColors.Palette.magenta20,
            MSColors.Palette.magenta10,
            MSColors.Palette.magentaPink10,
            MSColors.Palette.gray40,
            MSColors.Palette.gray30,
            MSColors.Palette.gray20
        ]

        for palette in sharedColors {
            addRow(text: palette.name, color: palette.color)
        }

        addTitle(text: "Message colors")
        let messageColors = [
            MSColors.Palette.dangerPrimary,
            MSColors.Palette.dangerTint40,
            MSColors.Palette.dangerTint10,
            MSColors.Palette.dangerShade40,
            MSColors.Palette.dangerShade10,
            MSColors.Palette.warningPrimary,
            MSColors.Palette.warningTint40,
            MSColors.Palette.warningTint10,
            MSColors.Palette.warningShade40,
            MSColors.Palette.warningShade30
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
        fatalError("init(coder:) has not been implemented")
    }
}
