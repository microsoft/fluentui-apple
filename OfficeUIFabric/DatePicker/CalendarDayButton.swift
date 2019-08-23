//
// Copyright Microsoft Corporation
//

import AppKit

fileprivate struct Constants {
    /// Font size of the label will be scaled to this fraction of the radius passed in
    static let fontSizeScalingDefault: CGFloat = 0.45
    
    /// Color used for the current month CalendarDayButtons in dark mode
    static var primaryFontColorDarkMode: NSColor {
        return NSColor.white.withAlphaComponent(0.9)
    }
    
    /// Color used for the current month CalendarDayButtons in light mode
    static var primaryFontColorLightMode: NSColor {
        return NSColor.black.withAlphaComponent(0.9)
    }
    
    /// Color used for the previous/next month CalendarDayButtons in dark mode
    static var secondaryFontColorDarkMode: NSColor {
        return NSColor.white.withAlphaComponent(0.5)
    }
    
    /// Color used for the previous/next month CalendarDayButtons in light mode
    static var secondaryFontColorLightMode: NSColor {
        return NSColor.black.withAlphaComponent(0.5)
    }
    
    /// make the init method private so clients don't unintentionally instantiate this struct
    private init() {}
}

/// A circular button with a day label centered inside of it. This is meant to be used in a grid-like calendar view.
class CalendarDayButton: NSButton {
    
    enum LabelType {
        case primary
        case secondary
    }
    
    /// Initializes a calendar day button with a size, date, font size, and font color.
    ///
    /// - Parameters:
    ///   - size: Diameter of the circular button
    ///   - date: Date of which the day should be displayed. Defaults to current date.
    ///   - fontSize: Font size of the day label. Defaults to fraction of the radius as defined in the Constants.
    init(size: CGFloat, date: Date?, fontSize: CGFloat?) {
        self.size = size
        self.date = date ?? Date()
        self.fontSize = fontSize ?? Constants.fontSizeScalingDefault * size
        
        let frame = NSRect.init(x: 0, y: 0, width: size, height: size)
        super.init(frame: frame)
        
        wantsLayer = true
        setButtonType(.onOff)
        
        // Needed to support .compositingFilter on the highlightLayer
        layerUsesCoreImageFilters = true
        
        // Mask used to create the circular shape.
        // layer?.cornerRadius could replace this, but it is causing visual artifacts
        //  when layerUsesCoreImageFilters = true (10.14.4)
        let maskPath = NSBezierPath(roundedRect: frame, xRadius: size / 2.0, yRadius: size / 2.0)
        maskLayer.frame = frame
        maskLayer.path = maskPath.cgPath
        maskLayer.contentsScale = window?.backingScaleFactor ?? 1.0
        layer?.mask = maskLayer
        
        // Text layer used for the label
        textLayer.frame = frame
        textLayer.string = dateFormatter.string(from: self.date)
        textLayer.font = NSFont.systemFont(ofSize: self.fontSize)
        textLayer.fontSize = self.fontSize
        textLayer.alignmentMode = .center
        textLayer.contentsScale = window?.backingScaleFactor ?? 1.0
        layer?.addSublayer(textLayer)
        
        // Layer with a compositing filter used to 'subtract' the text from the highlight circle
        highlightLayer.frame = frame
        highlightLayer.compositingFilter = CIFilter(name: "CISourceOutCompositing")
        highlightLayer.backgroundColor = NSColor.systemBlue.cgColor
        highlightLayer.contentsScale = window?.backingScaleFactor ?? 1.0
        
        let constraints = [
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size),
        ]
        NSLayoutConstraint.activate(constraints)
        
        setAccessibilityLabel(accessibilityFormatter.string(from: self.date))
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayer() {
        switch state {
        case .on:
            textLayer.addSublayer(highlightLayer)
            textLayer.font = NSFont.boldSystemFont(ofSize: fontSize)
        case .off:
            if highlightLayer.superlayer != nil {
                highlightLayer.removeFromSuperlayer()
            }
            textLayer.font = NSFont.systemFont(ofSize: fontSize)
        default:
            break
        }
        
        switch type {
        case .primary:
            textLayer.foregroundColor = isDarkMode ? Constants.primaryFontColorDarkMode.cgColor : Constants.primaryFontColorLightMode.cgColor
        case .secondary:
            textLayer.foregroundColor = isDarkMode ? Constants.secondaryFontColorDarkMode.cgColor : Constants.secondaryFontColorLightMode.cgColor
        }
    }
    
    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        
        // Update the layer content scales to the current window backingScaleFactor
        guard let scale = window?.backingScaleFactor else {
            return
        }
        
        if layer?.contentsScale != scale {
            layer?.contentsScale = scale
        }
        if textLayer.contentsScale != scale {
            textLayer.contentsScale = scale
        }
        if highlightLayer.contentsScale != scale {
            highlightLayer.contentsScale = scale
        }
        if maskLayer.contentsScale != scale {
            maskLayer.contentsScale = scale
        }
    }
    
    // Draws circular focus ring
    override func drawFocusRingMask() {
        let rect = bounds;
        let circlePath = NSBezierPath()
        circlePath.appendOval(in: rect)
        
        circlePath.fill()
    }
    
    override var wantsUpdateLayer: Bool {
        get {
            return true
        }
    }
    
    var date: Date {
        didSet {
            textLayer.string = dateFormatter.string(from: date)
            setAccessibilityLabel(accessibilityFormatter.string(from: date))
        }
    }
    
    var fontSize: CGFloat {
        didSet {
            textLayer.fontSize = fontSize
        }
    }
    
    var type: LabelType = .primary {
        didSet {
            // Ensures that updateLayer is called after button type change
            if type != oldValue {
                needsDisplay = true
            }
        }
    }
    
    private let size: CGFloat
    
    private let textLayer = CenteredTextLayer()
    private let highlightLayer = CALayer()
    private let maskLayer = CAShapeLayer()
    
    /// Date formatter used to convert the given date to a string
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "d"
        
        return dateFormatter
    }()
    
    /// Date formatter used for the accessibility label
    private let accessibilityFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    private var isDarkMode: Bool {
        var isInDarkAppearance = false
        if #available(OSX 10.14, *) {
            if effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua {
                isInDarkAppearance  = true
            }
        }
        return isInDarkAppearance
    }
}

private extension NSBezierPath {
    // Converts the NSBezierPath to a CGPath
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< elementCount {
            let type = element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            default:
                ()
            }
        }
        return path
    }
}
