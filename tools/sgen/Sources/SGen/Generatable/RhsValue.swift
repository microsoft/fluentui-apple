//
//  RhsValue.swift
//  sgen
//
//  Created by Daniele Pizziconi on 12/06/2020.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import Yaml

enum RhsError: Error {
    case malformedRhsValue(error: String)
    case malformedCondition(error: String)
    case `internal`
}

enum RhsValue {
    
    /// An int value
    case int(int: Int)
    
    /// A float value.
    case float(float: Float)
    
    /// A CGPoint.
    case point(x: Float, y: Float)
    
    /// A CGPoint.
    case size(width: Float, height: Float)
    
    /// A CGRect value.
    case rect(x: Float, y: Float, width: Float, height: Float)
    
    /// A UIEdgeInsets value.
    case edgeInset(top: Float, left: Float, bottom: Float, right: Float)
    
    /// A boolean value.
    case boolean(bool: Bool)
    
    /// A font value.
    case font(font: Rhs.Font)
    
    /// A FluentUI standard color.
    case fluentUIColor(fluentUIColor: Rhs.FluentUIColor)
    
    /// A named color in an asset catalog.
    case namedColor(namedColor: Rhs.NamedColor)
    
    /// A color value.
    case color(color: Rhs.Color)
    
    /// A image.
    case image(image: String)
    
    /// A redirection to another value.
    case redirect(redirection: RhsRedirectValue)
    
    /// A map between cocndition and a rhs.
    case hash(hash: [Condition: RhsValue])
    
    /// An enum definitition.
    case enumDef(type: String, names: [String])
    
    /// An enum.
    case `enum`(type: String, name: String)
    
    /// An option definitition.
    case optionDef(type: String, names: [String])
    
    /// An option.
    case option(type: String, names: [String])
    
    /// An animation curve
    case timingFunction(function: Rhs.TimingFunction)
    
    /// A KeyFrame.
    case keyFrame(keyFrame: Rhs.KeyFrame)
    
    /// A KeyFrameValue.
    case keyFrameValue(value: Rhs.AnimationValue)
    
    /// A repeat count type.
    case repeatCount(count: String)
    
    /// An array of RhsValue
    case array(values: [RhsValue])
    
    /// A call to the super stylesheet.
    case call(call: String, type: String)
    
    var isHash: Bool {
        switch self {
        case .hash: return true
        default: return false
        }
    }
    
    var isGlobal: Bool {
        switch self {
        case .enumDef, .optionDef: return true
        default: return false
        }
    }
    
    var isRedirect: Bool {
        switch self {
        case .redirect: return true
        default: return false
        }
    }
    
    var redirection: String? {
        switch self {
        case .redirect(let r): return r.redirection
        default: return nil
        }
    }
    
    func applyRedirection(_ redirectValue: RhsRedirectValue) -> RhsValue {
        switch self {
        case .redirect(_): return .redirect(redirection: redirectValue)
        default: return self
        }
    }
    
    static func valueFrom(_ int: Int) -> RhsValue  {
        return .int(int: Int(int))
    }
    
    static func valueFrom(_ float: Float) -> RhsValue  {
        return .float(float: Float(float))
    }
    
    static func valueFrom(_ boolean: Bool) -> RhsValue  {
        return .boolean(bool: boolean)
    }
    
    static func valueFrom(_ array: [Yaml]) throws -> RhsValue  {
        var values = [RhsValue]()
        for item in array {
            do {
                var rhsValue: RhsValue? = nil
                switch item {
                case .dictionary(let dictionary): rhsValue = try valueFrom(dictionary)
                case .bool(let boolean): rhsValue = valueFrom(boolean)
                case .int(let integer): rhsValue = valueFrom(integer)
                case .double(let double): rhsValue = valueFrom(Float(double))
                case .string(let string): rhsValue = try valueFrom(string)
                default:
                    throw RhsError.internal
                }
                values.append(rhsValue!)
            } catch {
                throw RhsError.internal
            }
        }
        return .array(values: values)
    }
    
    static func valueFrom(_ hash: [Yaml: Yaml]) throws -> RhsValue  {
        var conditions = [Condition: RhsValue]()
        for (k, value) in hash {
            guard let key = k.string else { continue }
            do {
                switch value {
                case .int(let integer):
                    try conditions[Condition(rawString: key)] = RhsValue.valueFrom(integer)
                case .double(let double):
                    try conditions[Condition(rawString: key)] = RhsValue.valueFrom(Float(double))
                case .string(let string):
                    try conditions[Condition(rawString: key)] = RhsValue.valueFrom(string)
                case .bool(let boolean):
                    try conditions[Condition(rawString: key)] = RhsValue.valueFrom(boolean)
                default:
                    assert(false, "k.string: \(key), value: \(value)")
                    throw RhsError.internal
                }
            } catch {
                assert(false, "altro errore k.string: \(key), value: \(value)")
                throw RhsError.malformedCondition(error: "\(conditions) is not well formed")
            }
        }
        return .hash(hash: conditions)
    }
    
    static func valueFrom(_ string: String) throws  -> RhsValue  {
        
        if let string = Optional(string), isNumber(string), string.hasSuffix("pt") || string.hasSuffix("dp") || string.hasSuffix("f") {
            return .float(float: parseNumber(string))
        } else if var components = argumentsFromString(Rhs.Key.font.rawValue, string: string) {
            if components.count == 1, let component = components.first, component == SymbolNamePlaceholder || Generator.Config.symbolFontNames.first(where: { $0.values.contains(component) }) != nil {
                //Font(symbol)
                return .font(font: Rhs.Font(symbolName: component))
            } else {
                components = components.compactMap({ $0.trimmingCharacters(in: .whitespaces) })
                assert(components.count <= 4, "Not a valid font. Format: Font(\"FontName\", size)")
                if components.contains(where: { isNumber($0) }) {
                    //with size
                    let size: Float
                    let name: String?
                    let firstComponent = components.removeFirst()
                    if isNumber(firstComponent) {
                        //Font(size,...)
                        size = parseNumber(firstComponent)
                        name = nil
                    } else {
                        size = parseNumber(components.removeFirst())
                        name = firstComponent
                    }
                    return .font(font: Rhs.Font(name: name, size: size, weightAndTraits: components))
                
                } else {
                    //with textstyle
                    let textStyle: String
                    let name: String?
                    let firstComponent = components.removeFirst()
                    if Generator.Config.typographyTextStyles.keys.contains(firstComponent) || Rhs.Font.supportedStyles.contains(firstComponent) {
                        textStyle = firstComponent
                        name = nil
                    } else {
                        textStyle = components.removeFirst()
                        name = firstComponent
                    }
                    return .font(font: Rhs.Font(name: name, textStyle: textStyle, weightAndTraits: components))
                }
            }
        } else if let components = argumentsFromString("fluentUIColor", string: string) {
            assert(components.count >= 1 && components.count <= 8, "Not a valid FluentUI color. Format: FluentUIColor(light: NamedColor(communicationBlue), lightHighContrast: #000000, lightElevated: $Colors.Palette.sample, lightElevatedHighContrast: $Colors.Palette.sampleHC, dark: NamedColor(communicationBlue), darkHighContrast: #FFFFFF, darkElevated: $Colors.Palette.sampleDark, darkElevatedHighContrast: $Colors.Palette.sampleDarkHC)")
            
            var light: RhsValue?
            var lightHighContrast: RhsValue?
            var lightElevated: RhsValue?
            var lightElevatedHighContrast: RhsValue?
            var dark: RhsValue?
            var darkHighContrast: RhsValue?
            var darkElevated: RhsValue?
            var darkElevatedHighContrast: RhsValue?
            
            for component in components {
                let parameter = component.trimmingCharacters(in: .whitespacesAndNewlines)
                if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.lightKey):") {
                    light = try? valueFrom(escape(Rhs.FluentUIColor.Props.lightKey, string: parameter))
                } else if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.lightHighContrastKey):") {
                    lightHighContrast = try? valueFrom(escape(Rhs.FluentUIColor.Props.lightHighContrastKey, string: parameter))
                } else if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.lightElevatedKey):") {
                    lightElevated = try? valueFrom(escape(Rhs.FluentUIColor.Props.lightElevatedKey, string: parameter))
                } else if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.lightElevatedHighContrastKey):") {
                    lightElevatedHighContrast = try? valueFrom(escape(Rhs.FluentUIColor.Props.lightElevatedHighContrastKey, string: parameter))
                } else if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.darkKey):") {
                    dark = try? valueFrom(escape(Rhs.FluentUIColor.Props.darkKey, string: parameter))
                } else if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.darkHighContrastKey):") {
                    darkHighContrast = try? valueFrom(escape(Rhs.FluentUIColor.Props.darkHighContrastKey, string: parameter))
                } else if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.darkElevatedKey):") {
                    darkElevated = try? valueFrom(escape(Rhs.FluentUIColor.Props.darkElevatedKey, string: parameter))
                } else if parameter.hasPrefix("\(Rhs.FluentUIColor.Props.darkElevatedHighContrastKey):") {
                    darkElevatedHighContrast = try? valueFrom(escape(Rhs.FluentUIColor.Props.darkElevatedHighContrastKey, string: parameter))
                } else {
                    fatalError("Invalid FluentUIColor parameter: \(parameter)")
                }
            }
            
            assert(light != nil, "Light is a required parameter. Format: FluentUIColor(light: #EE4488)")
            
            return .fluentUIColor(fluentUIColor: Rhs.FluentUIColor(light: light!,
                                                                   lightHighContrast:lightHighContrast,
                                                                   lightElevated: lightElevated,
                                                                   lightElevatedHighContrast: lightElevatedHighContrast,
                                                                   dark: dark,
                                                                   darkHighContrast: darkHighContrast,
                                                                   darkElevated: darkElevated,
                                                                   darkElevatedHighContrast: darkElevatedHighContrast))
            
        } else if let components = argumentsFromString("namedColor", string: string) {
            assert(components.count == 1, "Not a valid named color. Format: NamedColor(AssetCatalogColorName)")
            return .namedColor(namedColor: Rhs.NamedColor(name: (components[0])))
            
        } else if let components = argumentsFromString("color", string: string) {
            assert(components.count == 1, "Not a valid color. Format: \"#rrggbb\" or \"#rrggbbaa\"")
            return .color(color: Rhs.Color(rgba: "#\(components[0])"))
            
        } else if let components = argumentsFromString("image", string: string) {
            assert(components.count == 1, "Not a valid redirect. Format: Image(\"ImageName\")")
            return .image(image: components[0])
            
        } else if let components = argumentsFromString("redirect", string: string) {
            let error = "Not a valid redirect. Format $Style.Property"
            assert(components.count == 1, error)
            return .redirect(redirection: RhsRedirectValue(redirection: components[0], type: "Any"))
            
        } else if let components = argumentsFromString("point", string: string) {
            assert(components.count == 2, "Not a valid point. Format: Point(x, y)")
            let x = parseNumber(components[0])
            let y = parseNumber(components[1])
            return .point(x: x, y: y)
            
        } else if let components = argumentsFromString("size", string: string) {
            assert(components.count == 2, "Not a valid size. Format: Size(width, height)")
            let w = parseNumber(components[0])
            let h = parseNumber(components[1])
            return .size(width: w, height: h)
            
        } else if let components = argumentsFromString("rect", string: string) {
            assert(components.count == 4, "Not a valid rect. Format: Rect(x, y, width, height)")
            let x = parseNumber(components[0])
            let y = parseNumber(components[1])
            let w = parseNumber(components[2])
            let h = parseNumber(components[3])
            return .rect(x: x, y: y, width: w, height: h)
            
        } else if let components = argumentsFromString("edgeInsets", string: string) {
            assert(components.count == 4, "Not a valid edge inset. Format: EdgeInset(top, left, bottom, right)")
            let top = parseNumber(components[0])
            let left = parseNumber(components[1])
            let bottom = parseNumber(components[2])
            let right = parseNumber(components[3])
            return .edgeInset(top: top, left: left, bottom: bottom, right: right)
            
        } else if let components = argumentsFromString("insets", string: string) {
            assert(components.count == 4, "Not a valid edge inset. Format: EdgeInset(top, left, bottom, right)")
            let top = parseNumber(components[0])
            let left = parseNumber(components[1])
            let bottom = parseNumber(components[2])
            let right = parseNumber(components[3])
            return .edgeInset(top: top, left: left, bottom: bottom, right: right)
            
        } else if let components = argumentsFromString("repeatCount", string: string) {
            assert(components.count == 1, "Not a repeatCount. Format: repeatCount: N|infinite")
            return .repeatCount(count: components.first!)
            
        } else if let components = argumentsFromString("timingFunction", string: string) {
            assert(components.count == 4 || components.count == 1, "Not a valid timing function. Format: TimingFunction(c1, c2, c3, c4) or TimingFunction(easeIn)")
            if components.count == 4 {
                let c1 = parseNumber(components[0])
                let c2 = parseNumber(components[1])
                let c3 = parseNumber(components[2])
                let c4 = parseNumber(components[3])
                return .timingFunction(function: Rhs.TimingFunction(c1: c1, c2: c2, c3: c3, c4: c4))
            } else {
                return .timingFunction(function: Rhs.TimingFunction(name: components[0]))
            }
            
        } else if let components = argumentsFromString(Rhs.AnimationValue.Props.animationValueKey, string: string) {
            assert(components.count == 2 || components.count == 3)
            var type: String?
            var from: RhsValue?
            var to: RhsValue?
            
            for component in components {
                if component.hasPrefix(Rhs.AnimationValue.Props.typeKey) {
                    type = escape(Rhs.AnimationValue.Props.typeKey, string: component)
                } else if component.hasPrefix(Rhs.AnimationValue.Props.fromKey) {
                    from = valueFrom(parseNumber(escape(Rhs.AnimationValue.Props.fromKey, string: component)))
                } else if component.hasPrefix(Rhs.AnimationValue.Props.toKey) {
                    to = valueFrom(parseNumber(escape(Rhs.AnimationValue.Props.toKey, string: component)))
                }
            }
            return .keyFrameValue(value: Rhs.AnimationValue(type: type!, from: from, to: to!))
            
        } else if let components = argumentsFromString(Rhs.KeyFrame.Props.keyFrameKey, string: string) {
            var relativeStartTime: Float?
            var relativeDuration: Float?
            var values: RhsValue?
            
            for var component in components {
                component = component.trimmingCharacters(in: CharacterSet.whitespaces)
                if component.hasPrefix(Rhs.KeyFrame.Props.relativeStartTimeKey) {
                    relativeStartTime = parseNumber(component.replacingOccurrences(of: "\(Rhs.KeyFrame.Props.relativeStartTimeKey): ", with: ""))
                } else if component.hasPrefix(Rhs.KeyFrame.Props.relativeDurationKey) {
                    relativeDuration = parseNumber(component.replacingOccurrences(of: "\(Rhs.KeyFrame.Props.relativeDurationKey): ", with: ""))
                } else if component.hasPrefix(Rhs.KeyFrame.Props.animationValuesKey) {
                    var function = components.filter({ !$0.hasPrefix(Rhs.KeyFrame.Props.relativeStartTimeKey) && !$0.hasPrefix(Rhs.KeyFrame.Props.relativeDurationKey) }).joined(separator: ",")
                    function = function.trimmingCharacters(in: CharacterSet.whitespaces)
                    function = function.replacingOccurrences(of: " ", with: "")
                    function = function.replacingOccurrences(of: "\(Rhs.KeyFrame.Props.animationValuesKey):", with: "")
                    function = function.replacingOccurrences(of: "\(Rhs.AnimationValue.Props.animationValueKey)", with: "\"\(Rhs.AnimationValue.Props.animationValueKey)")
                    function = function.replacingOccurrences(of: ")", with: ")\"")
                    if let yaml = try? Yaml.load(function), case let .array(a) = yaml {
                        values = try? valueFrom(a)
                    }
                }
            }
            return .keyFrame(keyFrame: Rhs.KeyFrame(relativeStartTime: relativeStartTime, relativeDuration: relativeDuration, values: values))
            
        } else if let components = argumentsFromString(Rhs.Key.enumDef.rawValue, string: string) {
            assert(components.count > 1, "Not a valid enumDef. Format: enumDef(Type, Value1, Value2)")
            
            let type = components.first!.trimmingCharacters(in: CharacterSet.whitespaces)
            var names = [String]()
            for i in 1..<components.count {
                names.append(components[i].trimmingCharacters(in: CharacterSet.whitespaces))
            }
            return .enumDef(type: type, names: names)
            
        } else if let components = argumentsFromString("enum", string: string) {
            assert(components.count == 1, "Not a valid enum. Format: enum(Type.Value)")
            let enumComponents = components.first!.components(separatedBy: ".")
            assert(enumComponents.count == 2 || enumComponents.count == 3, "An enum should be expressed in the form Type.Value")
            let type = enumComponents.count == 2 ? enumComponents[0] : "\(enumComponents[0]).\(enumComponents[1])"
            let name = enumComponents.count == 2 ? enumComponents[1] : enumComponents[2]
            return .enum(type: type, name: name)
            
        } else if let components = argumentsFromString("optionDef", string: string) {
            assert(components.count > 1, "Not a valid optionDef. Format: optionDef(Type, Value1, Value2)")
            
            let type = components.first!.trimmingCharacters(in: CharacterSet.whitespaces)
            var names = [String]()
            for i in 1..<components.count {
                names.append(components[i].trimmingCharacters(in: CharacterSet.whitespaces))
            }
            return .optionDef(type: type, names: names)
            
        } else if let components = argumentsFromString("option", string: string) {
            assert(components.count > 0, "Not a valid enum. Format: option(Type.Value1, Type.Value2)")
            
            let firstOptionComponents = components.first!.trimmingCharacters(in: CharacterSet.whitespaces).components(separatedBy: ".")
            assert(firstOptionComponents.count == 2 || firstOptionComponents.count == 3, "An option should be expressed in the form Type.Value")
            let type = firstOptionComponents.count == 2 ? firstOptionComponents[0] : "\(firstOptionComponents[0]).\(firstOptionComponents[1])"
            
            var names = [String]()
            components.forEach {
                names.append($0.trimmingCharacters(in: CharacterSet.whitespaces))
            }
            return .option(type: type, names: names)
            
        } else if let components = argumentsFromString("call", string: string) {
            assert(components.count == 2, "Not a valid enum. Format: enum(Type.Value)")
            let call = components[0].trimmingCharacters(in: CharacterSet.whitespaces)
            let type = components[1].trimmingCharacters(in: CharacterSet.whitespaces)
            return .call(call: call, type: type)
        }
        
        throw RhsError.malformedRhsValue(error: "Unable to parse rhs value, string:\(string)")
    }
    
    func returnValue() -> String {
        switch self {
        case .int(_): return "Int"
        case .float(_): return "CGFloat"
        case .boolean(_): return "Bool"
        case .font(font: let font): return font.isSymbolFont ? "String" : "UIFont"
        case .fluentUIColor(_): return "UIColor"
        case .namedColor(_): return "UIColor"
        case .color(_): return "UIColor"
        case .image(_): return "UIImage"
        case .enumDef(let type, _): return type
        case .enum(let type, _): return NamespaceEnums + "." + type
        case .optionDef(let type, _): return type
        case .option(let type, _): return NamespaceEnums + "." + type
        case .redirect(let r): return r.type
        case .point(_, _): return "CGPoint"
        case .size(_, _): return "CGSize"
        case .rect(_, _, _, _): return "CGRect"
        case .edgeInset(_, _, _, _): return "UIEdgeInsets"
        case .timingFunction(_): return "AnimationCurveType"
        case .keyFrame(_): return "KeyFrame"
        case .keyFrameValue(_): return "AnimationableProp"
        case .repeatCount(_): return "AnimationRepeatCount"
        case .hash(let hash): for (_, rhs) in hash { return rhs.returnValue() }
        case .call(_, let type): return type
        case .array(let values):
            guard let returnTypes = Optional(values.compactMap({ $0.returnValue() })), let first = returnTypes.first, returnTypes.filter({ $0 == first }).count == returnTypes.count else { return "[Any]" }
            return "[\(first)]"
        }
        return "Any"
    }
}

class RhsRedirectValue {
    fileprivate var redirection: String
    fileprivate var type: String
    init(redirection: String, type: String) {
        self.redirection = redirection
        self.type = type
    }
}


extension RhsValue: Generatable {
    
    func generate(_ isNested: Bool = false, includePrefix: Bool = true) -> String {
        let indentationNested = isNested ? "\t\t" : ""
        let indentation = "\n\(indentationNested)\t\t\t"
        let prefix = includePrefix ? (isGlobal ? "public " : "\(indentation)return ") : ""
        switch self {
        case .int(let int):
            return generateInt(prefix, int: int)
            
        case .float(let float):
            return generateFloat(prefix, float: float)
            
        case .boolean(let boolean):
            return generateBool(prefix, boolean: boolean)
            
        case .font(let font):
            return generateFont(prefix, font: font)
            
        case .fluentUIColor(let fluentUIColor):
            return generateFluentUIColor(prefix, fluentUIColor: fluentUIColor)
        
        case .namedColor(let namedColor):
            return generateNamedColor(prefix, namedColor: namedColor)
            
        case .color(let color):
            return generateColor(prefix, color: color)
            
        case .image(let image):
            return generateImage(prefix, image: image)
            
        case .redirect(let redirection):
            return generateRedirection(prefix, redirection: redirection)
            
        case .enumDef(let type, let names):
            let objcPrefix = Generator.Config.objcGeneration ? "@objc " : ""
            return generateEnumDef(objcPrefix + prefix, type: type, names: names)
            
        case .enum(let type, let name):
            return generateEnum(prefix, type: type, name: name)
            
        case .optionDef(let type, let names):
            return generateOptionDef(prefix, type: type, names: names)
            
        case .option(let type, let names):
            return generateOption(prefix, type: type, names: names)
                        
        case .point(let x, let y):
            return generatePoint(prefix, x: x, y: y)
            
        case .size(let w, let h):
            return generateSize(prefix, width: w, height: h)
            
        case .rect(let x, let y, let w, let h):
            return generateRect(prefix, x: x, y: y, width: w, height: h)
            
        case .edgeInset(let top, let left, let bottom, let right):
            return generateEdgeInset(prefix, top: top, left: left, bottom: bottom, right: right)
            
        case .timingFunction(let function):
            return generateTimingFunction(prefix, function: function)
            
        case .keyFrame(let keyFrame):
            return generateKeyFrame(prefix, keyFrame: keyFrame)
            
        case .keyFrameValue(let keyFrameValue):
            return generateKeyFrameValue(prefix, keyFrameValue: keyFrameValue)
            
        case .repeatCount(let count):
            return generateRepeatCount(prefix, count: count)
            
        case .call(let call, _):
            return generateCall(prefix, string: call)
            
        case .array(let values):
            return generateArray(prefix, values: values)
            
        case .hash(let hash):
            var string = ""
            
            let sortedConditions = hash.sorted(by: { $0.0.rawString.count < $1.0.rawString.count })
            sortedConditions.forEach { (condition, rhs) in
                if !condition.isDefault() {
                    string += "\(indentation)if \(condition.generate()) { \(rhs.generate())\(indentation)}"
                }
            }

            //default should be the last condition
            for (condition, rhs) in hash where condition.isDefault() {
                string += "\(indentation)\(rhs.generate())"
            }
            return string
        }
        
    }
    
    func generateInt(_ prefix: String, int: Int) -> String {
        return "\(prefix)Int(\(int))"
    }
    
    func generateFloat(_ prefix: String, float: Float) -> String {
        return "\(prefix)CGFloat(\(float))"
    }
    
    func generateBool(_ prefix: String, boolean: Bool) -> String {
        return "\(prefix)\(boolean)"
    }
    
    func generateFont(_ prefix: String, font: Rhs.Font) -> String {
        if font.isSymbolFont {
            return "\(prefix)\"\(font.fontName!)\""
        } else {
            let fontClass = "UIFont"
            
            let textStyle: String
            
            if let fontTextStyle = font.textStyle {
                textStyle = "\(NamespaceEnums)." + fontTextStyle
            } else if let systemTextStyle = font.systemTextStyle {
                textStyle = systemTextStyle
            } else {
                textStyle = "nil"
            }
            let fontName = font.fontName != nil && font.isSystemFont == false && font.isSystemPreferred == false ? "\"\(font.fontName!)\"" : "nil"
            let fontSize = font.fontSize != nil ? "\(font.fontSize!)" : "nil"
            let fontWeight = font.weight ?? "nil"
            let fontTraits = font.traits ?? "[]"
            let isScalable = font.isScalableFont || font.isSystemPreferred ? "true" : "false"
            
            return "\(prefix)\(fontClass).font(name: \(fontName), size: \(fontSize), textStyle: \(textStyle), weight: \(fontWeight), traits: \(fontTraits), traitCollection: traitCollection, isScalable: \(isScalable))"
        }
    }
    
    func generateFluentUIColor(_ prefix: String, fluentUIColor: Rhs.FluentUIColor) -> String {
        let colorClass = "UIColor"
        return
            "\(prefix)\(colorClass)"
                + "(light: \(fluentUIColor.light.generate(includePrefix: false)),"
                + " lightHighContrast: \(fluentUIColor.lightHighContrast?.generate(includePrefix: false) ?? "nil"),"
                + " lightElevated: \(fluentUIColor.lightElevated?.generate(includePrefix: false) ?? "nil"),"
                + " lightElevatedHighContrast: \(fluentUIColor.lightElevatedHighContrast?.generate(includePrefix: false) ?? "nil"),"
                + " dark: \(fluentUIColor.dark?.generate(includePrefix: false) ?? "nil"),"
                + " darkHighContrast: \(fluentUIColor.darkHighContrast?.generate(includePrefix: false) ?? "nil"),"
                + " darkElevated: \(fluentUIColor.darkElevated?.generate(includePrefix: false) ?? "nil"),"
                + " darkElevatedHighContrast: \(fluentUIColor.darkElevatedHighContrast?.generate(includePrefix: false) ?? "nil"))"
    }
    
    func generateNamedColor(_ prefix: String, namedColor: Rhs.NamedColor) -> String {
        let colorClass = "UIColor"
        return
            "\(prefix)\(colorClass)"
                + "(named: \"FluentColors/\(namedColor.colorName ?? "")\", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!"
    }
    
    func generateColor(_ prefix: String, color: Rhs.Color) -> String {
        let colorClass = "UIColor"
        return
            "\(prefix)\(colorClass)"
                + "(red: \(color.red), green: \(color.green), blue: \(color.blue), alpha: \(color.alpha))"
    }
    
    func generateTimingFunction(_ prefix: String, function: Rhs.TimingFunction) -> String {
        
        //control points font
        if let controlPoints = function.controlPoints {
            return "\(prefix).timingParameters(UICubicTimingParameters(controlPoint1: CGPoint(x: \(controlPoints.c1), y: \(controlPoints.c2)), controlPoint2: CGPoint(x: \(controlPoints.c3), y: \(controlPoints.c4))))"
        } else {
            return "\(prefix).native(\(function.name!))"
        }
    }
    
    func generateKeyFrame(_ prefix: String, keyFrame: Rhs.KeyFrame) -> String {
        let relativeStartTime = keyFrame.relativeStartTime ?? 0.0
        let relativeDuration: String = (keyFrame.relativeDuration ?? 0.0) > 0 ? "\(keyFrame.relativeDuration!)" : "nil"
        let values = keyFrame.values?.generate() ?? "nil"
        return "\(prefix)KeyFrame(relativeStartTime: \(relativeStartTime), relativeDuration: \(relativeDuration), values: \(values))"
    }
    
    func generateKeyFrameValue(_ prefix: String, keyFrameValue: Rhs.AnimationValue) -> String {
        return "\(prefix)\(keyFrameValue.enumType)"
    }
    
    func generateRepeatCount(_ prefix: String, count: String) -> String {
        return Int(count) != nil ? "\(prefix)AnimationRepeatCount.count(\(count))" : "\(prefix)AnimationRepeatCount.infinite"
    }
    
    func generateImage(_ prefix: String, image: String) -> String {
        let colorClass = "UImage"
        return "\(prefix)\(colorClass)(named: \"\(image)\")!"
    }
    
    func generateRedirection(_ prefix: String, redirection: RhsRedirectValue) -> String {
        return "\(prefix)\(redirection.redirection)Property(traitCollection)"
    }
    
    func generateEnumDef(_ prefix: String, type: String, names: [String]) -> String {
        let superType = Generator.Config.objcGeneration ? ": Int, Equatable" : ""
        var generate = "\(prefix)enum \(type)\(superType) {\n"
        if names.contains(EnumCaseNone) {
            let initialization = Generator.Config.objcGeneration ? " = -1" : ""
            generate += "\tcase none\(initialization)\n"
        }
        for (index, enumCase) in names.sorted().enumerated() where enumCase != EnumCaseNone {
            let initialization = index == 0 && Generator.Config.objcGeneration ? " = 0" : ""
            if enumCase == "default" {
                generate += "\tcase `\(enumCase)`\(initialization)\n"
            } else {
                generate += "\tcase \(enumCase)\(initialization)\n"
            }
        }
        generate += "}\n\n"
        return generate
    }
    
    func generateEnum(_ prefix: String, type: String, name: String) -> String {
        return "\(prefix)\(NamespaceEnums).\(type).\(name)"
    }
    
    func generateOptionDef(_ prefix: String, type: String, names: [String]) -> String {
        var generate = "\(prefix)struct \(type): OptionSet, Hashable {\n"
        generate += "\t\(prefix)let rawValue: Int\n"
        generate += "\t\(prefix)init(rawValue: Int) { self.rawValue = rawValue }\n\n"
        
        for (index, name) in names.enumerated() {
            if name.contains(":") {
                let components = name.split(separator: ":")
                generate += "\t\(prefix)static let \(components.first!): \(type) = [\n"
                let nestedNames = components.last!.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: "|")
                generate += "\t\t"
                nestedNames.forEach({ generate += ".\($0), " })
                generate.removeLast(2)
                generate += "\n\t]\n"
            } else {
                generate += "\t\(prefix)static let \(name) = \(type)(rawValue: 1 << \(String(index)))\n"
            }
        }
        generate += "}\n\n"
        return generate
    }
    
    func generateOption(_ prefix: String, type: String, names: [String]) -> String {
        var generate = "\(prefix)["
        for name in names {
            generate.append("\(NamespaceEnums).\(name), ")
        }
        generate.removeLast(2)
        generate.append("]")
        return generate
    }

    func generatePoint(_ prefix: String, x: Float, y: Float) -> String {
        return "\(prefix)CGPoint(x: \(x), y: \(y))"
    }
    
    func generateSize(_ prefix: String, width: Float, height: Float) -> String {
        return "\(prefix)CGSize(width: \(width), height: \(height))"
    }
    
    func generateRect(_ prefix: String, x: Float, y: Float, width: Float, height: Float) -> String {
        return "\(prefix)CGRect(x: \(x), y: \(y), width: \(width), height: \(height))"
    }
    
    func generateEdgeInset(_ prefix: String,
                           top: Float,
                           left: Float,
                           bottom: Float,
                           right: Float) -> String {
        return
            "\(prefix)UIEdgeInsets(top: \(top), left: \(left), "
                + "bottom: \(bottom), right: \(right))"
    }
    
    func generateCall(_ prefix: String, string: String) -> String {
        var redirection = string
        if let importStylesheetManager = Generator.Config.importStylesheetManagerName, string.hasPrefix("S") {
            redirection = redirection.replace(prefix: "S", with: "\(importStylesheetManager).S")
        }
        return "\(prefix)\(redirection)"
    }
    
    func generateArray(_ prefix: String, values: [RhsValue]) -> String {
        var string = prefix
        for (index, value) in values.enumerated() {
            if index == 0 {
                string.append("[")
            }
            string.append(value.generate().replacingOccurrences(of: "return ", with: ""))
            if index != values.count - 1 {
                string.append(", ")
            } else {
                string.append("]")
            }
        }
        return string
    }
}
