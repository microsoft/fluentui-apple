//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class CommandingBottomSheetController: UIViewController {

    open var heroItems: [CommandingItem] = [CommandingItem]() {
        didSet {
            if heroItems.count > 5 {
                assertionFailure("At most 5 hero commands are supported. Only the first 5 items will be used.")
                heroItems = Array(heroItems.prefix(5))
            }

            heroCommandStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for item in heroItems {
                let itemView = BottomBarItemView(item: item)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeroCommandTap(_:)))
                itemView.addGestureRecognizer(tapGesture)

                heroCommandStack.addArrangedSubview(itemView)
            }
        }
    }

    public override func loadView() {
        view = BottomSheetPassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == .regular {
            setupBottomBarLayout()
        } else if traitCollection.horizontalSizeClass == .compact {
            setupBottomSheetLayout()
        }
    }

    private lazy var heroCommandStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()

    @objc private func handleHeroCommandTap(_ sender: BottomBarItemView) {

    }

    private func setupBottomBarLayout() {
        let bottomBarView = BottomBarView()
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(heroCommandStack)

        self.bottomBarView = bottomBarView

        NSLayoutConstraint.activate([
            bottomBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -31),
            bottomBarView.leadingAnchor.constraint(equalTo: heroCommandStack.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: heroCommandStack.trailingAnchor),
            bottomBarView.topAnchor.constraint(equalTo: heroCommandStack.topAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: heroCommandStack.bottomAnchor)
        ])
    }

    private func setupBottomSheetLayout() {
        let sheetController = BottomSheetController(with: DummyBottomSheetContent())

        addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)
        bottomSheetController = sheetController

        NSLayoutConstraint.activate([
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    private var bottomBarView: BottomBarView?

    private var bottomSheetController: BottomSheetController?

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            if let previousTraits = previousTraitCollection {
                if previousTraits.horizontalSizeClass == .compact {
                    bottomSheetController?.willMove(toParent: nil)
                    bottomSheetController?.removeFromParent()
                    bottomSheetController?.view.removeFromSuperview()
                    bottomSheetController = nil
                } else if previousTraits.horizontalSizeClass == .regular {
                    bottomBarView?.removeFromSuperview()
                    bottomBarView = nil
                }
            }

            switch traitCollection.horizontalSizeClass {
            case .compact:
                setupBottomSheetLayout()
            case .regular:
                setupBottomBarLayout()
            default:
                break
            }
        }
    }
}

private class DummyBottomSheetContent: UIViewController {
    override func loadView() {
        super.loadView()

        let label = UILabel()
        label.text = "Hello World"
        view.addSubview(label)
        view.backgroundColor = .systemBlue
    }
}
