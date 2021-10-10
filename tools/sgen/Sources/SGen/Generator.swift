//
//  Generator.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation
import Yaml
import PathKit

typealias AddtionalGenerating = (generatedCode: String?, styles: [Style]?)

protocol StyleGenerating {
    var url: URL { get }
    var additional: AddtionalGenerating? { get }
    var onAdditional: ((String) -> AddtionalGenerating?)? { get }
}

extension URL: StyleGenerating {
    var url: URL { return self }
    var additional: AddtionalGenerating? { return nil }
    var onAdditional: ((String) -> AddtionalGenerating?)? { return nil }
}

class StyleGenerable: StyleGenerating {
    let url: URL
    var additional: AddtionalGenerating?
    var onAdditional: ((String) -> AddtionalGenerating?)?
    
    init(url: URL, additional: AddtionalGenerating? = nil, onAdditional: ((String) -> AddtionalGenerating?)? = nil) {
        self.url = url
        self.additional = additional
        self.onAdditional = onAdditional
    }
}

enum GeneratorError: Error {
    case fileDoesNotExist(error: String)
    case malformedYaml(error: String)
    case illegalYamlScalarValue(error: String)
}

typealias Payload = (name: String, string: String, dependencyOfName: String?)

protocol StylesheetGeneratable {
    func generate() -> [Payload]
    
    func createProperties(_ dictionary: [Yaml: Yaml]) throws -> [Property]
    func property(with key: String, yamlValue: Yaml) throws -> Property
}

protocol Generatable {
    func generate(_ isNested: Bool, includePrefix: Bool) -> String
}

protocol Determinism {
    associatedtype T: Generatable
    func ensureDeterminism() -> T
}

struct Generator  {
    
    struct Config {
        static var namespace: String?
        static var objcGeneration: Bool = false
        static var extensionsEnabled: Bool = true
        static var importFrameworks: String?
        static var stylesheetNames: [String] = ["S"]
        static var stylesheetManagerName: String = StylesheetManagerName
        static var importStylesheetManagerName: String?
        static var importStylesheetNames: [String]?
        static var hasGeneratedStylesheetManager: Bool = false
        static var hasGeneratedThemeEnum: Bool = false
        static var generateAppearanceProxyProtocol: Bool = true
        static var generateFilePerAppearanceProxy: Bool = false
        static var symbolFontNames = [[IconicWeight: String]]()
        static var typographyTextStyles = [String: TypographyInfo]()
    }
    
    static var Stylesheets = [Stylesheet]()
    static var ImportedStylesheet: Stylesheet?
    
    func initializeStylesheet(with url: URL, stylesheetName: String, dependencyOf: String?, extendsStylesheetName: String?, symbolFont: [IconicWeight: String]?, typography: [String: TypographyInfo]?) throws -> Stylesheet {
        
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
        
        var dependencies = [Stylesheet]()
        var styles = [Style]()
        let mainStyles = main.filter({ !($0.key.string?.hasPrefix("__animator") ?? false) })
        // filter the dependencies and the styles from the animations
        for (key, values) in mainStyles {
            
            if key.string == StylesheetGrammar.import.rawValue, let valuesArray = values.array {
                // valuesArray contains the list of yml dependencies
                for styleNamePath in valuesArray.compactMap({ $0.string }) {
                    let currentPath = Path(url.path)
                    var currentComponents = currentPath.components.dropLast()
                    currentComponents.append(styleNamePath)
                    let additionalStylesheet = Path(components: currentComponents)
                    
                    do {
                        let stylesheet = try initializeStylesheet(with: additionalStylesheet.url, stylesheetName: NSString(string: styleNamePath).deletingPathExtension, dependencyOf: name, extendsStylesheetName: extendsStylesheetName, symbolFont: nil, typography: nil)
                        dependencies.append(stylesheet)
                    } catch {
                        throw GeneratorError.malformedYaml(error: "Unable to load additional stylesheet.")
                    }
                }
                continue
            }
            
            guard let valuesDictionary = values.dictionary, let keyString = key.string else {
                throw GeneratorError.malformedYaml(error: "Malformed style definition: \(key).")
            }
            do {
                var normalizedDependencyOf = dependencyOf
                if Config.generateFilePerAppearanceProxy && normalizedDependencyOf == nil {
                    normalizedDependencyOf = name
                }
                
                let style = try self.style(forValues: valuesDictionary, key: keyString, name: name, dependencyOf: normalizedDependencyOf, extendsStylesheetName: extendsStylesheetName)
                styles.append(style)
            } catch {
                throw GeneratorError.malformedYaml(error: "Unable to create the styles from the stylesheet")
            }
            
        }
        if Config.generateFilePerAppearanceProxy {
            var stylesToRemove = [Style]()
            styles.filter({ $0.isExtension }).forEach { style in
                // Include subclasses of the current appearance proxy
                var stylesheetStyles = styles.filter({ $0.superclassName == style.name })
                stylesheetStyles.append(style)
                stylesToRemove.append(contentsOf: stylesheetStyles)
                
                let stylesheet = Stylesheet(name: style.name, styles: stylesheetStyles, animations: [Style]())
                dependencies.append(stylesheet)
            }
            
            styles = styles.filter({ style in
                return !stylesToRemove.contains(where: { styleToBeRemoved in
                    return style.name == styleToBeRemoved.name
                })
            })
        }
        
        var actualSymbolFont = symbolFont
        if actualSymbolFont == nil && Config.symbolFontNames.filter({ $0.isEmpty == false }).count > 0 && superclassName == nil && extendsStylesheetName == nil {
            // the basestyle should have a font but the config doesn't mention it
            actualSymbolFont = [IconicWeight: String]()
            IconicWeight.allCases.forEach({ actualSymbolFont?[$0] = SymbolNamePlaceholder })
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
                    IconicWeight.allCases.sorted { $0.rawValue < $1.rawValue }.forEach({ enumCases.append("\($0.rawValue),") })
                    enumCases.removeLast()
                    let property = try self.property(with: IconicFontStyle, yamlValue: Yaml.string("\(Rhs.Key.enumDef.rawValue)(\(IconicFontStyle),\(enumCases))"))
                    properties.append(property)
                }
            }
            let style = Style(name: IconicFontSectionName, properties: properties)
            style.belongsToStylesheetName = name
            if let extendsStylesheetName = extendsStylesheetName {
                style.extendsStylesheetName = extendsStylesheetName
            }
            styles.append(style)
        }
        
        let hasTextStyle = typography != nil && superclassName == nil && extendsStylesheetName == nil
        if let typography = typography, hasTextStyle {
            //search for the typography section
            var enumCases = ""
            typography.keys.sorted().forEach { enumCases.append("\($0),") }
            enumCases.removeLast()
            let property = try self.property(with: FontTextStyle, yamlValue: Yaml.string("\(Rhs.Key.enumDef.rawValue)(\(FontTextStyle),\(enumCases))"))
            let properties = [property]
            let style = Style(name: FontTextStyleSectionName, properties: properties)
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
        return Stylesheet(
            name: name,
            styles: styles,
            animations: animations,
            dependencies: dependencies,
            superclassName: superclassName,
            animatorName: animatorName,
            hasSymbolFont: symbolFont != nil
        )
    }
    
    /// Initialise the Generator with some YAML payload.
    
    fileprivate let generatable: [StyleGenerating]
    
    init(generatable: [StyleGenerating], importedUrl: URL? = nil) throws {
        self.generatable = generatable
    
        if let importedUrl = importedUrl {
            let stylesheet = try initializeStylesheet(with: importedUrl,
                                                      stylesheetName: NSString(string: importedUrl.lastPathComponent).deletingPathExtension,
                                                      dependencyOf: nil,
                                                      extendsStylesheetName: nil,
                                                      symbolFont: nil,
                                                      typography: nil)
            Generator.ImportedStylesheet = stylesheet
        }
        
        let urls = generatable.compactMap({ $0.url })
        for i in 0..<urls.count {
            let url = urls[i]
            let symbolFont = Generator.Config.symbolFontNames[i]
            let typography = Generator.Config.typographyTextStyles
            let stylesheet = try initializeStylesheet(with: url,
                                                      stylesheetName: Generator.Config.stylesheetNames[i],
                                                      dependencyOf: nil,
                                                      extendsStylesheetName: Generator.Config.importStylesheetNames != nil ? Generator.Config.importStylesheetNames![i] : nil,
                                                      symbolFont: symbolFont.isEmpty ? nil : symbolFont,
                                                      typography: typography.isEmpty ? nil : typography)
            Generator.Stylesheets.append(stylesheet)
        }
    }
    
    // MARK: Private
    
    private func style(forValues valuesDictionary: [Yaml : Yaml], key: String, name: String, dependencyOf: String?, extendsStylesheetName: String?) throws -> Style {
        let properties = try createProperties(valuesDictionary)
        for property in properties where property.style != nil {
            property.style?.belongsToStylesheetName = dependencyOf ?? name
        }
        let style = Style(name: key, properties: properties)
        style.belongsToStylesheetName = dependencyOf ?? name

        if let extendsStylesheetName = extendsStylesheetName {
            style.extendsStylesheetName = extendsStylesheetName
        }
        for property in style.properties where property.style != nil {
            property.style?.nestedIn = style.name
        }
        return style
    }
}

// Extensions

extension Generator: StylesheetGeneratable {
    /// Returns the swift code for this item.
    func generate() -> [Payload] {
        var generatedStrings = [Payload]()
        for stylesheet in Generator.Stylesheets {
            stylesheet.prepareGenerator()
            stylesheet.dependencies?.forEach({ dependency in
                let styles = dependency.styles
                dependency.styles = dependency.styles + stylesheet.styles
                dependency.prepareGenerator()
                dependency.styles = styles
                dependency.ensureDeterminism()
                let additionalGeneratable = generatable.first(where: { Path($0.url.path).lastComponentWithoutExtension == stylesheet.name })
                var additionalGenerable: String = ""
                if let onAdditional = additionalGeneratable?.onAdditional, let additionalString = onAdditional(dependency.name)?.generatedCode {
                    additionalGenerable.append("\n" + additionalString)
                }
                generatedStrings.append((dependency.name, dependency.generate() + additionalGenerable, stylesheet.name))
            })
            generatedStrings.append((stylesheet.name, stylesheet.generate(), nil))
        }
        return generatedStrings
    }
}

extension StylesheetGeneratable {
    
    func createProperties(_ dictionary: [Yaml: Yaml]) throws -> [Property] {
        var properties = [Property]()
        
        for (yamlKey, yamlValue) in dictionary {
            if let key = yamlKey.string {
                properties.append(try property(with: key, yamlValue: yamlValue))
            }
        }
        return properties
    }
    
    
    func property(with key: String, yamlValue: Yaml) throws -> Property {
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
