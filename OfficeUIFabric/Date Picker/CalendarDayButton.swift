//
// Copyright Microsoft Corporation
//

import AppKit

fileprivate struct Constants {
    /// Font size of the label will be scaled to this fraction of the radius passed in
    static let fontSizeScalingDefault: CGFloat = 0.45
    
    /// Default label font color
    static let fontColorDefault: NSColor = NSColor.labelColor
    
    /// make the init method private so clients don't unintentionally instantiate this struct
    private init() {}
}

/// A circular button with a day label centered inside of it. This is meant to be used in a grid-like calendar view.
class CalendarDayButton: NSView {
    
    enum State {
        case on
        case off
    }
    
    /// Initializes a calendar day button with a size, date, font size, and font color.
    ///
    /// - Parameters:
    ///   - size: Diameter of the circular button
    ///   - date: Date of which the day should be displayed. Defaults to current date.
    ///   - fontSize: Font size of the day label. Defaults to fraction of the radius as defined in the Constants.
    ///   - fontColor: Font color of the day label. Defaults to NSColor.labelColor
    init(size: CGFloat, date : Date?, fontSize: CGFloat?, fontColor: NSColor?) {
        self.size = size
        self.date = date ?? Date()
        self.fontSize = fontSize ?? Constants.fontSizeScalingDefault * size
        self.fontColor = fontColor ?? Constants.fontColorDefault
        
        let frame = NSRect.init(x: 0, y: 0, width: size, height: size)
        super.init(frame: frame)
        
        wantsLayer = true
        
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
        textLayer.foregroundColor = self.fontColor.cgColor
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
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.calendarDayButton(self, wasClicked: event)
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
    
    override var wantsUpdateLayer: Bool {
        get {
            return true
        }
    }
    
    weak var delegate : CalendarDayButtonDelegate?
    
    var date : Date {
        didSet {
            textLayer.string = dateFormatter.string(from: date)
        }
    }
    
    var fontColor : NSColor {
        didSet {
            textLayer.foregroundColor = fontColor.cgColor
        }
    }
    
    var fontSize : CGFloat {
        didSet {
            textLayer.fontSize = fontSize
        }
    }
    
    var state : State = .off {
        didSet {
            // Ensures that updateLayer is called after state change
            if state != oldValue {
                self.needsDisplay = true
            }
        }
    }
    
    private let size : CGFloat
    
    private let textLayer = CenteredTextLayer()
    private let highlightLayer = CALayer()
    private let maskLayer = CAShapeLayer()
    
    /// Date formatter used to convert the given date to a string
    private let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "d"
        
        return dateFormatter
    }()
}

protocol CalendarDayButtonDelegate : class {
    // Called when a mouseDown event occurs on the button
    func calendarDayButton(_ calendarDayButton : CalendarDayButton, wasClicked event : NSEvent)
}

private extension NSBezierPath {
    // Converts the NSBezierPath to a CGPath
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
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
