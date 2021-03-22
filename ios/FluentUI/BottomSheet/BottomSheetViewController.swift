//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum BottomSheetViewState {
    case expand
    case collapse
}

open class BottomSheetViewController: UIViewController {
    private var animator: UIViewPropertyAnimator?
    private var contentViewController: UIViewController
    private var currentState: BottomSheetViewState = .collapse
    private lazy var gestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handlePan))
        return recognizer
    }()

    @objc public init(with contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        addChild(contentViewController)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4

        view.addGestureRecognizer(gestureRecognizer)

        if let contentView = contentViewController.view {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(contentViewController.view)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: view.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let positionInSuperview = gesture.translation(in: view.superview)

        switch gesture.state {
        case .began:
            panningStart()
        case .changed:
            panningProgress(in: positionInSuperview.y)
        case .ended:
            let velocity = gesture.velocity(in: view)
            panningStop(in: positionInSuperview.y, velocity: velocity.y)
        default:
           break
        }
    }

    private func panningStart() {
        if animator?.isRunning ?? false {
           return
        }

        let targetFrame: CGRect
        let windowFrame = self.view.window?.frame ?? .zero
        switch currentState {
        case .collapse:
                targetFrame = windowFrame
        case .expand:
            // todo right size
            targetFrame = CGRect(x: 0, y: (windowFrame.height - 200), width: windowFrame.width, height: 200)
        }

        animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: { [weak self] in
            self?.view.frame = targetFrame
        })
    }

    private func panningStop(in verticalPos: CGFloat, velocity: CGFloat) {
        gestureRecognizer.isEnabled = false

        let windowHeight = view.window?.frame.height ?? 0
        let shouldReverse: Bool
        let futureState: BottomSheetViewState
        switch currentState {
        case .expand:
            if verticalPos >= windowHeight / 2 || velocity > 250 {
                shouldReverse = false
                futureState = .collapse
            } else {
                shouldReverse = true
                futureState = .expand
            }
        case .collapse:
            if verticalPos <= -windowHeight / 2 || velocity <= -250 {
                shouldReverse = false
                futureState = .expand
            } else {
                shouldReverse = true
                futureState = .collapse
            }
        }

        animator?.isReversed = shouldReverse
        animator?.addCompletion { [weak self] _ in
            self?.currentState = futureState
            self?.gestureRecognizer.isEnabled = true
        }
        animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }

    private func panningProgress(in verticalPos: CGFloat) {
        if animator?.isRunning ?? false {
           return
        }

        var progress = -1 * verticalPos / (view.center.y + verticalPos)
        if currentState == .expand {
            progress *= -1
        }

        animator?.fractionComplete = progress
    }
}
