//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSCalendarViewDayCellTextStyle

enum MSCalendarViewDayCellTextStyle {
    case primary
    case secondary
}

// MARK: - MSCalendarViewDayCellBackgroundStyle

enum MSCalendarViewDayCellBackgroundStyle {
    case primary
    case secondary
}

// MARK: - MSCalendarViewDayCellVisualState

enum MSCalendarViewDayCellVisualState {
    case normal          // Collapsed `.Short` style
    case normalWithDots  // Expanded `.Tall` style
    case fadedWithDots   // Expanded `.Half` or `.Tall` style during user interaction
}

// MARK: - MSCalendarViewDayCellSelectionType

enum MSCalendarViewDayCellSelectionType {
    case singleSelection
    case startOfRangedSelection
    case middleOfRangedSelection
    case endOfRangedSelection
}

// MARK: - MSCalendarViewDayCellSelectionStyle

enum MSCalendarViewDayCellSelectionStyle {
    case normal
    case freeAtSpecificTimeSlot
    case freeAtDifferentTimeSlot
    case busy
    case unknown
}

let MSCalendarViewDayCellVisualStateTransitionDuration: TimeInterval = 0.3

// MARK: - MSCalendarViewDayCell

class MSCalendarViewDayCell: UICollectionViewCell {
    struct Constants {
        static let borderWidth: CGFloat = UIScreen.main.devicePixel
        static let dotDiameter: CGFloat = 4.0
        static let fadedVisualStateAlphaMultiplier: CGFloat = 0.2
    }

    class var identifier: String { return "MSCalendarViewDayCell" }

    override var isSelected: Bool {
        didSet {
            selectionOverlayView.selected = isSelected
            updateViews()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            selectionOverlayView.highlighted = isHighlighted
            updateViews()
        }
    }

    private(set) var textStyle: MSCalendarViewDayCellTextStyle = .primary
    private(set) var backgroundStyle: MSCalendarViewDayCellBackgroundStyle = .primary

    private var visibleDotViewAlpha: CGFloat = 1.0

    private let selectionOverlayView: MSSelectionOverlayView
    let dateLabel: UILabel
    let dotView: MSDotView

    override init(frame: CGRect) {
        // Initialize subviews
        //
        // Disable user interaction to allow gestures to fall through to the collection view
        // and collection view cell especially during animation. This is protect against
        // subviews that default `userInteractionEnabled` to true (UIView).

        selectionOverlayView = MSSelectionOverlayView()
        selectionOverlayView.isUserInteractionEnabled = false

        dateLabel = UILabel(frame: .zero)
        dateLabel.font = MSFonts.body
        dateLabel.textAlignment = .center
        dateLabel.textColor = MSColors.CalendarView.DayCell.textColorPrimary

        dotView = MSDotView()
        dotView.color = MSColors.CalendarView.DayCell.textColorPrimary
        dotView.alpha = 0.0  // Initial `visualState` is `.Normal` without dots
        dotView.isUserInteractionEnabled = false

        super.init(frame: frame)

        contentView.addSubview(selectionOverlayView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dotView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Only supports indicator levels from 0...4
    func setup(textStyle: MSCalendarViewDayCellTextStyle, backgroundStyle: MSCalendarViewDayCellBackgroundStyle, selectionStyle: MSCalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        self.textStyle = textStyle
        self.backgroundStyle = backgroundStyle
        selectionOverlayView.selectionStyle = selectionStyle

        // Assign text content
        dateLabel.text = dateLabelText

        // Assign dot content
        visibleDotViewAlpha = CGFloat(min(indicatorLevel, 4)) / 4.0

        updateViews()
    }

    func setVisualState(_ visualState: MSCalendarViewDayCellVisualState, animated: Bool) {
        func applyVisualState() {
            switch visualState {
            case .normal:
                contentView.alpha = 1.0
                dateLabel.alpha = 1.0
                dotView.alpha = 0.0
                selectionOverlayView.alpha = 1.0

            case .normalWithDots:
                contentView.alpha = 1.0
                dateLabel.alpha = 1.0
                dotView.alpha = visibleDotViewAlpha
                selectionOverlayView.alpha = 1.0

            case .fadedWithDots:
                contentView.alpha = Constants.fadedVisualStateAlphaMultiplier
                dateLabel.alpha = 1.0
                dotView.alpha = visibleDotViewAlpha
                selectionOverlayView.alpha = 1.0
            }
        }

        if animated {
            UIView.animate(withDuration: MSCalendarViewDayCellVisualStateTransitionDuration, animations: applyVisualState)
        } else {
            applyVisualState()
        }
    }

    func setSelectionType(_ selectionType: MSCalendarViewDayCellSelectionType) {
        selectionOverlayView.selectionType = selectionType
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        selectionOverlayView.frame = contentView.bounds

        let maxWidth = contentView.bounds.size.width
        let maxHeight = contentView.bounds.size.height

        // Date label
        dateLabel.frame = contentView.bounds

        // Dot view
        dotView.frame = CGRect(
            x: (maxWidth - Constants.dotDiameter) / 2.0,
            y: ((maxHeight - Constants.dotDiameter) / 2.0) + 15.0,
            width: Constants.dotDiameter,
            height: Constants.dotDiameter
        )
    }

    private func updateViews() {
        switch textStyle {
        case .primary:
            dateLabel.textColor = MSColors.CalendarView.DayCell.textColorPrimary
        case .secondary:
            dateLabel.textColor = MSColors.CalendarView.DayCell.textColorSecondary
        }

        switch backgroundStyle {
        case .primary:
            contentView.backgroundColor = MSColors.CalendarView.DayCell.backgroundColorPrimary
        case .secondary:
            contentView.backgroundColor = MSColors.CalendarView.DayCell.backgroundColorSecondary
        }

        if isHighlighted || isSelected {
            dotView.isHidden = true
            dateLabel.textColor = MSColors.white
        } else {
            dotView.isHidden = false
        }

        setNeedsLayout()
    }
}

// MARK: - MSSelectionOverlayView

private class MSSelectionOverlayView: UIView {
    struct Constants {
        static let highlightedOrSelectedCircleMargin: CGFloat = 5.0
    }

    var selectionType: MSCalendarViewDayCellSelectionType = .singleSelection {
        didSet {
            setupActiveViews()
        }
    }
    var selectionStyle: MSCalendarViewDayCellSelectionStyle = .normal

    // TODO: Add different colors for availability?
    var selected: Bool = false {
        didSet {
            activeColor = MSColors.CalendarView.DayCell.selectedCircleNormalColor
            setupActiveViews()
        }
    }
    var highlighted: Bool = false {
        didSet {
            activeColor = MSColors.CalendarView.DayCell.highlightedCircleColor
            setupActiveViews()
        }
    }

    private var activeColor: UIColor = MSColors.CalendarView.DayCell.highlightedCircleColor

    // Lazy load views as every additional subview impacts the "Calendar"
    // tab loading time because the MSDatePicker needs
    // to initialize N * 7 cells when loading the view
    private var circleView: MSDotView?
    private var squareView: UIView?

    override func layoutSubviews() {
        super.layoutSubviews()

        let maxWidth = bounds.size.width
        let maxHeight = bounds.size.height

        let circleDiameter = min(maxWidth, maxHeight) - (2.0 * Constants.highlightedOrSelectedCircleMargin)

        let originY = (maxHeight - circleDiameter) / 2.0
        circleView?.frame = CGRect(x: (maxWidth - circleDiameter) / 2.0, y: originY, width: circleDiameter, height: circleDiameter)

        switch selectionType {
        case .startOfRangedSelection:
            squareView?.frame = CGRect(x: maxWidth / 2, y: originY, width: maxWidth / 2, height: circleDiameter)
        case .middleOfRangedSelection:
            squareView?.frame = CGRect(x: 0, y: originY, width: maxWidth, height: circleDiameter)
        case .endOfRangedSelection:
            squareView?.frame = CGRect(x: 0, y: originY, width: maxWidth / 2, height: circleDiameter)
        case .singleSelection:
            break
        }

        flipSubviewsForRTL()
    }

    private func setupActiveViews() {
        switch selectionType {
        case .singleSelection:
            setupCircleView()
            squareView?.isHidden = true
        case .middleOfRangedSelection:
            setupSquareView()
            circleView?.isHidden = true
        case .startOfRangedSelection, .endOfRangedSelection:
            setupCircleView()
            setupSquareView()
        }

        setNeedsLayout()
    }

    private func setupCircleView() {
        if circleView == nil {
            circleView = MSDotView()
        }

        setupView(circleView!)
        circleView!.color = activeColor
    }

    private func setupSquareView() {
        if squareView == nil {
            squareView = UIView()
        }

        setupView(squareView!)
        squareView!.backgroundColor = activeColor
    }

    private func setupView(_ view: UIView) {
        if view.superview == nil {
            addSubview(view)
        }

        bringSubviewToFront(view)
        view.isHidden = !(selected || highlighted)
    }
}
