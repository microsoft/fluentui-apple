//
//  Generator.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation
import Yaml

public enum GeneratorError: Error {
    case fileDoesNotExist(error: String)
    case malformedYaml(error: String)
    case illegalYamlScalarValue(error: String)
}

public protocol Generatable {
    func generate(_ isNested: Bool) -> String
    func generate() -> [String]
}

public protocol Determinism {
    associatedtype T: Generatable
    func ensureDeterminism() -> T
}

extension Generatable {
    public func generate(_ isNested: Bool) -> String {
        return ""
    }
    public func generate() -> [String] {
        return []
    }
}

public struct Generator: Generatable  {
    
    public struct Config {
        public static var namespace: String?
        public static var objcGeneration: Bool = false
        public static var extensionsEnabled: Bool = true
        public static var importFrameworks: String?
        public static var stylesheetNames: [String] = ["S"]
        public static var stylesheetManagerName: String = "StylesheetManager"
        public static var importStylesheetManagerName: String?
        public static var importStylesheetNames: [String]?
        public static var hasGeneratedStylesheetManager: Bool = false
        public static var hasGeneratedThemeEnum: Bool = false
        public static var generateAppearanceProxyProtocol: Bool = true
        public static var fontNames = [[IconicWeight: String]]()
    }
    
    static var Stylesheets = [Stylesheet]()
    static var ImportedStylesheet: Stylesheet?
    
    func initializeStylesheet(with url: URL, stylesheetName: String, extendsStylesheetName: String?, symbolFont: [IconicWeight: String]?) throws -> Stylesheet {
        
        // Attemps to load the file at the given url.
        var string = ""
        do {
            string = try String(contentsOf: url)
            string = string.replacingOccurrences(of: "AN_", with: "__animator ")
            string = string.replacingOccurrences(of: "@", with: "__")
            string = string.replacingOccurrences(of: "AP_", with: "__appearance_proxy")
        } catch {
            throw GeneratorError.fileDoesNotExist(error: "File \(url) not found.")
        }
        string = preprocessInput(string)
        guard let yaml = try? Yaml.load(string) else {
            throw GeneratorError.malformedYaml(error: "Unable to load Yaml file. \(string)")
        }
        // All of the styles define in the file.
        var styles = [Style]()
        if case .null = yaml {
            throw GeneratorError.malformedYaml(error: "Null root object.")
        }
        
        guard case let .dictionary(main) = yaml else {
            throw GeneratorError.malformedYaml(error: "The root object is not a dictionary.")
        }
        
        var name = stylesheetName
        var superclassName: String? = nil
        let components = name.components(separatedBy: ":")
        if components.count == 2 {
            name = components[0]
            superclassName = components[1]
        }
        
        //filter the styles from the animations
        let mainStyles = main.filter({ !($0.key.string?.hasPrefix("__animator") ?? false) })
        for (key, values) in mainStyles {
            guard let valuesDictionary = values.dictionary, let keyString = key.string else {
                throw GeneratorError.malformedYaml(error: "Malformed style definition: \(key).")
            }
            let properties = try createProperties(valuesDictionary)
            for property in properties where property.style != nil {
                property.style?.belongsToStylesheetName = name
            }
            let style = Style(name: keyString, properties: properties)
            style.belongsToStylesheetName = name
            if let extendsStylesheetName = extendsStylesheetName {
                style.extendsStylesheetName = extendsStylesheetName
            }
            for property in style.properties where property.style != nil {
                property.style?.nestedIn = style.name
            }
            
            styles.append(style)
        }
        var actualSymbolFont = symbolFont
        if actualSymbolFont == nil && Config.fontNames.filter({ $0.isEmpty == false }).count > 0 && superclassName == nil && extendsStylesheetName == nil {
            // the basestyle should have a font but the config doesn't mention it
            actualSymbolFont = [IconicWeight: String]()
            IconicWeight.allCases.forEach({ actualSymbolFont?[$0] = "-" })
        }
        
        if let actualSymbolFont = actualSymbolFont {
            var properties = [Property]()
            try actualSymbolFont.forEach { (key: IconicWeight, value: String) in
                let property = try self.property(with: "\(key.rawValue)FontName", yamlValue: Yaml.string("\(Rhs.Key.font.rawValue)(\(value))"))
                property.isOverridable = superclassName == nil
                property.isOverride = superclassName != nil
                properties.append(property)
                
                if superclassName == nil && extendsStylesheetName == nil {
                    var enumCases = ""
                    IconicWeight.allCases.forEach({ enumCases.append("\($0.rawValue),") })
                    enumCases.removeLast()
                    let property = try self.property(with: IconicFontStyle, yamlValue: Yaml.string("\(Rhs.Key.enumDef.rawValue)(\(IconicFontStyle),\(enumCases))"))
                    properties.append(property)
                }
            }
            let style = Style(name: "__SymbolFont", properties: properties)
            style.belongsToStylesheetName = name
            if let extendsStylesheetName = extendsStylesheetName {
                style.extendsStylesheetName = extendsStylesheetName
            }
            styles.append(style)
        }
        
        // All of the styles define in the file.
        var animations = [Style]()
        
        //filter the animations from the styles
        let animatorDict = main.filter({ $0.key.string?.hasPrefix("__animator") ?? false }).first
        let animatorName = animatorDict?.key.string?.replacingOccurrences(of: "__animator", with: "").trimmingCharacters(in: CharacterSet.whitespaces)
        if let animator = animatorDict?.value {
            guard case let .dictionary(mainAnimations) = animator else {
                throw GeneratorError.malformedYaml(error: "The root object is not a dictionary.")
            }
            for (key, values) in mainAnimations {
                guard let valuesDictionary = values.dictionary, let keyString = key.string else {
                    throw GeneratorError.malformedYaml(error: "Malformed animation definition: \(key). Animator: \(animator), animatorDict: \(String(describing: animatorDict)), mainStyles: \(mainStyles), yaml: \(yaml)")
                }
                let style = Style(name: keyString, properties: try createProperties(valuesDictionary))
                style.belongsToStylesheetName = name
                if let extendsStylesheetName = extendsStylesheetName {
                    style.extendsStylesheetName = extendsStylesheetName
                }
                style.isAnimation = true
                animations.append(style)
            }
        }
        return Stylesheet(name: name, styles: styles, animations: animations, superclassName: superclassName, animatorName: animatorName, hasSymbolFont: symbolFont != nil)
    }
    
    /// Initialise the Generator with some YAML payload.
    public init(urls: [URL], importedUrl: URL? = nil) throws {
    
        if let importedUrl = importedUrl {
            let stylesheet = try initializeStylesheet(with: importedUrl,
                                                      stylesheetName: NSString(string: importedUrl.lastPathComponent).deletingPathExtension,
                                                      extendsStylesheetName: nil,
                                                      symbolFont: nil)
            Generator.ImportedStylesheet = stylesheet
        }
        
        for i in 0..<urls.count {
            let url = urls[i]
            let symbolFont = Generator.Config.fontNames[i]
            let stylesheet = try initializeStylesheet(with: url,
                                                      stylesheetName: Generator.Config.stylesheetNames[i],
                                                      extendsStylesheetName: Generator.Config.importStylesheetNames != nil ? Generator.Config.importStylesheetNames![i] : nil, symbolFont: symbolFont.isEmpty ? nil : symbolFont)
            Generator.Stylesheets.append(stylesheet)
        }
    }
    
    /// Returns the swift code for this item.
    func generate(_ nested: Bool = false) -> [String] {
        var generatedStrings = [String]()
        for stylesheet in Generator.Stylesheets {
            generatedStrings.append(stylesheet.generate())
        }
        return generatedStrings
    }
    
    private func createProperties(_ dictionary: [Yaml: Yaml]) throws -> [Property] {
        var properties = [Property]()
        
        for (yamlKey, yamlValue) in dictionary {
            if let key = yamlKey.string {
                properties.append(try property(with: key, yamlValue: yamlValue))
            }
        }
        return properties
    }
    
    
    private func property(with key: String, yamlValue: Yaml) throws -> Property {
        do {
            var style: Style? = nil
            var rhsValue: RhsValue? = nil
            switch yamlValue {
            case .array(let array):
                
                let flattenedDictionary = array.map({ (value) -> [Yaml: Yaml]? in
                    return value.dictionary
                }).reduce([Yaml: Yaml](), { (dict, tuple) -> [Yaml: Yaml] in
                    var nextDict = dict
                    if let tuple = tuple {
                        for (key,value) in tuple {
                            nextDict.updateValue(value, forKey:key)
                        }
                    }
                    return nextDict
                })
                if flattenedDictionary.count > 0 {
                    style = Style(name: key, properties: try createProperties(flattenedDictionary))
                } else {
                    rhsValue = try RhsValue.valueFrom(array)
                }
            case .dictionary(let dictionary): rhsValue = try RhsValue.valueFrom(dictionary)
            case .bool(let boolean): rhsValue = RhsValue.valueFrom(boolean)
            case .int(let integer): rhsValue = RhsValue.valueFrom(integer)
            case .double(let double): rhsValue = RhsValue.valueFrom(Float(double))
            case .string(let string): rhsValue = try RhsValue.valueFrom(string)
            default:
                throw GeneratorError.illegalYamlScalarValue(
                    error: "\(yamlValue) not supported as right-hand side value")
            }
            let property = Property(key: key, rhs: rhsValue, style: style)
            return property
        } catch {
            throw GeneratorError.illegalYamlScalarValue(error: "\(yamlValue) is not parsable")
        }
    }
    
}
