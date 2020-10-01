//
//  Rhs.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation

struct Rhs {
    
    enum Key: String, CodingKey {
        case font
        case enumDef
    }
    
    enum ColorInputError : Error {
        case missingHashMarkAsPrefix, unableToScanHexValue, mismatchedHexStringLength
    }
    
    class Color {
        
        let red: Float
        let green: Float
        let blue: Float
        let alpha: Float
        var darken: Bool? = false
        var lighten: Bool? = false
        
        init(red: Float, green: Float, blue: Float, alpha: Float) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
        
        convenience init(hex3: UInt16, alpha: Float = 1) {
            let divisor = Float(15)
            let red     = Float((hex3 & 0xF00) >> 8) / divisor
            let green   = Float((hex3 & 0x0F0) >> 4) / divisor
            let blue    = Float( hex3 & 0x00F      ) / divisor
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        convenience init(hex4: UInt16) {
            let divisor = Float(15)
            let red     = Float((hex4 & 0xF000) >> 12) / divisor
            let green   = Float((hex4 & 0x0F00) >>  8) / divisor
            let blue    = Float((hex4 & 0x00F0) >>  4) / divisor
            let alpha   = Float( hex4 & 0x000F       ) / Float(10)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        convenience init(hex6: UInt32, alpha: Float = 1) {
            let divisor = Float(255)
            let red     = Float((hex6 & 0xFF0000) >> 16) / divisor
            let green   = Float((hex6 & 0x00FF00) >>  8) / divisor
            let blue    = Float( hex6 & 0x0000FF       ) / divisor
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        convenience init(hex8: UInt32) {
            let divisor = Float(255)
            let red     = Float((hex8 & 0xFF000000) >> 24) / divisor
            let green   = Float((hex8 & 0x00FF0000) >> 16) / divisor
            let blue    = Float((hex8 & 0x0000FF00) >>  8) / divisor
            let alpha   = Float( hex8 & 0x000000FF       ) / Float(10)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        convenience init(rgba_throws rgba: String) throws {
            guard rgba.hasPrefix("#") else {
                throw ColorInputError.missingHashMarkAsPrefix
            }
            var hexString: String = String(rgba[rgba.index(rgba.startIndex, offsetBy: 1)...])
            var alpha: Float = 1
            if hexString.count == 5 || hexString.count == 8 {
                //has alpha indication
                let alphaString: String = String(hexString[hexString.index(hexString.endIndex, offsetBy: -2)...])
                alpha = ((alphaString as NSString).floatValue)/100.0
                hexString = String(hexString[..<hexString.index(hexString.endIndex, offsetBy: -2)])
            }
            guard
                var hexValue:  UInt32 = Optional(0),
                Scanner(string: hexString).scanHexInt32(&hexValue) else {
                    throw ColorInputError.unableToScanHexValue
            }
            
            guard hexString.count  == 3
                || hexString.count == 4
                || hexString.count == 6
                || hexString.count == 8 else {
                    throw ColorInputError.mismatchedHexStringLength
            }
            
            switch (hexString.count) {
            case 3:
                self.init(hex3: UInt16(hexValue), alpha: alpha)
            case 6:
                self.init(hex6: hexValue, alpha: alpha)
            default:
                fatalError()
                break
            }
        }
        
        convenience init(rgba: String) {
            try! self.init(rgba_throws: rgba)
        }
        
        func hexString(_ includeAlpha: Bool) -> String {
            let r: Float = self.red
            let g: Float = self.green
            let b: Float = self.blue
            let a: Float = self.alpha
            
            if (includeAlpha) {
                return String(format: "#%02X%02X%02X%02X",
                              Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
            } else {
                return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
            }
        }
        
        var description: String {
            return self.hexString(true)
        }
        
        var debugDescription: String {
            return self.hexString(true)
        }
    }
    
    class Font {
        let fontName: String?
        var fontWeight: String?
        var fontTraits: String?
        var fontSize: Float?
        var fontStyle: String?
        var isSymbolFont: Bool = false
        
        var isSystemPreferred: Bool {
            return fontName?.contains("PreferredSystem") ?? false
        }
        
        var isScalableFont: Bool {
            return fontStyle != nil
        }
        
        var isSystemFont: Bool {
            return fontName?.contains("System") ?? false
        }
        
        var systemTextStyle: String? {
            if isScalableFont == false { return nil }
            
            let style = fontStyle!
            assert(Rhs.Font.supportedStyles.contains(style),
                   "\(style) is not a valid system font style. Allowed styles: \(Rhs.Font.supportedStyles)")
            
            return "UIFont.TextStyle.\(style)"
        }
        
        var textStyle: String? {
            guard let fontStyle = fontStyle, isScalableFont else { return nil }
            return "\(FontTextStyle)." + fontStyle
        }
        
        var weight: String? {
            guard let fontWeight = fontWeight else { return nil }
            assert(Rhs.Font.supportedWeights.contains(fontWeight),
                   "\(fontWeight) is not a valid system font weight. Allowed weights: \(Rhs.Font.supportedWeights)")
            return "UIFont.Weight.\(fontWeight)"
        }
        
        var traits: String? {
            guard let fontTraits = fontTraits else { return nil }
            var string = "["
            for component in fontTraits.components(separatedBy: "-") {
                assert(Rhs.Font.supportedTraits.contains(component),
                       "\(component) is not a valid system font trait. Allowed traits: \(Rhs.Font.supportedTraits)")
                string.append("UIFontDescriptor.SymbolicTraits.trait\(component.firstUppercased), ")
            }
            string = String(string.dropLast(2))
            string.append("]")
            return string
        }
        
        init(symbolName: String) {
            self.fontName = symbolName
            self.isSymbolFont = true
        }
        
        init(name: String? = nil, size: Float? = nil, textStyle: String? = nil, weightAndTraits: [String]? = nil) {
            self.fontName = name
            self.fontTraits = traits
            self.fontSize = size
            self.fontStyle = textStyle
         
            if let weightAndTraits = weightAndTraits {
                if weightAndTraits.count == 2 {
                    self.fontWeight = weightAndTraits.first
                    self.fontTraits = weightAndTraits.last
                } else if let component = weightAndTraits.first {
                    if Rhs.Font.supportedWeights.contains(component) {
                        self.fontWeight = component
                    } else {
                        self.fontTraits = component
                    }
                }
            }
        }
        
        static let supportedStyles = ["caption2",
                                      "caption1",
                                      "footnote",
                                      "subheadline",
                                      "callout",
                                      "body",
                                      "headline",
                                      "title3",
                                      "title2",
                                      "title1",
                                      "largeTitle"]
        
        static let supportedWeights = ["ultraLight",
                                       "thin",
                                       "light",
                                       "regular",
                                       "medium",
                                       "semibold",
                                       "bold",
                                       "heavy",
                                       "black"]
        
        static let supportedTraits = ["italic",
                                      "bold",
                                      "expanded",
                                      "condensed",
                                      "monospace",
                                      "vertical"]
    }
    
    class TimingFunction {
        var controlPoints: (c1: Float, c2: Float, c3: Float, c4: Float)?
        var name: String?
        
        init(name: String) {
            let functionNames = ["easeIn",
                                 "easeInOut",
                                 "easeOut",
                                 "linear"]
            assert(functionNames.contains(name),
                   "\(name) is not a valid timing function. Allowed timing functions: \(functionNames)")
            self.name = "UIView.AnimationCurve.\(name)"
        }
        
        init(c1: Float, c2: Float, c3: Float, c4:Float) {
            self.controlPoints = (c1: c1, c2: c2, c3: c3, c4: c4)
        }
    }
    
    class KeyFrame {
        
        struct Props {
            static let keyFrameKey = "keyFrame"
            static let relativeStartTimeKey = "relativeStartTime"
            static let relativeDurationKey = "relativeDuration"
            static let animationValuesKey = "animationValues"
        }
        
        var relativeStartTime: Float?
        var relativeDuration: Float?
        var values: RhsValue?
        
        init(relativeStartTime: Float?, relativeDuration: Float?, values: RhsValue?) {
            self.relativeStartTime = relativeStartTime
            self.relativeDuration = relativeDuration
            self.values = values
        }
    }
    
    class AnimationValue {
        var type: String
        var from: RhsValue?
        var to: RhsValue
        
        struct Props {
            static let animationValueKey = "animationValue"
            static let typeKey = "type"
            static let fromKey = "from"
            static let toKey = "to"
        }
        
        var enumType: String {
            let types = ["opacity",
                         "frame",
                         "size",
                         "width",
                         "height",
                         "left",
                         "rotate"]
            assert(types.contains(type),
                   "\(type) is not a valid animatable prop. Allowed animatable props: \(types)")
            return ".\(type)(from: \((from?.generate() ?? "nil")), to: \(to.generate()))"
        }
        
        init(type: String, from: RhsValue?, to: RhsValue) {
            self.type = type
            self.from = from
            self.to = to
        }
    }
}
