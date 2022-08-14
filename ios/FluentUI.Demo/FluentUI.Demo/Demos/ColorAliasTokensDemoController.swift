//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ColorAliasTokensDemoController: DemoTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.backgroundColor = .lightGray
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .black
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ColorAliasTokensDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ColorAliasTokensDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColorAliasTokensDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
        let section = ColorAliasTokensDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        cell.backgroundConfiguration?.backgroundColor = UIColor(dynamicColor: aliasTokens.colors[row])
        cell.selectionStyle = .none

        var contentConfiguration = cell.defaultContentConfiguration()
        let text = "\(row.text)"
        contentConfiguration.attributedText = NSAttributedString(string: text,
                                                                 attributes: [
                                                                    .foregroundColor: textColor(for: row)
                                                                 ])
        contentConfiguration.textProperties.alignment = .center
        cell.contentConfiguration = contentConfiguration

        return cell
    }

    private func textColor(for token: AliasTokens.ColorsTokens) -> UIColor {
        let black = ColorValue(0x000000)
        let white = ColorValue(0xFFFFFF)

        switch token {
        case .background1, .background1Pressed, .background1Selected, .background2, .background2Pressed, .background2Selected, .background3, .background3Pressed, .background3Selected, .background4, .background4Pressed, .background4Selected, .background5, .background5Pressed, .background5Selected, .background5BrandTint, .background6, .background6Pressed, .background6Selected, .backgroundDisabled, .brandBackground4, .background5BrandTintSelected, .background5BrandFilledSelected, .brandBackgroundDisabled, .canvasBackground, .stencil1, .stencil2, .foregroundDisabled2, .foregroundOnColor, .brandForeground2, .stroke1, .stroke2, .strokeDisabled, .strokeFocus1:
            return UIColor(dynamicColor: DynamicColor(light: black, dark: white))
        case .brandBackground3Pressed, .foreground1, .foreground2, .foreground3, .foregroundInverted2, .brandForegroundInverted, .strokeFocus2, .brandBackground1Pressed, .brandForeground1Pressed, .brandStroke1Pressed, .brandStroke1, .brandStroke1Selected:
            return UIColor(dynamicColor: DynamicColor(light: white, dark: black))
        case .brandBackground3Selected, .brandBackgroundInverted, .brandBackgroundInvertedDisabled, .foregroundInverted1, .brandForeground3:
            return .black
        case .foregroundDisabled1, .foregroundContrast, .brandForeground1, .brandForeground1Selected, .brandForeground4, .brandForeground5, .brandForegroundDisabled, .background5SelectedBrandFilled, .backgroundInverted, .brandBackground1, .brandBackground1Selected, .brandBackground2, .brandBackground2Pressed, .brandBackground2Selected, .brandBackground3, .strokeAccessible:
            return .white
        }
    }

    private var aliasTokens: AliasTokens {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return AliasTokens()
        }
        return fluentTheme.aliasTokens
    }

}

private enum ColorAliasTokensDemoSection: CaseIterable {
    case neutralBackgrounds
    case brandBackgrounds
    case neutralForegrounds
    case brandForegrounds
    case neutralStrokes
    case brandStrokes

    var title: String {
        switch self {
        case .neutralBackgrounds:
            return "Neutral Backgrounds"
        case .brandBackgrounds:
            return "Brand Backgrounds"
        case .neutralForegrounds:
            return "Neutral Foregrounds"
        case .brandForegrounds:
            return "Brand Foregrounds"
        case .neutralStrokes:
            return "Neutral Strokes"
        case .brandStrokes:
            return "Brand Strokes"
        }
    }

    var rows: [AliasTokens.ColorsTokens] {
        switch self {
        case .neutralBackgrounds:
            return [.background1,
                    .background1Pressed,
                    .background1Selected,
                    .background2,
                    .background2Pressed,
                    .background2Selected,
                    .background3,
                    .background3Pressed,
                    .background3Selected,
                    .background4,
                    .background4Pressed,
                    .background4Selected,
                    .background5,
                    .background5Pressed,
                    .background5Selected,
                    .background6,
                    .background6Pressed,
                    .background6Selected,
                    .backgroundInverted,
                    .backgroundDisabled,
                    .canvasBackground,
                    .stencil1,
                    .stencil2]
        case .brandBackgrounds:
            return [.brandBackground1,
                    .brandBackground1Pressed,
                    .brandBackground1Selected,
                    .brandBackground2,
                    .brandBackground2Pressed,
                    .brandBackground2Selected,
                    .brandBackground3,
                    .brandBackground3Pressed,
                    .brandBackground3Selected,
                    .brandBackground4,
                    .background5BrandTint,
                    .background5SelectedBrandFilled,
                    .background5BrandFilledSelected,
                    .background5BrandTintSelected,
                    .brandBackgroundInverted,
                    .brandBackgroundDisabled,
                    .brandBackgroundInvertedDisabled]
        case .neutralForegrounds:
            return [.foreground1,
                    .foreground2,
                    .foreground3,
                    .foregroundDisabled1,
                    .foregroundDisabled2,
                    .foregroundContrast,
                    .foregroundOnColor,
                    .foregroundInverted1,
                    .foregroundInverted2]
        case .brandForegrounds:
            return [.brandForeground1,
                    .brandForeground1Pressed,
                    .brandForeground1Selected,
                    .brandForeground2,
                    .brandForeground3,
                    .brandForeground4,
                    .brandForeground5,
                    .brandForegroundInverted,
                    .brandForegroundDisabled]
        case .neutralStrokes:
            return [.stroke1,
                    .stroke2,
                    .strokeDisabled,
                    .strokeAccessible,
                    .strokeFocus1,
                    .strokeFocus2]
        case .brandStrokes:
            return [.brandStroke1,
                    .brandStroke1Pressed,
                    .brandStroke1Selected]
        }
    }
}

private extension AliasTokens.ColorsTokens {
    var text: String {
        switch self {
        case .foreground1:
            return "Foreground 1"
        case .foreground2:
            return "Foreground 2"
        case .foreground3:
            return "Foreground 3"
        case .foregroundDisabled1:
            return "Foreground Disabled 1"
        case .foregroundDisabled2:
            return "Foreground Disabled 2"
        case .foregroundContrast:
            return "Foreground Contrast"
        case .foregroundOnColor:
            return "Foreground On Color"
        case .foregroundInverted1:
            return "Foreground Inverted 1"
        case .foregroundInverted2:
            return "Foreground Inverted 2"
        case .brandForeground1:
            return "Brand Foreground 1"
        case .brandForeground1Pressed:
            return "Brand Foreground 1 Pressed"
        case .brandForeground1Selected:
            return "Brand Foreground 1 Selected"
        case .brandForeground2:
            return "Brand Foreground 2"
        case .brandForeground3:
            return "Brand Foreground 3"
        case .brandForeground4:
            return "Brand Foreground 4"
        case .brandForeground5:
            return "Brand Foreground 5"
        case .brandForegroundInverted:
            return "Brand Foreground Inverted"
        case .brandForegroundDisabled:
            return "Brand Foreground Disabled"
        case .background1:
            return "Background 1"
        case .background1Pressed:
            return "Background 1 Pressed"
        case .background1Selected:
            return "Background 1 Selected"
        case .background2:
            return "Background 2"
        case .background2Pressed:
            return "Background 2 Pressed"
        case .background2Selected:
            return "Background 2 Selected"
        case .background3:
            return "Background 3"
        case .background3Pressed:
            return "Background 3 Pressed"
        case .background3Selected:
            return "Background 3 Selected"
        case .background4:
            return "Background 4"
        case .background4Pressed:
            return "Background 4 Pressed"
        case .background4Selected:
            return "Background 4 Selected"
        case .background5:
            return "Background 5"
        case .background5Pressed:
            return "Background 5 Pressed"
        case .background5Selected:
            return "Background 5 Selected"
        case .background5SelectedBrandFilled:
            return "Background 5 Selected Brand Filled"
        case .background5BrandTint:
            return "Background 5 Brand Tint"
        case .background6:
            return "Background 6"
        case .background6Pressed:
            return "Background 6 Pressed"
        case .background6Selected:
            return "Background 6 Selected"
        case .backgroundInverted:
            return "Background Inverted"
        case .backgroundDisabled:
            return "Background Disabled"
        case .brandBackground1:
            return "Brand Background 1"
        case .brandBackground1Pressed:
            return "Brand Background 1 Pressed"
        case .brandBackground1Selected:
            return "Brand Background 1 Selected"
        case .brandBackground2:
            return "Brand Background 2"
        case .brandBackground2Pressed:
            return "Brand Background 2 Pressed"
        case .brandBackground2Selected:
            return "Brand Background 2 Selected"
        case .brandBackground3:
            return "Brand Background 3"
        case .brandBackground3Pressed:
            return "Brand Background 3 Pressed"
        case .brandBackground3Selected:
            return "Brand Background 3 Selected"
        case .brandBackground4:
            return "Brand Background 4"
        case .background5BrandFilledSelected:
            return "Background 5 Brand Filled Selected"
        case .background5BrandTintSelected:
            return "Background 5 Brand Tint Selected"
        case .brandBackgroundInverted:
            return "Brand Background Inverted"
        case .brandBackgroundDisabled:
            return "Brand Background Disabled"
        case .brandBackgroundInvertedDisabled:
            return "Brand Background Inverted Disabled"
        case .stencil1:
            return "Stencil 1"
        case .stencil2:
            return "Stencil 2"
        case .canvasBackground:
            return "Canvas Background"
        case .stroke1:
            return "Stroke 1"
        case .stroke2:
            return "Stroke 2"
        case .strokeDisabled:
            return "Stroke Disabled"
        case .strokeAccessible:
            return "Stroke Accessible"
        case .strokeFocus1:
            return "Stroke Focus 1"
        case .strokeFocus2:
            return "Stroke Focus 2"
        case .brandStroke1:
            return "Brand Stroke 1"
        case .brandStroke1Pressed:
            return "Brand Stroke 1 Pressed"
        case .brandStroke1Selected:
            return "Brand Stroke 1 Selected"
        }
    }
}
