//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class CommandingBottomSheetController: UIViewController {

    public override func loadView() {
        view = BottomSheetPassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == .regular {
            setupBottomBarLayout()
        } else if traitCollection.horizontalSizeClass == .compact {
            setupBottomSheetLayout()
        }
    }

    private func setupBottomBarLayout() {
        bottomBarView = BottomBarView()
        bottomBarView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarView!)

        NSLayoutConstraint.activate([
            bottomBarView!.widthAnchor.constraint(equalToConstant: 592),
            bottomBarView!.heightAnchor.constraint(equalToConstant: 80),
            bottomBarView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBarView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -31)
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
