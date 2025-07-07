//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

class CommandBarButtonGroupView: UIView {
    let buttons: [CommandBarButton]
    let title: String?

    init(buttons: [CommandBarButton], title: String?, tokenSet: CommandBarTokenSet) {
        self.buttons = buttons
        self.title = title
        self.tokenSet = tokenSet

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        configureHierarchy()
        applyInsets()
        hideGroupIfNeeded()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Hides the group view if all the views inside the `stackView` are hidden
    func hideGroupIfNeeded() {
        var allViewsHidden = true
        for view in buttonStackView.arrangedSubviews {
            if !view.isHidden {
                allViewsHidden = false
                break
            }
        }

        isHidden = allViewsHidden
    }

    var equalWidthButtons: Bool = false {
        didSet {
            buttonStackView.distribution = equalWidthButtons ? .fillEqually : .fill
        }
    }

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = CommandBarTokenSet.itemInterspace

        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = tokenSet[.groupBorderRadius].float
        stackView.layer.cornerCurve = .continuous
        return stackView
    }()

    private lazy var groupLabel: Label = {
        let label = Label()
        label.text = title
        label.font = tokenSet[.itemGroupLabelFont].uiFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        label.lineBreakMode = .byClipping

        label.accessibilityTraits.insert(.header)
        label.isUserInteractionEnabled = true
        label.addInteraction(UILargeContentViewerInteraction())
        label.showsLargeContentViewer = true
        label.largeContentTitle = title
        return label
    }()

    private func configureHierarchy() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        stackView.addArrangedSubview(buttonStackView)
        if title != nil {
            stackView.addArrangedSubview(groupLabel)
        }
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

    private func applyInsets() {
        buttons.first?.configuration?.contentInsets.leading += CommandBarTokenSet.leftRightBuffer
        buttons.last?.configuration?.contentInsets.trailing += CommandBarTokenSet.leftRightBuffer
    }

    private var tokenSet: CommandBarTokenSet
}
