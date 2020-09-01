//
//  Generatable.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation
import Yaml

let IconicFontStyle = "IconicFontStyle"
private let IconicSymbolType = "IconicSymbol"
private let NamespaceEnums = "S"

public enum IconicWeight: String, CodingKey, CaseIterable {
    case light
    case regular
}

//MARK: Rhs

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
    
    /// An icon.
    case icon(name: String)
    
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
    
    fileprivate var isHash: Bool {
        switch self {
        case .hash: return true
        default: return false
        }
    }
    
    fileprivate var isGlobal: Bool {
        switch self {
        case .enumDef, .optionDef: return true
        default: return false
        }
    }
    
    fileprivate var isRedirect: Bool {
        switch self {
        case .redirect: return true
        default: return false
        }
    }
    
    fileprivate var redirection: String? {
        switch self {
        case .redirect(let r): return r.redirection
        default: return nil
        }
    }
    
    fileprivate func applyRedirection(_ redirectValue: RhsRedirectValue) -> RhsValue {
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
        
        if let string = Optional(string), string.hasSuffix("pt") || string.hasSuffix("dp") || string.hasSuffix("f") {
            return .float(float: parseNumber(string))
        } else if let components = argumentsFromString(Rhs.Key.font.rawValue, string: string) {
            if components.count == 1 {
                return .font(font: Rhs.Font(symbolName: components.first!))
            } else {
                assert(components.count == 2 || components.count == 3, "Not a valid font. Format: Font(\"FontName\", size)")
                let second = Float(parseNumber(components[1]))
                if second > 0 {
                    return .font(font: Rhs.Font(name: components[0], size: second))
                } else {
                    let traits = components.count == 3 ? escape("font", string: components[2]) : nil
                    return .font(font: Rhs.Font(name: components[0], style: escape("font", string: components[1]), traits: traits))
                }
            }
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
            
        } else if let components = argumentsFromString("icon", string: string) {
            assert(components.count == 1, "Not a valid icon. Format: Icon(value)")
            return .icon(name: components.first!)
            
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
        case .color(_): return "UIColor"
        case .image(_): return "UIImage"
        case .enumDef(let type, _): return type
        case .enum(let type, _): return NamespaceEnums + "." + type
        case .optionDef(let type, _): return type
        case .option(let type, _): return NamespaceEnums + "." + type
        case .icon(_): return IconicSymbolType
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

//MARK: Generator

extension RhsValue: Generatable {
    
    func generate(_ isNested: Bool = false) -> String {
        let indentationNested = isNested ? "\t\t" : ""
        let indentation = "\n\(indentationNested)\t\t\t"
        let prefix = isGlobal ? "public " : "\(indentation)return "
        switch self {
        case .int(let int):
            return generateInt(prefix, int: int)
            
        case .float(let float):
            return generateFloat(prefix, float: float)
            
        case .boolean(let boolean):
            return generateBool(prefix, boolean: boolean)
            
        case .font(let font):
            return generateFont(prefix, font: font)
            
        case .color(let color):
            return generateColor(prefix, color: color)
            
        case .image(let image):
            return generateImage(prefix, image: image)
            
        case .redirect(let redirection):
            return generateRedirection(prefix, redirection: redirection)
            
        case .enumDef(let type, let names):
            return generateEnumDef(prefix, type: type, names: names)
            
        case .enum(let type, let name):
            return generateEnum(prefix, type: type, name: name)
            
        case .optionDef(let type, let names):
            return generateOptionDef(prefix, type: type, names: names)
            
        case .option(let type, let names):
            return generateOption(prefix, type: type, names: names)
            
        case .icon(let name):
            return generateIcon(prefix, name: name)
            
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
            return "\(prefix)\"\(font.fontName)\""
        } else {
            let fontClass = "UIFont"
            
            if font.isScalableFont {
                var generated: String
                if font.isSystemPreferred {
                    generated = "\(prefix)\(fontClass).preferredFont(forTextStyle: \(font.style!), compatibleWith: traitCollection, scalable: true)"
                } else {
                    generated = "\(prefix)\(fontClass).scaledFont(name: \"\(font.fontName)\", textStyle: \(font.style!), traitCollection: traitCollection)"
                }
                if let traits = font.traits {
                    generated.append(".with(traits: \(traits))")
                }
                return generated
            } else {
                //system font
                if font.isSystemFont || font.isSystemBoldFont || font.isSystemItalicFont {
                    var function: String? = nil
                    if font.isSystemBoldFont {
                        function = "boldSystemFont"
                    } else if font.isSystemItalicFont {
                        function = "italicSystemFont"
                    } else if font.isSystemFont {
                        function = "systemFont"
                    }
                    let weight = font.hasWeight ? ", weight: \(font.weight!)" : ""
                    return "\(prefix)\(fontClass).\(function!)(ofSize: \(font.fontSize!)\(weight))"
                }
                
                //font with name
                return "\(prefix)\(fontClass)(name: \"\(font.fontName)\", size: \(font.fontSize!))!"
            }
        }
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
        var generate = "\(prefix)enum \(type) {\n"
        names.forEach({
            if $0 == "default" {
                generate += "\tcase `\($0)`\n"
            } else {
                generate += "\tcase \($0)\n"
            }
        })
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
    
    func generateIcon(_ prefix: String, name: String) -> String {
        return "\(prefix)\(IconicSymbolType).\(name)"
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

//MARK: Property

class Property {
    var style: Style?
    var rhs: RhsValue?
    let key: String
    var isOverride: Bool = false
    var isOverridable: Bool = false
    
    init(key: String, rhs: RhsValue?, style: Style?) {
        self.style = style
        self.rhs = rhs
        self.key = key.replacingOccurrences(of: ".", with: "_")
    }
}

extension Property: Determinism {
    func ensureDeterminism() -> Property {
        style = style?.ensureDeterminism()
        return self
    }
}

extension Property: Generatable {
    
    func generate(_ isNested: Bool = false) -> String {
        var generated = ""
        if let style = self.style {
            generated = style.generate(true)
        } else if let rhs = self.rhs, rhs.isGlobal == false {
            
            var method = ""
            let indentation = isNested ? "\t\t\t" : "\t\t"
            method += "\n\n\(indentation)//MARK: \(self.key) "
            
            if !isOverride {
                let visibility = isOverridable ? "public" : "fileprivate"
                method += "\n\(indentation)\(visibility) var _\(key): \(rhs.returnValue())?"
            }
            
            // Options.
            let screen = "UIScreen.main"
            let methodArgs = "_ traitCollection: UITraitCollection? = \(screen).traitCollection"
            let override = isOverride ? "override " : ""
            let visibility = isOverridable ? "open" : "public"
            
            method +=
            "\n\(indentation)\(override)\(visibility) func \(key)Property(\(methodArgs)) -> \(rhs.returnValue()) {"
            method += "\n\(indentation)\tif let override = _\(key) { return override }"
            method += "\(rhs.generate(isNested))"
            method += "\n\(indentation)\t}"
            
            if !isOverride {
                method += "\n\(indentation)public var \(key == "default" ? "`\(key)`" : key): \(rhs.returnValue()) {"
                method += "\n\(indentation)\tget { return self.\(key)Property() }" 
                method += "\n\(indentation)\tset { _\(key) = newValue }"
                method += "\n\(indentation)}"
            }
            generated = method
        }
        return generated
    }
}

//MARK: Style

class Style {
    var name: String
    var isExternalOverride = false
    var superclassName: String? = nil
    var properties: [Property]
    var isExtension = false
    var isAnimation = false
    var isOverridable = false
    var isApplicable = false
    var isNestedOverride = false
    var isNestedOverridable = false
    var nestedOverrideName: String?
    var nestedSuperclassName: String? = nil
    var nestedReturnClass: String? = nil
    var viewClass: String = "UIView"
    var isInjected = false
    var belongsToStylesheetName: String?
    var extendsStylesheetName: String?
    var nestedIn: String?
    
    init(name: String, properties: [Property]) {
        var styleName = name.trimmingCharacters(in: CharacterSet.whitespaces)
        
        // Check if this could generate an extension.
        let extensionPrefix = "__appearance_proxy"
        if styleName.contains(extensionPrefix) {
            styleName = styleName.replacingOccurrences(of: extensionPrefix, with: "")
            isExtension = true
        }
        let openPrefix = "__open"
        styleName = styleName.replacingOccurrences(of: openPrefix, with: "")
        isOverridable = true
        
        let protocolPrefix = "__style"
        if styleName.contains(protocolPrefix) {
            styleName = styleName.replacingOccurrences(of: protocolPrefix, with: "")
        }
        let applicableSelfPrefix = "for Self"
        if styleName.contains(applicableSelfPrefix) {
            styleName = styleName.replacingOccurrences(of: applicableSelfPrefix, with: "")
            isApplicable = true
        }
        // Trims spaces
        styleName = styleName.replacingOccurrences(of: " ", with: "")
        
        // Superclass defined.
        if let components = Optional(styleName.components(separatedBy: "for")), components.count == 2 {
            styleName = components[0].replacingOccurrences(of: " ", with: "")
            viewClass = components[1].replacingOccurrences(of: " ", with: "")
            isApplicable = true
        }
        
        // Superclass defined.
        if let components = Optional(styleName.components(separatedBy: "extends")), components.count == 2 {
            styleName = components[0].replacingOccurrences(of: " ", with: "")
            if Generator.Config.importStylesheetNames != nil && (components[1].hasPrefix("S.") || components[1].hasPrefix("Stardust.")) {
                let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil && Generator.Config.importFrameworks != nil
                let namespace = hasNamespace ? "\(Generator.Config.importFrameworks!)." : ""
                let prefix = components[1].hasPrefix("Stardust.") ? "Stardust" : "S"
                let extendedClass = components[1].replace(prefix: prefix, with: Generator.Config.importStylesheetNames!.first!)
                superclassName = "\(namespace)" + extendedClass.replacingOccurrences(of: " ", with: "")
                isExternalOverride = true
                for property in properties where property.style != nil {
                    property.style!.isExternalOverride = true
                }
            } else {
                superclassName = components[1].replacingOccurrences(of: " ", with: "")
            }
        }
        if isOverridable {
            properties.forEach({ $0.isOverridable = true })
        }
        
        self.name = styleName
        self.properties = properties
    }
}

extension Style: Determinism {
    func ensureDeterminism() -> Style {
        properties = properties.compactMap({ $0.ensureDeterminism() }).sorted(by: { $0.key < $1.key })
        return self
    }
}

extension Style: Generatable {
    
    public func generate(_ isNested: Bool = false) -> String {
        
        var indentation = isNested ? "\t\t" : "\t"
        if isAnimation {
            indentation.append("\t")
        }
        var wrapper = isNested ? "\n\n" + indentation : indentation
        if let nestedOverrideName = nestedOverrideName {
            wrapper += "//MARK: - \(nestedOverrideName)"
        } else {
            wrapper += "//MARK: - \(name)"
        }
        
        var superclass = Generator.Config.objcGeneration ? ": NSObject" : ""
        var nestedSuperclass = Generator.Config.objcGeneration ? ": NSObject" : ""
        var nestedReturn = ""
        
        var objcName: String = ""
        if let nestedOverrideName = nestedOverrideName {
            objcName = nestedOverrideName.replacingOccurrences(of: name, with: "") + name.firstUppercased
        } else if let nestedIn = nestedIn {
            objcName = nestedIn + name.firstUppercased
        } else  {
            objcName = name.firstUppercased
        }
        
        let objc = Generator.Config.objcGeneration ? "@objc(\(objcName)AppearanceProxy) @objcMembers " : ""
        if let s = superclassName { superclass = ": \(s)AppearanceProxy" }
        if let s = nestedSuperclassName { nestedSuperclass = ": \(s)AppearanceProxy" }
        if let s = nestedReturnClass { nestedReturn = ": \(s)AppearanceProxy" }
        let visibility = isOverridable ? "open" : "public"
        let staticModifier = isNested ? "" : " static"
        let variableVisibility = !isNested ? "public" : visibility
        let styleClass = isNestedOverride ? "\(nestedOverrideName!)AppearanceProxy" : "\(name)AppearanceProxy"
        let returnClass = styleClass
        
        if isNestedOverride || isNestedOverridable {
            let visibility = "open"
            let override = isNestedOverride ? "override " : ""
            let returnClass = isNestedOverride ? String(nestedReturn[nestedReturn.index(nestedReturn.startIndex, offsetBy: 2)...]) : returnClass
            
            if isNestedOverridable && !isNestedOverride {
                wrapper += "\n\(indentation)public var _\(name): \(styleClass)?"
            }
            let injectedProxy: String
            if isNested {
                injectedProxy = "proxy: mainProxy"
            } else if isExternalOverride || (isInjected && extendsStylesheetName != nil)  {
                let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil && Generator.Config.importFrameworks != nil
                let namespace = hasNamespace ? "\(Generator.Config.importFrameworks!)." : ""
                injectedProxy = "proxy: { return \(namespace)\(extendsStylesheetName!).shared() }"
            } else {
                injectedProxy = "proxy: { return \(belongsToStylesheetName!).shared() }"
            }
            
            wrapper +=
            "\n\(indentation)\(override)\(visibility) func \(name)Style() -> \(returnClass) {"
            wrapper += "\n\(indentation)\tif let override = _\(name) { return override }"
            wrapper += "\n\(indentation)\t\treturn \(styleClass)(\(injectedProxy))"
            wrapper += "\n\(indentation)\t}"
            
            if isNestedOverridable && !isNestedOverride {
                wrapper += "\n\(indentation)public var \(name): \(styleClass) {"
                wrapper += "\n\(indentation)\tget { return self.\(name)Style() }"
                wrapper += "\n\(indentation)\tset { _\(name) = newValue }"
                wrapper += "\n\(indentation)}"
            }
        } else {
            wrapper += "\n\(indentation)\(objc)\(variableVisibility)\(staticModifier) let \(name) = \(name)AppearanceProxy()"
        }
        let superclassDeclaration = isNestedOverride ? nestedSuperclass : superclass
        wrapper += "\n\(indentation)\(objc)\(visibility) class \(styleClass)\(superclassDeclaration) {"
        
        if superclassName == nil && !isNestedOverride && !isInjected {
            let baseStyleName = Generator.Stylesheets.filter({ $0.superclassName == nil }).first!
            wrapper += "\n\(indentation)\tpublic let mainProxy: () -> \(baseStyleName.name)"
            wrapper += "\n\(indentation)\tpublic init(proxy: @escaping () -> \(baseStyleName.name)) {"
            wrapper += "\n\(indentation)\t\tself.mainProxy = proxy"
            wrapper += "\n\(indentation)\t}"
        }
        for property in properties {
            wrapper += property.generate(isNested)
        }
        
        if isApplicable {
            wrapper += "\n\(indentation)\tpublic func apply(view: \(isExtension ? self.name : self.viewClass)) {"
            for property in properties {
                wrapper +=
                    "\n\(indentation)\t\tview.\(property.key.replacingOccurrences(of: "_", with: "."))"
                    + " = self.\(property.key)"
            }
            wrapper += "\n\(indentation)\t}\n"
        }
        wrapper += "\n\(indentation)}\n"
        return wrapper
    }
}

//MARK: Stylesheet

class Stylesheet {
    
    let name: String
    var styles: [Style]
    var animations: [Style]
    let superclassName: String?
    let animatorName: String?
    let hasSymbolFont: Bool
    
    init(name: String, styles: [Style], animations: [Style], superclassName: String? = nil, animatorName: String? = nil, hasSymbolFont: Bool = false) {
        self.name = name
        self.styles = styles
        self.animations = animations
        self.superclassName = superclassName
        self.animatorName = animatorName
        self.hasSymbolFont = hasSymbolFont
    }
    
    fileprivate func normalized(styles: [Style], isAnimator: Bool) -> [Style] {
        var normalizedStyles = styles
        //generate all the styles from the base class
        let baseStylesheet = Generator.Stylesheets.filter({ $0.name == superclassName }).first!
        let sourceArray = isAnimator ? baseStylesheet.animations : baseStylesheet.styles
        
        let baseStyles = sourceArray.filter({ style in
            !styles.contains(where: { $0.name == style.name })
        })
        
        var injectedStyles = [Style]()
        for baseStyle in baseStyles {
            var injectedProperties = [Property]()
            for property in baseStyle.properties.filter({ $0.style != nil }) where property.style != nil {
                let nestedStyle = Style(name: property.style!.name, properties: [])
                nestedStyle.belongsToStylesheetName = name
                nestedStyle.isInjected = true
                nestedStyle.properties = [Property]()
                
                if let importStylesheetNames = Generator.Config.importStylesheetNames, property.style!.isExternalOverride {
                    let index = Generator.Config.stylesheetNames.firstIndex { (stylesheetName) -> Bool in
                        let components = stylesheetName.components(separatedBy: ":")
                        if components.count == 2 {
                            return components.first! == name
                        } else {
                            return stylesheetName == name
                        }
                    }
                    if let index = index {
                        nestedStyle.extendsStylesheetName = importStylesheetNames[index]
                    }
                }
                
                let injectedProperty = Property(key: property.key, rhs: property.rhs, style: nestedStyle)
                injectedProperties.append(injectedProperty)
            }
            
            let injectedStyle = Style(name: baseStyle.name, properties: injectedProperties)
            injectedStyle.belongsToStylesheetName = name
            
            if let importStylesheetNames = Generator.Config.importStylesheetNames, baseStyle.isExternalOverride {
                let index = Generator.Config.stylesheetNames.firstIndex { (stylesheetName) -> Bool in
                    let components = stylesheetName.components(separatedBy: ":")
                    if components.count == 2 {
                        return components.first! == name
                    } else {
                        return stylesheetName == name
                    }
                }
                if let index = index {
                    injectedStyle.extendsStylesheetName = importStylesheetNames[index]
                }
            }
            injectedStyle.isInjected = true
            injectedStyles.append(injectedStyle)
        }
        normalizedStyles.append(contentsOf: injectedStyles)
        
        let nestedStyles = normalizedStyles.flatMap({ $0.properties }).compactMap({ $0.style })
        for style in sourceArray {
            for property in style.properties where property.style != nil {
                let nestedStyle = property.style!
                if !nestedStyles.contains(where: { $0.name == nestedStyle.name }) {
                    for normalizedStyle in normalizedStyles {
                        if normalizedStyle.name == style.name {
                            let injectedNestedStyle = Style(name: nestedStyle.name, properties: [])
                            injectedNestedStyle.belongsToStylesheetName = name
                            injectedNestedStyle.isInjected = true
                            let injectedProperty = Property(key: property.key, rhs: property.rhs, style: injectedNestedStyle)
                            var properties = normalizedStyle.properties
                            properties.append(injectedProperty)
                            normalizedStyle.properties = properties
                        }
                    }
                }
            }
        }
        return normalizedStyles
    }
    
    fileprivate func prepareGenerator() {
        
        if superclassName != nil {
            styles = normalized(styles: styles, isAnimator: false)
            animations = normalized(styles: animations, isAnimator: true)
        }
        
        [styles, animations].forEach { generatableArray in
            // Resolve the type for the redirected values.
            generatableArray.forEach({ resolveRedirection($0) })
            // Mark the overrides.
            generatableArray.forEach({ markOverrides($0, superclassName: $0.superclassName) })
            // Mark the overridables.
            let nestedStyles = generatableArray.flatMap{ $0.properties }.compactMap{ $0.style }
            let duplicates = Dictionary(grouping: nestedStyles, by: { $0.name })
                .filter { $1.count > 1 }
                .sorted { $0.1.count > $1.1.count }
                .flatMap { $0.value }
            for style in duplicates where !style.isNestedOverride {
                style.isNestedOverridable = true
            }
            
            if superclassName == nil {
                for style in generatableArray {
                    style.isNestedOverridable = true
                    style.properties.compactMap({ $0.style }).forEach({ $0.isNestedOverridable = true })
                    style.properties.compactMap({ $0.style }).flatMap({ $0.properties }).forEach({ $0.isOverridable = true })
                    style.properties.forEach({ $0.isOverridable = true })
                }
            }
        }
        
        _ = ensureDeterminism()
    }
    
    fileprivate func resolveRedirection(rhs: RhsValue) -> RhsValue? {
        if rhs.isRedirect == false { return nil }
        
        var redirection = rhs.redirection!
        let resolvedType = resolveRedirectedType(redirection)
        if let importedStylesheetManager = Generator.Config.importStylesheetManagerName, resolvedType.isExternalType {
            redirection = "\(importedStylesheetManager).S.\(redirection)"
        } else if !redirection.hasPrefix("mainProxy()") {
            redirection = "mainProxy().\(redirection)"
        }
        return rhs.applyRedirection(RhsRedirectValue(redirection: redirection, type: resolvedType.type))
    }
    
    fileprivate func resolveRedirection(_ style: Style) {
        for property in style.properties {
            if let rhs = property.rhs {
                if let redirect = resolveRedirection(rhs: rhs) {
                    property.rhs = redirect
                } else if case let .array(values) = rhs {
                    var newValues = [RhsValue]()
                    for value in values {
                        if let redirect = resolveRedirection(rhs: value) {
                            newValues.append(redirect)
                        } else {
                            newValues.append(value)
                        }
                    }
                    property.rhs = .array(values: newValues)
                } else if case let .hash(map) = rhs {
                    var newMap = [Condition: RhsValue]()
                    for (key, value) in map {
                        if let redirect = resolveRedirection(rhs: value) {
                            newMap[key] = redirect
                        } else {
                            newMap[key] = value
                        }
                    }
                    property.rhs = .hash(hash: newMap)
                }
            }
            
            if let nestedStyle = property.style {
                resolveRedirection(nestedStyle)
            }
        }
    }
    
    fileprivate func markOverridables(_ style: Style) {
        guard superclassName != nil else { return }
        
        if let _ = Generator.Stylesheets.filter({ $0.superclassName == nil }).flatMap({ style.isAnimation ? $0.animations : $0.styles }).filter({ $0.name == style.name }).first {
            style.isNestedOverridable = true
            style.properties.forEach({ $0.isOverridable = true })
        }
    }
    
    fileprivate func markOverrides(_ style: Style, superclassName: String?) {
        let searchInStyles = style.isAnimation == false
        let nestedSuperclassPrefix = searchInStyles ? "" : "\(animatorName!)AnimatorProxy."
        
        //check if the style is an override from a generic base stylesheet
        if let baseSuperclassName = self.superclassName, let baseStylesheet = Generator.Stylesheets.filter({ return $0.name == baseSuperclassName }).first {
            let stylesBase = searchInStyles ? baseStylesheet.styles : baseStylesheet.animations
            if let superStyle = stylesBase.filter({ return $0.name == style.name }).first {
                style.isNestedOverride = true
                style.nestedSuperclassName = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)"
                style.nestedReturnClass = style.nestedSuperclassName
                style.nestedOverrideName = "\(name)\(style.name)"
                
                for nestedStyle in style.properties.compactMap({ $0.style }) {
                    if let superNestedStyle = superStyle.properties.compactMap({ $0.style }).filter({ $0.name == nestedStyle.name }).first {
                        nestedStyle.isNestedOverride = true
                        let superNestedSuperclassName = superStyle.superclassName != nil && superNestedStyle.isNestedOverride ? superStyle.name : ""
                        if superStyle.isExternalOverride {
                            nestedStyle.nestedSuperclassName = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superStyle.extendsStylesheetName!)\(superNestedSuperclassName)\(superNestedStyle.name)"
                            nestedStyle.nestedReturnClass = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superNestedStyle.name)"

                        } else {
                            nestedStyle.nestedSuperclassName = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superNestedSuperclassName)\(superNestedStyle.name)"
                            nestedStyle.nestedReturnClass = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superNestedStyle.name)"

                        }
                        nestedStyle.nestedOverrideName = "\(name)\(superNestedStyle.name)\(style.name)"
                    }
                    markOverrides(nestedStyle, superclassName: nestedStyle.nestedSuperclassName)
                }
            }
        }
        
        for property in style.properties {
            if let nestedStyle = property.style {
                let (isOverride, superclassName, styleName) = styleIsOverride(nestedStyle, superStyle: style)
                if let styleName = styleName, let superclassName = superclassName, isOverride, !nestedStyle.isNestedOverride {
                    nestedStyle.isNestedOverride = isOverride
                    nestedStyle.nestedSuperclassName = nestedSuperclassPrefix+superclassName
                    nestedStyle.nestedReturnClass = nestedStyle.nestedSuperclassName
                    nestedStyle.nestedOverrideName = styleName
                }
                markOverrides(nestedStyle, superclassName: nestedStyle.nestedSuperclassName)
            }
            if style.isExternalOverride {
                property.isOverride = true
            } else {
                property.isOverride = propertyIsOverride(property.key, superclass: superclassName, nestedSuperclassName: style.nestedSuperclassName, isStyleProperty: searchInStyles)
            }
        }
    }
    
    fileprivate func styleIsOverride(_ style: Style, superStyle: Style) -> (isOverride: Bool, superclassName: String?, styleName: String?) {
        guard let _ = superStyle.superclassName else { return (false, nil, nil) }
        
        if superStyle.isExternalOverride {
            let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil && Generator.Config.importFrameworks != nil
            let namespace = hasNamespace ? "\(Generator.Config.importFrameworks!)." : ""
            return (true, "\(namespace)\(superStyle.superclassName!)AppearanceProxy.\(style.name)", "\(superStyle.extendsStylesheetName!)\(style.name)")
        }
        
        let stylesBase = style.isAnimation ? animations : styles
        
        let nestedStyles = stylesBase.flatMap{ $0.properties }.filter{
            guard let nestedStyle = $0.style, nestedStyle.name == style.name else { return false }
            return true
        };
        
        for st in stylesBase {
            for property in st.properties {
                if let nestedStyle = property.style, nestedStyle.name == style.name, st.name != superStyle.name && nestedStyles.count > 1 {
                    
                    if let superclassName = st.superclassName {
                        if st.extendsStylesheetName != nil && superclassName.components(separatedBy: ".").count > 1 {
                            return (true, "\(superclassName)AppearanceProxy.\(Generator.Config.importStylesheetNames!.first!)\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
                        } else {
                            return (true, "\(superclassName)AppearanceProxy.\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
                        }
                    } else if let superclassName = superStyle.superclassName, superclassName == st.name {
                        return (true, "\(superclassName)AppearanceProxy.\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
                    }
                }
            }
        }
        return (false, nil, nil)
    }
    
    // Determines if this property is an override or not.
    fileprivate func propertyIsOverride(_ property: String, superclass: String?, nestedSuperclassName: String?, isStyleProperty: Bool) -> Bool {
        
        if let nestedSuperclassName = nestedSuperclassName, let components = Optional(nestedSuperclassName.components(separatedBy: ".")), components.count > 1, let baseStylesheet = Generator.Stylesheets.filter({ $0.name == components.first }).first {
            let stylesBase = isStyleProperty ? baseStylesheet.styles : baseStylesheet.animations
            if components.count == 2 || (components.count == 3 && isStyleProperty == false) {
                if let _ = stylesBase.filter({ $0.name == components.last }).first?.properties.filter({ return $0.key == property }).first {
                    return true
                }
            } else {
                let style = components[1].replacingOccurrences(of: "AppearanceProxy", with: "")
                let nestedStyle = components[2].replacingOccurrences(of: "AppearanceProxy", with: "").replace(prefix: style, with: "")
                if let _ = stylesBase.filter({ $0.name == style }).first?.properties.compactMap({ $0.style }).filter({ $0.name == nestedStyle }).first?.properties.filter({ return $0.key == property }).first {
                    return true
                }
            }
        }
        guard let superclass = superclass else { return false }
        let stylesBase = isStyleProperty ? styles : animations
        guard let style = stylesBase.filter({ return $0.name == superclass }).first else {
            if let components = Optional(superclass.components(separatedBy: ".")), components.count == 2 {
                return true
            }
            return false
        }
        
        if let _ = style.properties.filter({ return $0.key == property }).first {
            return true
        } else {
            return propertyIsOverride(property, superclass: style.superclassName, nestedSuperclassName: style.nestedSuperclassName, isStyleProperty: isStyleProperty)
        }
    }
    
    // Recursively resolves the return type for this redirected property.
    fileprivate func resolveRedirectedType(_ redirection: String) -> (type: String, isExternalType: Bool) {
        
        var isExternalType = false
        var components = redirection.components(separatedBy: ".")
        if components.first!.hasPrefix("mainProxy()") {
            components.removeFirst()
        }
        if components.first! == Generator.Config.importStylesheetManagerName {
            //e.g. StylesheetManager.S.Color.white.normal
            components.removeFirst(2)
        }
        
        assert(components.count == 2 || components.count == 3, "Redirect \(redirection) invalid")
        
        var property: Property? = nil
        //first search in its own styles and animation
        //    let stylesBase = styles : animations
        let stylesBase = styles
        let style = stylesBase.filter({ return $0.name == components[0] }).first
        if style != nil {
            if components.count == 2, let prop = style!.properties.filter({ return $0.key == components[1] }).first {
                property = prop
            } else if components.count == 3, let nestedStyleProperty = style!.properties.filter({ return $0.style?.name == components[1] }).first?.style, let prop = nestedStyleProperty.properties.filter({ return $0.key == components[2] }).first {
                property = prop
            }
        }
        
        //search in basestylesheet
        if property == nil {
            let stylesheet = Generator.Stylesheets.filter({ $0.name == superclassName }).first
            //      let sourceStyles = inStyle ? stylesheet?.styles : stylesheet?.animations
            let sourceStyles = stylesheet?.styles
            
            if let style = sourceStyles?.filter({ return $0.name == components[0] }).first {
                if components.count == 2, let prop = style.properties.filter({ return $0.key == components[1] }).first {
                    property = prop
                } else if components.count == 3, let nestedStyleProperty = style.properties.filter({ return $0.style?.name == components[1] }).first?.style, let prop = nestedStyleProperty.properties.filter({ return $0.key == components[2] }).first {
                    property = prop
                }
            }
        }
        
        //search in the imported Stylesheet
        if let importedStylesheet = Generator.ImportedStylesheet, property == nil {
            let sourceStyles = importedStylesheet.styles
            
            if let style = sourceStyles.filter({ return $0.name == components[0] }).first {
                if components.count == 2, let prop = style.properties.filter({ return $0.key == components[1] }).first {
                    property = prop
                } else if components.count == 3, let nestedStyleProperty = style.properties.filter({ return $0.style?.name == components[1] }).first?.style, let prop = nestedStyleProperty.properties.filter({ return $0.key == components[2] }).first {
                    property = prop
                }
            }
            isExternalType = property != nil
        }
        
        if let rhs = property!.rhs, rhs.isRedirect {
            let resolvedType = resolveRedirectedType(property!.rhs!.redirection!)
            return (resolvedType.type, isExternalType && resolvedType.isExternalType)
        } else {
            return (property!.rhs!.returnValue(), isExternalType)
        }
    }
}

extension Stylesheet: Determinism {
    func ensureDeterminism() -> Stylesheet {
        styles = styles.compactMap({ $0.ensureDeterminism() }).sorted(by: { $0.name < $1.name })
        animations = animations.compactMap({ $0.ensureDeterminism() }).sorted(by: { $0.name < $1.name })
        return self
    }
}

extension Stylesheet: Generatable {
    
    public func generate(_ nested: Bool = false) -> String {
        prepareGenerator()
        
        var stylesheet = ""
        let objc = Generator.Config.objcGeneration ? "@objc(STR\(self.name)) @objcMembers " : ""
        var superclass = ": NSObject"
        let importDef = "UIKit"
        let isBaseStylesheet = superclassName == nil
        
        if let s = superclassName { superclass = ": \(s)" }
        
        stylesheet += "/// Autogenerated file\n"
        stylesheet += "\n// swiftlint:disable all\n"
        stylesheet += "import \(importDef)\n\n"
        if let namespace = Generator.Config.importFrameworks {
            stylesheet += "import \(namespace)\n\n"
        }
        
        if isBaseStylesheet {
            if Generator.Config.generateAppearanceProxyProtocol {
                stylesheet += generateAppExtensionApplicationHeader()
            }
            
            if Generator.Config.extensionsEnabled && Generator.Config.generateAppearanceProxyProtocol {
                stylesheet += generateExtensionsHeader()
            }
            if animatorName != nil {
                stylesheet += generateAnimatorHeader()
            }
        }
        stylesheet += generateStylesheetManager()
        stylesheet += generateGlobal()
        
        if let configNamespace = Generator.Config.namespace {
            if Generator.Config.objcGeneration && isBaseStylesheet {
                stylesheet += "@objc public enum \(configNamespace): Int {\n"
                stylesheet += "\tcase \(configNamespace.lowercased())\n"
            } else {
                let namespace = isBaseStylesheet ? "public enum \(configNamespace)" : "extension \(configNamespace)"
                stylesheet += "\(namespace) {\n\n"
            }
            
            if isBaseStylesheet == false {
                stylesheet += generateEnumTheme()
            }
        }
        
        stylesheet += "/// Entry point for the app stylesheet\n"
        stylesheet += "\(objc)public class \(self.name)\(superclass) {\n\n"
        
        let override = superclassName != nil ? "override " : ""
        stylesheet += "\tpublic \(override)class func shared() -> \(self.name) {\n"
        stylesheet += "\t\t struct __ { static let _sharedInstance = \(self.name)() }\n"
        stylesheet += "\t\treturn __._sharedInstance\n"
        stylesheet += "\t}\n"
        
        for style in styles {
            stylesheet += style.generate()
        }
        
        if animatorName != nil {
            stylesheet += generateAnimator()
            for animation in animations {
                stylesheet += animation.generate()
            }
            stylesheet += "\t\n\n}"
        }
        stylesheet += "\n}"
        
        if Generator.Config.namespace != nil {
            stylesheet += "\n}"
        }
        
        if Generator.Config.extensionsEnabled {
            stylesheet += generateExtensions()
        }
        if isBaseStylesheet && animatorName != nil {
            stylesheet += generateAnimatorExtension()
        }
        return stylesheet
    }
    
    func generateGlobal() -> String {
        if superclassName != nil { return "" }
        let isBaseStylesheet = Generator.Config.importStylesheetManagerName == nil && superclassName == nil
        
        var global = isBaseStylesheet ? "public struct \(NamespaceEnums) {\n\n" : "public extension \(NamespaceEnums) {\n\n"
        var enums = ""
        Generator.Stylesheets.forEach {
            $0.styles.flatMap({ $0.properties }).sorted(by: { $0.key < $1.key }).compactMap({ $0.rhs }).filter({ $0.isGlobal }).forEach({
                let toGenerate = $0.generate(false)
                if enums.contains(toGenerate) == false { enums += toGenerate }
            })
        }
        
        if isBaseStylesheet == false {
            enums = enums.replacingOccurrences(of: "public enum", with: "enum").replacingOccurrences(of: "public struct", with: "struct")
        }
        global += enums
        global += "}\n"
        return global
    }
    
    var theme: (cases: [String: String], enumCases: [String]) {
        var cases = [String: String]()
        var enumCases = [String]()
        for i in 0..<Generator.Config.stylesheetNames.count {
            var name = Generator.Config.stylesheetNames[i]
            var enumCase = name.firstLowercased
            
            if Generator.Stylesheets.first(where: { $0.name == name && $0.superclassName == nil }) != nil {
                continue
            }
            
            if name.contains("Style") && name.count > 5 {
                enumCase = name.replacingOccurrences(of: "Style", with: "")
                enumCase = enumCase.prefix(1).lowercased() + enumCase.dropFirst()
            }
            if let components = Optional(enumCase.components(separatedBy: ":")), components.count > 1 {
                enumCase = components.first!
                name = name.components(separatedBy: ":").first!
            }
            enumCases.append(enumCase)
            cases[name] = enumCase
        }
        return (cases,enumCases)
    }
    
    func generateEnumTheme() -> String {
        if Generator.Config.hasGeneratedThemeEnum { return "" }
        let isBaseStylesheet = superclassName == nil
        if isBaseStylesheet { return "" }
        Generator.Config.hasGeneratedThemeEnum = true
        let baseStyleName = Generator.Stylesheets.filter({ $0.superclassName == nil }).first!
        let cases = theme.cases.sorted { $0.1 < $1.1 }
        var theme = ""
        let prefix = Generator.Config.objcGeneration ? "@objc " : ""
        theme += "\(prefix)public enum Theme: Int {\n"
        cases.forEach({ theme += "\tcase \($1)\n" })
        theme += "\n"
        theme += "\tpublic var stylesheet: \(baseStyleName.name) {\n"
        theme += "\t\tswitch self {\n"
        cases.forEach({ theme += "\t\tcase .\($1): return \($0).shared()\n" })
        theme += "\t\t}\n"
        theme += "\t}\n"
        theme += "}\n\n"
        return theme
    }
    
    func generateStylesheetManager() -> String {
        let isBaseStylesheet = superclassName == nil
        if isBaseStylesheet == false && Generator.Config.hasGeneratedStylesheetManager { return "" }
        
        var header = ""
        let baseStyleName = Generator.Stylesheets.filter({ $0.superclassName == nil }).first!
        let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil
        let namespace = hasNamespace ? "\(Generator.Config.namespace!)." : ""
        
        if isBaseStylesheet {
            
            let themeProtocolName = "\(Generator.Config.stylesheetManagerName)Theming"
            //notification name
            if Generator.Config.importStylesheetManagerName == nil {
                header += "public extension Notification.Name {\n"
                header += "\tstatic let didChangeTheme = Notification.Name(\"stardust.stylesheet.theme\")\n"
                header += "}\n\n"
            }
            
            header += "protocol \(themeProtocolName) {\n"
            header += "\tstatic func currentTheme() -> \(namespace)\(baseStyleName.name)\n"
            header += "\tfunc themeInit()\n"
            header += "}\n\n"
            
            header += "extension \(themeProtocolName) {\n"
            header += "\tstatic func currentTheme() -> \(namespace)\(baseStyleName.name) {\n"
            header += "\t\treturn \(namespace)\(baseStyleName.name).shared()\n"
            header += "\t}\n"
            header += "\tfunc themeInit() {\n"
            header += "\t\t\n"
            header += "\t}\n"
            header += "}\n\n"
            
            let prefix = Generator.Config.objcGeneration ? "@objcMembers " : ""
            let prefixMethod = Generator.Config.objcGeneration ? "" : "@objc "
            let superclass = Generator.Config.objcGeneration ? "NSObject, " : ""
            header += "\(prefix)public class \(Generator.Config.stylesheetManagerName): \(superclass)\(themeProtocolName) {\n"
            header +=
            "\t\(prefixMethod)dynamic public class func stylesheet(_ stylesheet: \(namespace)\(baseStyleName.name)) -> \(namespace)\(baseStyleName.name) {\n"
            header += "\t\treturn currentTheme()\n"
            header += "\t}\n\n"
            header += "\tpublic static let `default` = \(Generator.Config.stylesheetManagerName)()\n"
            header += "\tpublic static var S: \(namespace)\(baseStyleName.name) {\n"
            header += "\t\treturn currentTheme()\n"
            header += "\t}\n\n"

            if Generator.Config.importStylesheetManagerName == nil {
                let override = Generator.Config.objcGeneration ? "override " : ""
                header += "\tprivate \(override)init() {\n"
                if Generator.Config.objcGeneration {
                    header += "\t\tsuper.init()\n"
                }
                header += "\t\tthemeInit()\n"
                header += "\t}\n"
            }
            header += "}\n\n"
            
        } else {
            Generator.Config.hasGeneratedStylesheetManager = true
            
            var baseEnumCase = baseStyleName.name.firstLowercased
            if baseStyleName.name.contains("Style") && name.count > 5 {
                baseEnumCase = baseStyleName.name.replacingOccurrences(of: "Style", with: "")
                baseEnumCase = baseEnumCase.prefix(1).lowercased() + baseEnumCase.dropFirst()
            }
            
            let theme = self.theme
            
            if Generator.Config.importStylesheetManagerName == nil {
                header += "fileprivate extension UserDefaults {\n"
                header += "\tsubscript<T>(key: String) -> T? {\n"
                header += "\t\tget { return value(forKey: key) as? T }\n"
                header += "\t\tset { set(newValue, forKey: key) }\n"
                header += "\t}\n\n"
                header += "\tsubscript<T: RawRepresentable>(key: String) -> T? {\n"
                header += "\t\tget {\n"
                header += "\t\t\tif let rawValue = value(forKey: key) as? T.RawValue {\n"
                header += "\t\t\t\treturn T(rawValue: rawValue)\n"
                header += "\t\t\t}\n"
                header += "\t\t\treturn nil\n"
                header += "\t\t}\n"
                header += "\t\tset { self[key] = newValue?.rawValue }\n"
                header += "\t}\n"
                header += "}\n\n"
            }
            
            if hasNamespace == false {
                header += generateEnumTheme()
            }
            
            if Generator.Config.importStylesheetManagerName == nil {
                header += "fileprivate var __ThemeHandle: UInt8 = 0\n\n"
            }
            header += "public extension \(Generator.Config.stylesheetManagerName) {\n"
            header += "\tstatic func currentTheme() -> \(namespace)\(baseStyleName.name) {\n"
            header += "\t\treturn \(Generator.Config.stylesheetManagerName).default.theme.stylesheet\n"
            header += "\t}\n\n"
            
            if Generator.Config.importStylesheetManagerName == nil {
                header += "\tprivate struct DefaultKeys {\n"
                header += "\t\tstatic let theme = \"stardust.theme\"\n"
                header += "\t}\n\n"
            }
            
            header += "\t var theme: \(namespace)Theme {\n"
            let firstEnumCase = theme.cases.values.sorted(by: { $0 < $1 }).first!
            if Generator.Config.importStylesheetManagerName == nil {
                header += "\t\tget {\n"
                header += "\t\t\tguard let proxy = objc_getAssociatedObject(self, &__ThemeHandle) as? Theme else { return .\(firstEnumCase) }\n"
                header += "\t\t\treturn proxy\n"
                header += "\t\t}\n"
                header += "\t\tset {\n"
                header += "\t\t\tobjc_setAssociatedObject(self, &__ThemeHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
                header += "\t\t\tNotificationCenter.default.post(name: .didChangeTheme, object: theme)\n"
                header += "\t\t\tUserDefaults.standard[DefaultKeys.theme] = theme\n"
                header += "\t\t}\n"
            } else {
                
                var importCases = [String: String]()
                let importNames = Array(Generator.Config.importStylesheetNames!.dropFirst())
                for i in 0..<importNames.count {
                    let name = importNames[i]
                    var enumCase = name.firstLowercased
                    if name.contains("Style") && name.count > 5 {
                        enumCase = name.replacingOccurrences(of: "Style", with: "")
                        enumCase = enumCase.prefix(1).lowercased() + enumCase.dropFirst()
                    }
                    if let components = Optional(enumCase.components(separatedBy: ":")), components.count > 1 {
                        enumCase = components.first!
                    }
                    importCases[theme.enumCases[i]] = enumCase
                }
                importCases = [String : String](uniqueKeysWithValues: importCases.sorted(by: { $0.0 < $1.0 }))
                header += "\t\tswitch \(Generator.Config.importStylesheetManagerName!).default.theme {\n"
                importCases.forEach({ header += "\t\tcase .\($1): return .\($0)\n" })
                header += "\t\t}\n"
            }
            header += "\t}\n\n"
            
            if Generator.Config.importStylesheetManagerName == nil {
                header += "\tfunc themeInit() {\n"
                header += "\t\tlet theme: Theme = UserDefaults.standard[DefaultKeys.theme] ?? .\(firstEnumCase)\n"
                header += "\t\tobjc_setAssociatedObject(self, &__ThemeHandle, theme, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
                header += "\t}\n"
            }
            header += "}\n\n"
        }
        
        
        return header
    }
    
    func generateAppExtensionApplicationHeader() -> String {
        var header = ""
        header += "public class Application {\n"
        header +=
        "\t@objc dynamic public class func preferredContentSizeCategory() -> UIContentSizeCategory {\n"
        header += "\t\treturn .large\n"
        header += "\t}\n"
        header += "}\n\n"
        return header
    }
    
    func generateRuntimeSwappableHeader() -> String {
        var header = ""
        header += "public class \(Generator.Config.stylesheetManagerName) {\n"
        header +=
        "\t@objc dynamic public class func stylesheet(_ stylesheet: \(name)) -> \(name) {\n"
        header += "\t\treturn stylesheet\n"
        header += "\t}\n"
        header += "}\n\n"
        return header
    }
    
    func generateExtensionsHeader() -> String {
        let visibility = "fileprivate"
        var header = ""
        header += "\(visibility) var __ApperanceProxyHandle: UInt8 = 0\n"
        header += "\(visibility) var __ThemeAwareHandle: UInt8 = 0\n"
        header += "\(visibility) var __ObservingDidChangeThemeHandle: UInt8 = 0\n\n"
        
        header += "/// Your view should conform to 'AppearaceProxyComponent'.\n"
        header += "public protocol AppearaceProxyComponent: class {\n"
        header += "\tassociatedtype ApperanceProxyType\n"
        header += "\tvar appearanceProxy: ApperanceProxyType { get }\n"
        header += "\tvar themeAware: Bool { get set }\n"
        header += "\tfunc didChangeAppearanceProxy()"
        header += "\n}\n\n"
        
        header += "public extension AppearaceProxyComponent {\n"
        header += "\tfunc initAppearanceProxy(themeAware: Bool = true) {\n"
        header += "\t\tself.themeAware = themeAware\n"
        header += "\t\tdidChangeAppearanceProxy()\n"
        header += "\t}\n"
        header += "}\n\n"
        
        header += "#if os(iOS)\n"
        header += "private let defaultSizes: [UIFont.TextStyle: CGFloat] = {\n"
        header += "\tvar sizes: [UIFont.TextStyle: CGFloat] = [.caption2: 11,\n"
        header += "\t.caption1: 12,\n"
        header += "\t.footnote: 13,\n"
        header += "\t.subheadline: 15,\n"
        header += "\t.callout: 16,\n"
        header += "\t.body: 17,\n"
        header += "\t.headline: 17,\n"
        header += "\t.title3: 20,\n"
        header += "\t.title2: 22,\n"
        header += "\t.title1: 28]\n"
        header += "\tif #available(iOS 11.0, *) {\n"
        header += "\t\tsizes[.largeTitle] = 34\n"
        header += "\t}\n"
        header += "\treturn sizes\n"
        header += "}()\n"
        header += "#elseif os(tvOS)\n"
        header += "private let defaultSizes: [UIFont.TextStyle: CGFloat] =\n"
        header += "\t[.caption2: 23,\n"
        header += "\t\t.caption1: 25,\n"
        header += "\t\t.footnote: 29,\n"
        header += "\t\t.subheadline: 29,\n"
        header += "\t\t.body: 29,\n"
        header += "\t\t.callout: 31,\n"
        header += "\t\t.headline: 38,\n"
        header += "\t\t.title3: 48,\n"
        header += "\t\t.title2: 57,\n"
        header += "\t\t.title1: 76]\n"
        header += "#elseif os(watchOS)\n"
        header += "private let defaultSizes: [UIFont.TextStyle: CGFloat] = {\n"
        header += "\tif #available(watchOS 5.0, *) {\n"
        header += "\t\tswitch WKInterfaceDevice.current().preferredContentSizeCategory {\n"
        header += "\t\tcase \"UICTContentSizeCategoryS\":\n"
        header += "\t\t\treturn [.footnote: 12,\n"
        header += "\t\t\t\t.caption2: 13,\n"
        header += "\t\t\t\t.caption1: 14,\n"
        header += "\t\t\t\t.body: 15,\n"
        header += "\t\t\t\t.headline: 15,\n"
        header += "\t\t\t\t.title3: 18,\n"
        header += "\t\t\t\t.title2: 26,\n"
        header += "\t\t\t\t.title1: 30,\n"
        header += "\t\t\t\t.largeTitle: 32]\n"
        header += "\t\tcase \"UICTContentSizeCategoryL\":\n"
        header += "\t\t\treturn [.footnote: 13,\n"
        header += "\t\t\t\t.caption2: 14,\n"
        header += "\t\t\t\t.caption1: 15,\n"
        header += "\t\t\t\t.body: 16,\n"
        header += "\t\t\t\t.headline: 16,\n"
        header += "\t\t\t\t.title3: 19,\n"
        header += "\t\t\t\t.title2: 27,\n"
        header += "\t\t\t\t.title1: 34,\n"
        header += "\t\t\t\t.largeTitle: 36]\n"
        header += "\t\tcase \"UICTContentSizeCategoryXL\":\n"
        header += "\t\t\treturn [.footnote: 14,\n"
        header += "\t\t\t\t.caption2: 15,\n"
        header += "\t\t\t\t.caption1: 16,\n"
        header += "\t\t\t\t.body: 17,\n"
        header += "\t\t\t\t.headline: 17,\n"
        header += "\t\t\t\t.title3: 20,\n"
        header += "\t\t\t\t.title2: 30,\n"
        header += "\t\t\t\t.title1: 38,\n"
        header += "\t\t\t\t.largeTitle: 40]\n"
        header += "\t\tdefault:\n"
        header += "\t\t\treturn [:]\n"
        header += "\t\t}\n"
        header += "\t} else {\n"
        header += "\t\t/// No `largeTitle` before watchOS 5\n"
        header += "\t\tswitch WKInterfaceDevice.current().preferredContentSizeCategory {\n"
        header += "\t\tcase \"UICTContentSizeCategoryS\":\n"
        header += "\t\t\treturn [.footnote: 12,\n"
        header += "\t\t\t\t\t.caption2: 13,\n"
        header += "\t\t\t\t\t.caption1: 14,\n"
        header += "\t\t\t\t\t.body: 15,\n"
        header += "\t\t\t\t\t.headline: 15,\n"
        header += "\t\t\t\t\t.title3: 18,\n"
        header += "\t\t\t\t\t.title2: 26,\n"
        header += "\t\t\t\t\t.title1: 30]\n"
        header += "\t\tcase \"UICTContentSizeCategoryL\":\n"
        header += "\t\t\treturn [.footnote: 13,\n"
        header += "\t\t\t\t\t.caption2: 14,\n"
        header += "\t\t\t\t\t.caption1: 15,\n"
        header += "\t\t\t\t\t.body: 16,\n"
        header += "\t\t\t\t\t.headline: 16,\n"
        header += "\t\t\t\t\t.title3: 19,\n"
        header += "\t\t\t\t\t.title2: 27,\n"
        header += "\t\t\t\t\t.title1: 34]\n"
        header += "\t\tdefault:\n"
        header += "\t\t\treturn [:]\n"
        header += "\t\t}\n"
        header += "\t}\n"
        header += "}()\n"
        header += "#endif\n"
        header += "\n"
        
        if hasSymbolFont {
            header += "public extension \(NamespaceEnums).\(IconicFontStyle) {\n"
            header += "\tvar name: String {\n"
            header += "\t\tswitch self {\n"
            let cases = IconicWeight.allCases.map({ $0.rawValue }).sorted()
            cases.forEach { enumCase in
                header += "\t\t\tcase .\(enumCase): return \(Generator.Config.stylesheetManagerName).S.__SymbolFont.\(enumCase)FontName\n"
            }
            header += "\t\t}\n"
            header += "\t}\n"
            header += "}\n"
            header += "\n"
        }
        
        header += "\(visibility) var __ScalableHandle: UInt8 = 0\n"
        header += "public extension UIFont {\n"
        
        if hasSymbolFont {
            header += "\tconvenience init?(style: \(NamespaceEnums).\(IconicFontStyle), size: CGFloat) {\n"
            header += "\t\tself.init(name: style.name, size: size)\n"
            header += "\t}\n\n"
        }
        
        header += "\tstatic func scaledFont(name: String, textStyle: UIFont.TextStyle, traitCollection: UITraitCollection? = nil) -> UIFont {\n"
        header += "\t\tif #available(iOS 11.0, *) {\n"
        header += "\t\t\tguard let defaultSize = defaultSizes[textStyle], let customFont = UIFont(name: name, size: defaultSize) else {\n"
        header += "\t\t\t\tfatalError(\"Failed to load the \\(name) font.\")\n"
        header += "\t\t\t}\n"
        header += "\t\t\treturn UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont, compatibleWith: traitCollection)\n"
        header += "\t\t} else {\n"
        header += "\t\t\tlet fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle, compatibleWith: traitCollection)\n"
        header += "\t\t\tguard let customFont = UIFont(name: name, size: fontDescriptor.pointSize) else {\n"
        header += "\t\t\t\tfatalError(\"Failed to load the \\(name) font.\")\n"
        header += "\t\t\t}\n"
        header += "\t\t\treturn customFont\n"
        header += "\t\t}\n"
        header += "\t}\n\n"
        
        header += "\tfunc with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {\n"
        header += "\t\tlet descriptor = fontDescriptor.withSymbolicTraits(traits)\n"
        header += "\t\treturn UIFont(descriptor: descriptor!, size: 0)\n"
        header += "\t}\n\n"
        
        header += "\tclass func preferredFont(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?, scalable: Bool) -> UIFont {\n"
        header += "\t\tlet font = UIFont.preferredFont(forTextStyle: style, compatibleWith: traitCollection)\n"
        header += "\t\tfont.isScalable = true\n"
        header += "\t\treturn font\n"
        header += "\t}\n\n"
        
        header += "\tconvenience init?(name: String, scalable: Bool) {\n"
        header += "\t\tself.init(name: name, size: 4)\n"
        header += "\t\tself.isScalable = scalable\n"
        header += "\t}\n\n"
        
        header += "\tvar isScalable: Bool {\n"
        header += "\t\tget { return objc_getAssociatedObject(self, &__ScalableHandle) as? Bool ?? false }\n"
        header += "\t\tset { objc_setAssociatedObject(self, &__ScalableHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }\n"
        header += "\t}\n\n"
        
        header += "}\n\n"
        
        return header
    }
    
    func generateAnimatorHeader() -> String {
        let visibility = "fileprivate"
        var header = ""
        header += "\(visibility) var __AnimatorProxyHandle: UInt8 = 0\n"
        header += "\(visibility) var __AnimatorRepeatCountHandle: UInt8 = 0\n"
        header += "\(visibility) var __AnimatorIdentifierHandle: UInt8 = 0\n\n"
        header += "/// Your view should conform to 'AnimatorProxyComponent'.\n"
        header += "public protocol AnimatorProxyComponent: class {\n"
        header += "\tassociatedtype AnimatorProxyType\n"
        header += "\tvar \(animatorName!.firstLowercased): AnimatorProxyType { get }\n"
        header += "\n}\n\n"
        
        if superclassName == nil {
            header += "\npublic struct KeyFrame {"
            header += "\n\tvar relativeStartTime: CGFloat"
            header += "\n\tvar relativeDuration: CGFloat?"
            header += "\n\tvar values: [AnimatableProp]"
            header += "\n}\n"
            
            header += "\npublic enum AnimationAction {"
            header += "\n\tcase start"
            header += "\n\tcase pause"
            header += "\n\tcase stop(withoutFinishing: Bool)"
            header += "\n\tcase fractionComplete(CGFloat)"
            header += "\n}\n"
            
            header += "\npublic struct AnimationConfigOptions {"
            header += "\n\tlet repeatCount: AnimationRepeatCount?"
            header += "\n\tlet delay: CGFloat?"
            header += "\n\tlet duration: TimeInterval?"
            header += "\n\tlet curve: AnimationCurveType?"
            header += "\n\tlet scrubsLinearly: Bool?\n"
            header += "\n\tpublic init(duration: TimeInterval? = nil, delay: CGFloat? = nil, repeatCount: AnimationRepeatCount? = nil, curve: AnimationCurveType? = nil, scrubsLinearly: Bool? = nil) {"
            header += "\n\t\tself.duration = duration"
            header += "\n\t\tself.delay = delay"
            header += "\n\t\tself.repeatCount = repeatCount"
            header += "\n\t\tself.curve = curve"
            header += "\n\t\tself.scrubsLinearly = scrubsLinearly"
            header += "\n\t}"
            header += "\n}\n"
            
            header += "\npublic enum AnimationRepeatCount {"
            header += "\n\tcase infinite"
            header += "\n\tcase count(Int)"
            header += "\n}\n"
            
            header += "\npublic enum AnimationCurveType {"
            header += "\n\tcase native(UIView.AnimationCurve)"
            header += "\n\tcase timingParameters(UITimingCurveProvider)"
            header += "\n}\n"
            
            header += "\npublic enum AnimationType {"
            animations.forEach { header += "\n\tcase \($0.name.firstLowercased)" }
            header += "\n}\n"
            
            header += "\npublic enum AnimatableProp: Equatable {"
            header += "\n\tcase opacity(from: CGFloat?, to: CGFloat)"
            header += "\n\tcase frame(from: CGRect?, to: CGRect)"
            header += "\n\tcase size(from: CGSize?, to: CGSize)"
            header += "\n\tcase width(from: CGFloat?, to: CGFloat)"
            header += "\n\tcase height(from: CGFloat?, to: CGFloat)"
            header += "\n\tcase left(from: CGFloat?, to: CGFloat)"
            header += "\n\tcase rotate(from: CGFloat?, to: CGFloat)"
            header += "\n}\n\n"
            
            header += "\npublic extension AnimatableProp {"
            header += "\n\tfunc applyFrom(to view: UIView) {"
            header += "\n\t\tswitch self {"
            header += "\n\t\tcase .opacity(let from, _):\tif let from = from { view.alpha = from }"
            header += "\n\t\tcase .frame(let from, _):\tif let from = from { view.frame = from }"
            header += "\n\t\tcase .size(let from, _):\tif let from = from { view.bounds.size = from }"
            header += "\n\t\tcase .width(let from, _):\tif let from = from { view.bounds.size.width = from }"
            header += "\n\t\tcase .height(let from, _):\tif let from = from { view.bounds.size.height = from }"
            header += "\n\t\tcase .left(let from, _):\tif let from = from { view.frame.origin.x = from }"
            header += "\n\t\tcase .rotate(let from, _):\tif let from = from { view.transform = view.transform.rotated(by: (from * .pi / 180.0)) }"
            header += "\n\t\t}"
            header += "\n\t}\n"
            
            header += "\n\tfunc applyTo(to view: UIView) {"
            header += "\n\t\tswitch self {"
            header += "\n\t\tcase .opacity(_, let to):\tview.alpha = to"
            header += "\n\t\tcase .frame(_, let to):\t\tview.frame = to"
            header += "\n\t\tcase .size(_, let to):\t\tview.bounds.size = to"
            header += "\n\t\tcase .width(_, let to):\t\tview.bounds.size.width = to"
            header += "\n\t\tcase .height(_, let to):\tview.bounds.size.height = to"
            header += "\n\t\tcase .left(_, let to):\t\tview.frame.origin.x = to"
            header += "\n\t\tcase .rotate(_, let to):\tview.transform = view.transform.rotated(by: (to * .pi / 180.0))"
            header += "\n\t\t}"
            header += "\n\t}\n"
            header += "\n}\n\n"
        }
        
        return header
    }
    
    func generateExtensions() -> String {
        var extensions = ""
        
        let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil
        let namespace = hasNamespace ? "\(Generator.Config.namespace!)." : ""
        
        for style in styles.filter({ $0.isExtension }) {
            
            if let superclassName = superclassName, let _ = Generator.Stylesheets.filter({ $0.name == superclassName }).first?.styles.filter({ $0.name == style.name }).first {
                continue
            }
            let stylesheetName = (style.isNestedOverride || style.isNestedOverridable) ? "\(Generator.Config.stylesheetManagerName).stylesheet(\(namespace)\(name).shared())" : name
            let visibility = "public"
            
            let extendedStylesInBaseStylesheet = styles.filter({ $0.superclassName == style.name }).sorted(by: { $0.name < $1.name })
            var extendedStylesInExtendedStylesheets = [String: [Style]]()
            for extendedStylesheet in Generator.Stylesheets.filter({ $0.superclassName == name }) {
                if let styles = Optional(extendedStylesheet.styles.filter({ $0.superclassName == style.name })), styles.count > 0 {
                    extendedStylesInExtendedStylesheets[extendedStylesheet.name] = styles
                }
            }
            var sortedStatements = [(key: String, value: [String])]()
            for extendedStyle in extendedStylesInBaseStylesheet {
                var conditions = [String]()
                conditions.append("proxy is \(namespace)\(name).\(extendedStyle.name)AppearanceProxy")
                sortedStatements.append((key: extendedStyle.name, value: conditions))
            }
            
            extensions += "\nextension \(style.name): AppearaceProxyComponent {\n\n"
            extensions +=
                "\t\(visibility) typealias ApperanceProxyType = "
                + "\(namespace)\(name).\(style.name)AppearanceProxy\n"
            extensions += "\t\(visibility) var appearanceProxy: ApperanceProxyType {\n"
            extensions += "\t\tget {\n"
            
            extensions += "\t\t\tif let proxy = objc_getAssociatedObject(self, &__ApperanceProxyHandle) as? ApperanceProxyType {\n"
            extensions += "\t\t\t\tif !themeAware { return proxy }\n\n"
            
            var index = 0
            for (key, value) in sortedStatements {
                let prefix = index == 0 ? "\t\t\t\tif " : " else if "
                let condition = value.joined(separator: " || ")
                extensions += "\(prefix)\(condition) {\n"
                extensions += "\t\t\t\t\treturn \(stylesheetName).\(key)\n\t\t\t\t}"
                index += 1
            }
            
            extensions += "\n\t\t\t\treturn proxy\n"
            extensions += "\t\t\t}\n\n"
            extensions += "\t\t\treturn \(stylesheetName).\(style.name)\n"
            
            extensions += "\t\t}\n"
            extensions += "\t\tset {\n"
            extensions +=
                "\t\t\tobjc_setAssociatedObject(self, &__ApperanceProxyHandle, newValue,"
                + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
            extensions += "\t\t\tdidChangeAppearanceProxy()\n"
            extensions += "\t\t}\n"
            extensions += "\t}\n"
            
            extensions += "\n\t\(visibility) var themeAware: Bool {\n"
            extensions += "\t\tget {\n"
            extensions +=
                "\t\t\tguard let proxy = objc_getAssociatedObject(self, &__ThemeAwareHandle) "
                + "as? Bool else { return true }\n"
            extensions += "\t\t\treturn proxy\n"
            extensions += "\t\t}\n"
            extensions += "\t\tset {\n"
            extensions +=
                "\t\t\tobjc_setAssociatedObject(self, &__ThemeAwareHandle, newValue,"
                + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
            extensions += "\t\t\tisObservingDidChangeTheme = newValue\n"
            extensions += "\t\t}\n"
            extensions += "\t}\n\n"
            
            extensions += "\tfileprivate var isObservingDidChangeTheme: Bool {\n"
            extensions += "\t\tget {\n"
            extensions += "\t\t\tguard let observing = objc_getAssociatedObject(self, &__ObservingDidChangeThemeHandle) as? Bool else { return false }\n"
            extensions += "\t\t\treturn observing\n"
            extensions += "\t\t}\n"
            extensions += "\t\tset {\n"
            extensions += "\t\t\tif newValue == isObservingDidChangeTheme { return }\n"
            extensions += "\t\t\tif newValue {\n"
            extensions +=
                "\t\t\t\tNotificationCenter.default.addObserver(self, selector: #selector(didChangeAppearanceProxy),"
                + " name: Notification.Name.didChangeTheme, object: nil)\n"
            extensions += "\t\t\t} else {\n"
            extensions +=
                "\t\t\t\tNotificationCenter.default.removeObserver(self,"
                + " name: Notification.Name.didChangeTheme, object: nil)\n"
            extensions += "\t\t\t}\n"
            extensions +=
                "\t\t\tobjc_setAssociatedObject(self, &__ObservingDidChangeThemeHandle, newValue,"
                + " .OBJC_ASSOCIATION_RETAIN_NONATOMIC)\n"
            extensions += "\t\t}\n"
            extensions += "\t}\n"
            extensions += "}\n"
        }
        return extensions
    }
    
    func generateAnimatorExtension() -> String {
        let viewClass = "UIView"
        let visibility = "public"
        
        let shouldAccessInstance = superclassName == nil
        let stylesheetName = shouldAccessInstance ? "\(Generator.Config.stylesheetManagerName).stylesheet(\(name).shared())" : name
        var extensions = ""
        
        extensions += "\nextension UIViewPropertyAnimator {\n\n"
        extensions += "\t\(visibility) var repeatCount: AnimationRepeatCount? {\n"
        extensions += "\t\tget {\n"
        extensions += "\t\t\tguard let count = objc_getAssociatedObject(self, &__AnimatorRepeatCountHandle) as? AnimationRepeatCount else { return nil }\n"
        extensions += "\t\t\treturn count\n"
        extensions += "\t\t}\n"
        extensions += "\t\tset { objc_setAssociatedObject(self, &__AnimatorRepeatCountHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }\n"
        extensions += "\t}\n"
        extensions += "}\n"
        
        extensions += "\nextension \(viewClass): AnimatorProxyComponent {\n\n"
        
        extensions += "\t\(visibility) var \(animatorName!.firstLowercased)Identifier: String? {\n"
        extensions += "\t\tget {\n"
        extensions += "\t\t\tguard let identifier = objc_getAssociatedObject(self, &__AnimatorIdentifierHandle) as? String else { return nil }\n"
        extensions += "\t\t\treturn identifier\n"
        extensions += "\t\t}\n"
        extensions += "\t\tset { objc_setAssociatedObject(self, &__AnimatorIdentifierHandle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }\n"
        extensions += "\t}\n\n"
        
        extensions +=
            "\t\(visibility) typealias AnimatorProxyType = "
            + "\(name).\(animatorName!)AnimatorProxy\n"
        extensions += "\t\(visibility) var \(animatorName!.firstLowercased): AnimatorProxyType {\n"
        extensions += "\t\tget {\n"
        
        extensions +=
            "\t\t\tguard let a = objc_getAssociatedObject(self, &__AnimatorProxyHandle) "
            + "as? AnimatorProxyType else { return \(stylesheetName).\(animatorName!) }\n"
        extensions += "\t\t\treturn a\n"
        
        extensions += "\t\t}\n"
        extensions += "\t\tset { objc_setAssociatedObject(self, &__AnimatorProxyHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }\n"
        extensions += "\t}\n\n"
        
        for animation in animations {
            extensions += "\t\(visibility) func \(animation.name.firstLowercased)(action: AnimationAction = .start, options: AnimationConfigOptions? = nil) {\n"
            extensions += "\t\tanimator.animate(view: self, type: .\(animation.name.firstLowercased), action: action, options: options)\n"
            extensions += "\t}\n\n"
        }
        extensions += "}\n"
        return extensions
    }
    
    func generateAnimator() -> String {
        let indentation = "\t"
        var wrapper = indentation
        wrapper += "//MARK: - \(animatorName!)"
        
        let baseStylesheetName = Generator.Stylesheets.filter({ $0.superclassName == nil }).first!.name
        let isOverridable = superclassName == nil
        let isOverride = (superclassName != nil && Generator.Stylesheets.filter { $0.name == superclassName }.count > 0)
        let name = animatorName!
        
        if !isOverride {
            wrapper += "\n\(indentation)public typealias AnimationCompletion = () -> Void\n"
            wrapper += "\n\(indentation)public final class AnimationContext: NSObject {"
            wrapper += "\n\(indentation)\tprivate(set) public var viewTag: String"
            wrapper += "\n\(indentation)\tprivate(set) public var type: AnimationType\n"
            wrapper += "\n\(indentation)\tpublic init(viewTag: String, type: AnimationType) {"
            wrapper += "\n\(indentation)\t\tself.viewTag = viewTag"
            wrapper += "\n\(indentation)\t\tself.type = type"
            wrapper += "\n\(indentation)\t}\n"
            wrapper += "\n\(indentation)\tpublic var completion: AnimationCompletion?\n"
            wrapper += "\n\(indentation)\tpublic func animation(of type: AnimationType) -> UIViewPropertyAnimator {"
            wrapper += "\n\(indentation)\t\treturn animations.last!"
            wrapper += "\n\(indentation)\t}\n"
            wrapper += "\n\(indentation)\tpublic func add(_ animator: UIViewPropertyAnimator) {"
            wrapper += "\n\(indentation)\t\tanimator.addCompletion { [weak self] _ in"
            wrapper += "\n\(indentation)\t\t\tguard let `self` = self else { return }"
            wrapper += "\n\(indentation)\t\t\tself.remove(animator)"
            wrapper += "\n\(indentation)\t\t\tif self.animations.count == 0 {"
            wrapper += "\n\(indentation)\t\t\t\tAnimatorContext.animatorContexts.removeAll(where: { $0 == self })"
            wrapper += "\n\(indentation)\t\t\t}"
            wrapper += "\n\(indentation)\t\t}"
            wrapper += "\n\(indentation)\t\tanimations.append(animator)"
            wrapper += "\n\(indentation)\t}\n"
            wrapper += "\n\(indentation)\tpublic func remove(_ animator: UIViewPropertyAnimator) {"
            wrapper += "\n\(indentation)\t\tanimations.removeAll(where: { $0 == animator })"
            wrapper += "\n\(indentation)\t}\n"
            wrapper += "\n\(indentation)\tprivate var allAnimationsFinished: Bool = true"
            wrapper += "\n\(indentation)\tprivate var animations = [UIViewPropertyAnimator]()"
            wrapper += "\n\(indentation)\tprivate var lastAnimationStarted: Date?"
            wrapper += "\n\(indentation)\tprivate var lastAnimationAborted: Date?\n"
            wrapper += "\n\(indentation)\tstruct Keys {"
            wrapper += "\n\(indentation)\t\tstatic let animationContextUUID = \"UUID\""
            wrapper += "\n\(indentation)\t}"
            wrapper += "\n\(indentation)}\n"
            
            wrapper += "\n\(indentation)\tpublic struct AnimatorContext {"
            wrapper += "\n\(indentation)\t\tstatic var animatorContexts = [AnimationContext]()"
            wrapper += "\n\(indentation)\t}"
            wrapper += "\n\n"
        }
        
        let visibility = isOverridable ? "open" : "public"
        let staticModifier = " static"
        let variableVisibility = "public"
        let styleClass = isOverride ? "\(self.name)\(name)AnimatorProxy" : "\(name)AnimatorProxy"
        
        if isOverride || isOverridable {
            let visibility = isOverridable ? "open" : "public"
            let override = isOverride ? "override " : ""
            let returnClass = isOverride ? "\(baseStylesheetName).\(name)AnimatorProxy" : styleClass
            
            if isOverridable && !isOverride {
                wrapper += "\n\(indentation)public var _\(name): \(styleClass)?"
            }
            
            wrapper +=
            "\n\(indentation)\(override)\(visibility) func \(name)Animator() -> \(returnClass) {"
            wrapper += "\n\(indentation)\tif let override = _\(name) { return override }"
            wrapper += "\n\(indentation)\t\treturn \(styleClass)()"
            wrapper += "\n\(indentation)\t}"
            
            if isOverridable && !isOverride {
                wrapper += "\n\(indentation)public var \(name): \(styleClass) {"
                wrapper += "\n\(indentation)\tget { return self.\(name)Animator() }"
                wrapper += "\n\(indentation)\tset { _\(name) = newValue }"
                wrapper += "\n\(indentation)}"
            }
        } else {
            wrapper += "\n\(indentation)\(variableVisibility)\(staticModifier) let \(name) = \(name)AnimatorProxy()"
        }
        let superclassDeclaration = isOverride ? ": \(baseStylesheetName).\(name)AnimatorProxy" : ""
        wrapper += "\n\(indentation)\(visibility) class \(styleClass)\(superclassDeclaration) {"
        
        if isOverridable {
            wrapper += "\n\(indentation)\tpublic init() {}"
        }
        
        if !isOverride {
            let properties = animations.flatMap({ $0.properties })
            let durationProperty = properties.filter({ $0.key == "duration" }).first!
            let curveProperty = properties.filter({ $0.key == "curve" }).first!
            let repeatCountProperty = properties.filter({ $0.key == "repeatCount" }).first
            let delayProperty = properties.filter({ $0.key == "delay" }).first
            let keyFramesProperty = properties.filter({ $0.key == "keyFrames" }).first!
            
            var propertiesToGenerate = [durationProperty, curveProperty, keyFramesProperty]
            if let repeatCountProperty = repeatCountProperty {
                propertiesToGenerate.append(repeatCountProperty)
            }
            if let delayProperty = delayProperty {
                propertiesToGenerate.append(delayProperty)
            }
            
            for property in propertiesToGenerate {
                wrapper += "\n\(indentation)\t\(visibility) func \(property.key)Animation(of type: AnimationType, for view: UIView) -> \(property.rhs!.returnValue())? {"
                wrapper += "\n\(indentation)\t\tswitch type {"
                for animation in animations {
                    if animation.properties.contains(where: { $0.key == property.key }) {
                        let animationReference = animation.isOverridable || animation.isNestedOverridable ? "\(animation.name)Style()" : animation.name
                        wrapper += "\n\(indentation)\t\tcase .\(animation.name): return view.\(animatorName!.firstLowercased).\(animationReference).\(property.key)Property(view.traitCollection)"
                    } else {
                        wrapper += "\n\(indentation)\t\tcase .\(animation.name): return nil"
                    }
                }
                wrapper += "\n\(indentation)\t\t}"
                wrapper += "\n\(indentation)\t}\n"
            }
            
            let duration = "\(durationProperty.key)Animation(of: type, for: view)!"
            let curve = "\(curveProperty.key)Animation(of: type, for: view)!"
            var delay = "0.0"
            if let delayProperty = delayProperty {
                delay = "(\(delayProperty.key)Animation(of: type, for: view) ?? 0.0)"
            }
            var repeatCount = "nil"
            if let repeatCountProperty = repeatCountProperty {
                repeatCount = "\(repeatCountProperty.key)Animation(of: type, for: view)"
            }
            
            wrapper += "\n\(indentation)\t\(visibility) func animator(type: AnimationType, for view: UIView, options: AnimationConfigOptions?) -> UIViewPropertyAnimator {"
            wrapper += "\n\(indentation)\t\tlet duration = options?.duration ?? TimeInterval(\(duration))"
            wrapper += "\n\(indentation)\t\tlet curve = options?.curve ?? \(curve)"
            wrapper += "\n\(indentation)\t\tlet repeatCount = options?.repeatCount ?? \(repeatCount)"
            wrapper += "\n\(indentation)\t\tlet propertyAnimator: UIViewPropertyAnimator"
            wrapper += "\n\(indentation)\t\tswitch curve {"
            wrapper += "\n\(indentation)\t\t\tcase let .native(curve):"
            wrapper += "\n\(indentation)\t\t\t\tpropertyAnimator = UIViewPropertyAnimator(duration: duration, curve: curve)"
            wrapper += "\n\(indentation)\t\t\tcase let .timingParameters(curve):"
            wrapper += "\n\(indentation)\t\t\t\tpropertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: curve)"
            wrapper += "\n\(indentation)\t\t}"
            wrapper += "\n\(indentation)\t\tpropertyAnimator.repeatCount = repeatCount"
            wrapper += "\n\(indentation)\t\tif #available(iOS 11.0, *) {"
            wrapper += "\n\(indentation)\t\t\tpropertyAnimator.scrubsLinearly = options?.scrubsLinearly ?? true"
            wrapper += "\n\(indentation)\t\t}"
            wrapper += "\n\(indentation)\t\tpropertyAnimator.addAnimations({ [weak self] in"
            wrapper += "\n\(indentation)\t\t\tUIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {"
            wrapper += "\n\(indentation)\t\t\t\tguard let `self` = self else { return }"
            wrapper += "\n\(indentation)\t\t\t\tvar keyFrames = self.\(keyFramesProperty.key)Animation(of: type, for: view)!"
            wrapper += "\n\(indentation)\t\t\t\tlet onlyRotateValues: (AnimatableProp) -> Bool = { (value) in"
            wrapper += "\n\(indentation)\t\t\t\t\tswitch value {"
            wrapper += "\n\(indentation)\t\t\t\t\tcase let .rotate(_, to): return abs(to) > 180"
            wrapper += "\n\(indentation)\t\t\t\t\tdefault: return false"
            wrapper += "\n\(indentation)\t\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\tvar normalizedKeyFrames = [KeyFrame]()"
            wrapper += "\n\(indentation)\t\t\t\tfor var keyFrame in keyFrames {"
            wrapper += "\n\(indentation)\t\t\t\t\tkeyFrame.values.forEach({ (value) in"
            wrapper += "\n\(indentation)\t\t\t\t\t\tswitch value {"
            wrapper += "\n\(indentation)\t\t\t\t\t\tcase let .rotate(from, to):"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\tif abs(to) > 180 {"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t\tlet split = 3"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t\tlet relativeDuration = keyFrame.relativeDuration ?? 1.0"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t\tlet relativeStartTime = keyFrame.relativeStartTime"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t\tfor i in 0 ..< split {"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t\t\tlet normalizedStartTime = relativeStartTime + (CGFloat(i) / CGFloat(split)) * (relativeDuration - relativeStartTime)"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t\t\tnormalizedKeyFrames.append(KeyFrame(relativeStartTime: normalizedStartTime, relativeDuration: relativeDuration/CGFloat(split), values: [.rotate(from: from, to: to/CGFloat(split))]))"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\t\t\tdefault: return"
            wrapper += "\n\(indentation)\t\t\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\t\t})"
            wrapper += "\n\(indentation)\t\t\t\t\tkeyFrame.values = keyFrame.values.filter({ onlyRotateValues($0) == false })"
            wrapper += "\n\(indentation)\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\tkeyFrames = keyFrames + normalizedKeyFrames\n"
            wrapper += "\n\(indentation)\t\t\t\tfor keyFrame in keyFrames {"
            wrapper += "\n\(indentation)\t\t\t\t\tlet relativeStartTime = Double(keyFrame.relativeStartTime)"
            wrapper += "\n\(indentation)\t\t\t\t\tlet relativeDuration = Double(keyFrame.relativeDuration ?? 1.0)"
            wrapper += "\n\(indentation)\t\t\t\t\tkeyFrame.values.forEach({ $0.applyFrom(to: view) })"
            wrapper += "\n\(indentation)\t\t\t\t\tUIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration) {"
            wrapper += "\n\(indentation)\t\t\t\t\t\tkeyFrame.values.forEach({ $0.applyTo(to: view) })"
            wrapper += "\n\(indentation)\t\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t})"
            wrapper += "\n\(indentation)\t\t})"
            wrapper += "\n\(indentation)\t\tif let repeatCount = propertyAnimator.repeatCount, case let .count(count) = repeatCount, count == 0 { return propertyAnimator }"
            wrapper += "\n\(indentation)\t\tpropertyAnimator.addCompletion({ _ in"
            wrapper += "\n\(indentation)\t\t\tlet currentContext = AnimatorContext.animatorContexts.filter({ $0.type == type && $0.viewTag == view.\(animatorName!.firstLowercased)Identifier }).first\n"
            wrapper += "\n\(indentation)\t\t\tif let repeatCount = currentContext?.animation(of: type).repeatCount, view.superview != nil && view.window != nil {"
            wrapper += "\n\(indentation)\t\t\t\tlet nextAnimation = self.\(animatorName!.firstLowercased)(type: type, for: view, options: options)"
            wrapper += "\n\(indentation)\t\t\t\tif case let .count(count) = repeatCount {"
            wrapper += "\n\(indentation)\t\t\t\t\tlet nextCount = count - 1"
            wrapper += "\n\(indentation)\t\t\t\t\tnextAnimation.repeatCount = nextCount > 0 ? .count(nextCount) : nil"
            wrapper += "\n\(indentation)\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\tif let repeatCount = nextAnimation.repeatCount, case let .count(count) = repeatCount, count == 0 { return }"
            wrapper += "\n\(indentation)\t\t\t\tnextAnimation.startAnimation()"
            wrapper += "\n\(indentation)\t\t\t\tcurrentContext!.add(nextAnimation)"
            wrapper += "\n\(indentation)\t\t\t}"
            wrapper += "\n\(indentation)\t\t})"
            wrapper += "\n\(indentation)\t\treturn propertyAnimator"
            wrapper += "\n\(indentation)\t}\n"
            
            wrapper += "\n\(indentation)\t\(visibility) func animate(view: UIView, type: AnimationType, action: AnimationAction = .start, options: AnimationConfigOptions?) {"
            wrapper += "\n\(indentation)\t\tlet currentContext = AnimatorContext.animatorContexts.filter({ $0.type == type && $0.viewTag == view.\(animatorName!.firstLowercased)Identifier }).first\n"
            wrapper += "\n\(indentation)\t\tswitch action {"
            wrapper += "\n\(indentation)\t\tcase .start:"
            wrapper += "\n\(indentation)\t\t\tif let animator = currentContext?.animation(of: type) {"
            wrapper += "\n\(indentation)\t\t\t\tif animator.isRunning == false {"
            wrapper += "\n\(indentation)\t\t\t\t\tanimator.startAnimation()"
            wrapper += "\n\(indentation)\t\t\t\t}"
            wrapper += "\n\(indentation)\t\t\t\treturn"
            wrapper += "\n\(indentation)\t\t\t}"
            wrapper += "\n\(indentation)\t\t\tview.\(animatorName!.firstLowercased)Identifier = UUID().uuidString"
            wrapper += "\n\(indentation)\t\t\tlet context = AnimationContext(viewTag: view.\(animatorName!.firstLowercased)Identifier!, type: type)"
            wrapper += "\n\(indentation)\t\t\tlet animation = animator(type: type, for: view, options: options)"
            wrapper += "\n\(indentation)\t\t\tlet delay = options?.delay ?? \(delay)"
            wrapper += "\n\(indentation)\t\t\tanimation.startAnimation(afterDelay: TimeInterval(delay))"
            wrapper += "\n\(indentation)\t\t\tcontext.add(animation)"
            wrapper += "\n\(indentation)\t\t\tAnimatorContext.animatorContexts.append(context)"
            
            wrapper += "\n\(indentation)\t\tcase .pause:"
            wrapper += "\n\(indentation)\t\t\tvar animation = currentContext?.animation(of: type)"
            wrapper += "\n\(indentation)\t\t\tvar fractionComplete: CGFloat?"
            wrapper += "\n\(indentation)\t\t\tif animation != nil && (view.layer.animationKeys() == nil || view.layer.animationKeys()?.count == 0) {"
            wrapper += "\n\(indentation)\t\t\t\tcurrentContext?.remove(animation!)"
            wrapper += "\n\(indentation)\t\t\t\tfractionComplete = animation?.fractionComplete"
            wrapper += "\n\(indentation)\t\t\t\tanimation?.stopAnimation(false)"
            wrapper += "\n\(indentation)\t\t\t\tanimation?.finishAnimation(at: .end)"
            wrapper += "\n\(indentation)\t\t\t}"
            wrapper += "\n\(indentation)\t\t\tif let fractionComplete = fractionComplete {"
            wrapper += "\n\(indentation)\t\t\t\tview.animatorIdentifier = UUID().uuidString"
            wrapper += "\n\(indentation)\t\t\t\tlet context = AnimationContext(viewTag: view.animatorIdentifier!, type: type)"
            wrapper += "\n\(indentation)\t\t\t\tanimation = animator(type: type, for: view, options: options)"
            wrapper += "\n\(indentation)\t\t\t\tanimation!.fractionComplete = fractionComplete"
            wrapper += "\n\(indentation)\t\t\t\tcontext.add(animation!)"
            wrapper += "\n\(indentation)\t\t\t\tAnimatorContext.animatorContexts.append(context)"
            wrapper += "\n\(indentation)\t\t\t}"
            wrapper += "\n\(indentation)\t\t\tcurrentContext?.animation(of: type).pauseAnimation()"
            
            wrapper += "\n\(indentation)\t\tcase .fractionComplete(let fraction):"
            wrapper += "\n\(indentation)\t\t\tvar animation = currentContext?.animation(of: type)"
            wrapper += "\n\(indentation)\t\t\tvar shouldRecreate = false"
            wrapper += "\n\(indentation)\t\t\tif animation != nil && (view.layer.animationKeys() == nil || view.layer.animationKeys()?.count == 0) {"
            wrapper += "\n\(indentation)\t\t\t\tcurrentContext?.remove(animation!)"
            wrapper += "\n\(indentation)\t\t\t\tanimation?.stopAnimation(false)"
            wrapper += "\n\(indentation)\t\t\t\tanimation?.finishAnimation(at: .end)"
            wrapper += "\n\(indentation)\t\t\t\tshouldRecreate = true"
            wrapper += "\n\(indentation)\t\t\t}\n"
            wrapper += "\n\(indentation)\t\t\tif (fraction == 0 && animation == nil) || shouldRecreate {"
            wrapper += "\n\(indentation)\t\t\t\tview.animatorIdentifier = UUID().uuidString"
            wrapper += "\n\(indentation)\t\t\t\tlet context = AnimationContext(viewTag: view.animatorIdentifier!, type: type)"
            wrapper += "\n\(indentation)\t\t\t\tanimation = animator(type: type, for: view, options: options)"
            wrapper += "\n\(indentation)\t\t\t\tcontext.add(animation!)"
            wrapper += "\n\(indentation)\t\t\t\tAnimatorContext.animatorContexts.append(context)"
            wrapper += "\n\(indentation)\t\t\t}"
            wrapper += "\n\(indentation)\t\t\tif animation!.isRunning { animation?.pauseAnimation() }"
            wrapper += "\n\(indentation)\t\t\tif #available(iOS 11.0, *) {"
            wrapper += "\n\(indentation)\t\t\t\tanimation?.pausesOnCompletion = true"
            wrapper += "\n\(indentation)\t\t\t}"
            wrapper += "\n\(indentation)\t\t\tanimation?.fractionComplete = fraction"
            wrapper += "\n\(indentation)\t\tcase .stop(let withoutFinishing):"
            wrapper += "\n\(indentation)\t\t\tguard let animator = currentContext?.animation(of: type), animator.isRunning else { return }"
            wrapper += "\n\(indentation)\t\t\tanimator.stopAnimation(withoutFinishing)"
            wrapper += "\n\(indentation)\t\t}"
            wrapper += "\n\(indentation)\t}"
        }
        
        wrapper += "\n\n"
        return wrapper
    }
}

