//
//  Stylesheet.swift
//  sgen
//
//  Created by Daniele Pizziconi on 12/06/2020.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class Stylesheet {
    
    let name: String
    var styles: [Style]
    var additionalStyles: [Style]
    var animations: [Style]
    let dependencies: [Stylesheet]?
    let superclassName: String?
    let animatorName: String?
    let hasSymbolFont: Bool
    
    init(name: String,
         styles: [Style],
         animations: [Style],
         dependencies: [Stylesheet]? = nil,
         superclassName: String? = nil,
         animatorName: String? = nil,
         hasSymbolFont: Bool = false) {
        
        self.name = name
        
        var additionalStyles = [Style]()
        if let dependencyStyles = dependencies?.compactMap({ $0.styles }).joined() {
            additionalStyles = Array(dependencyStyles)
            additionalStyles.forEach({ $0.isDependency = true })
        }
        self.styles = styles + additionalStyles
        self.additionalStyles = additionalStyles
        self.animations = animations
        self.dependencies = dependencies
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
    
    func prepareGenerator() {
        
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
            for style in duplicates where !style.nestedInfo.isOverride {
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
        func check(_ style: Style, nestedSuperclassPrefix: String, searchInStyles: Bool, in baseStylesheet: Stylesheet) {
            let stylesBase = searchInStyles ? baseStylesheet.styles : baseStylesheet.animations
            if let superStyle = stylesBase.filter({ return $0.name == style.name }).first {
                style.nestedInfo = (isOverride: true,
                                    superclassName: "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)",
                                    returnClass: "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)",
                                    overrideName: "\(name)\(style.name)")
                                    
                for nestedStyle in style.properties.compactMap({ $0.style }) {
                    if let superNestedStyle = superStyle.properties.compactMap({ $0.style }).filter({ $0.name == nestedStyle.name }).first {
                        let nestedSuperclassName: String
                        let nestedReturnClass: String
                        let superNestedSuperclassName = superStyle.superclassName != nil && superNestedStyle.nestedInfo.isOverride ? superStyle.name : ""
                        if superStyle.isExternalOverride {
                            nestedSuperclassName = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superStyle.extendsStylesheetName!)\(superNestedSuperclassName)\(superNestedStyle.name)"
                            nestedReturnClass = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superNestedStyle.name)"

                        } else {
                            nestedSuperclassName = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superNestedSuperclassName)\(superNestedStyle.name)"
                            nestedReturnClass = "\(baseStylesheet.name).\(nestedSuperclassPrefix)\(superStyle.name)AppearanceProxy.\(superNestedStyle.name)"

                        }
                        nestedStyle.nestedInfo = (isOverride: true,
                                                  superclassName: nestedSuperclassName,
                                                  returnClass: nestedReturnClass,
                                                  overrideName: "\(name)\(superNestedStyle.name)\(style.name)")
                    }
                    markOverrides(nestedStyle, superclassName: nestedStyle.nestedInfo.superclassName)
                }
            }
        }
        
        if let baseSuperclassName = self.superclassName, let baseStylesheet = Generator.Stylesheets.filter({ return $0.name == baseSuperclassName }).first {
            check(style, nestedSuperclassPrefix: nestedSuperclassPrefix, searchInStyles: searchInStyles, in: baseStylesheet)
        }
        
        for property in style.properties {
            if let nestedStyle = property.style {
                let (isOverride, superclassName, styleName) = styleIsOverride(nestedStyle, superStyle: style)
                if let styleName = styleName, let superclassName = superclassName, isOverride, !nestedStyle.nestedInfo.isOverride {
                    nestedStyle.nestedInfo = (isOverride: isOverride,
                                              superclassName: nestedSuperclassPrefix+superclassName,
                                              returnClass: nestedSuperclassPrefix+superclassName,
                                              overrideName: styleName)
                }
                if style.isExternalOverride {
                    nestedStyle.isNestedInExternal = (true, nestedStyle.nestedInfo.isOverride)
                    if nestedStyle.nestedInfo.isOverride {
                        nestedStyle.properties.forEach({ $0.isOverride = true })
                    }
                } else {
                    markOverrides(nestedStyle, superclassName: nestedStyle.nestedInfo.superclassName)
                }
            }
            if style.isExternalOverride {
                property.isOverride = propertyIsOverride(property.key, superclass: (withinScope: nil, nested: nil, external: superclassName), isStyleProperty: searchInStyles)
            } else {
                property.isOverride = propertyIsOverride(property.key, superclass: (withinScope: superclassName, nested: style.nestedInfo.superclassName, external: nil), isStyleProperty: searchInStyles)
            }
        }
    }
    
    fileprivate func styleIsOverride(_ style: Style, superStyle: Style) -> (isOverride: Bool, superclassName: String?, styleName: String?) {
        
        guard let _ = superStyle.superclassName else { return (false, nil, nil) }
        
        if superStyle.isExternalOverride {
            if let importedStylesheet = Generator.ImportedStylesheet {
                return check(style, superStyle: superStyle, in: style.isAnimation ? importedStylesheet.animations : importedStylesheet.styles)
            } else {
                let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil && Generator.Config.importFrameworks != nil
                let namespace = hasNamespace ? "\(Generator.Config.importFrameworks!)." : ""
                return (true, "\(namespace)\(superStyle.superclassName!)AppearanceProxy.\(style.name)", "\(superStyle.extendsStylesheetName!)\(style.name)")
            }
        }
        return check(style, superStyle: superStyle, in: style.isAnimation ? animations : styles)
    }
    
    func check(_ style: Style, superStyle: Style, in styles: [Style]) -> (isOverride: Bool, superclassName: String?, styleName: String?) {
        
        let nestedStyles = styles.flatMap{ $0.properties }.filter{
            guard let nestedStyle = $0.style, nestedStyle.name == style.name else { return false }
            return true
        };
        
        for st in styles {
            for property in st.properties {
                let superClassNameOfSuperStyle = superStyle.superclassName?.components(separatedBy: ".").last
                if let nestedStyle = property.style, nestedStyle.name == style.name, st.name != superStyle.name && (superClassNameOfSuperStyle != nil ? superClassNameOfSuperStyle == st.name : true) && nestedStyles.count > 0 {
                    
                    if let superclassName = st.superclassName {
                        if st.extendsStylesheetName != nil && superclassName.components(separatedBy: ".").count > 1 {
                            return (true, "\(superclassName)AppearanceProxy.\(Generator.Config.importStylesheetNames!.first!)\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
                        } else {
                            return (true, "\(superclassName)AppearanceProxy.\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
                        }
                    } else if let superclassName = superStyle.superclassName, superclassName == st.name {
                        return (true, "\(superclassName)AppearanceProxy.\(nestedStyle.name)", "\(superStyle.name)\(style.name)")
                    } else if let components = superStyle.superclassName?.components(separatedBy: "."), components.last == st.name {
                        let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil && Generator.Config.importFrameworks != nil
                        let namespace = hasNamespace ? "\(Generator.Config.importFrameworks!)." : ""
                        return (true, "\(namespace)\(superStyle.superclassName!)AppearanceProxy.\(nestedStyle.name)", "\(superStyle.extendsStylesheetName!)\(superStyle.name)\(style.name)")
                    }
                }
            }
        }
        return (false, nil, nil)
    }
    
    // Determines if this property is an override or not.
    fileprivate func propertyIsOverride(_ property: String, superclass: (withinScope: String?, nested: String?, external: String?), isStyleProperty: Bool) -> Bool {
        
        let searchableSuperclassName = superclass.external ?? superclass.nested
        let searchableStylesheets = superclass.external != nil && Generator.ImportedStylesheet != nil ? [Generator.ImportedStylesheet!] : Generator.Stylesheets
        
        if let nestedSuperclassName = searchableSuperclassName, let components = Optional(nestedSuperclassName.components(separatedBy: ".")), components.count > 1, let baseStylesheet = searchableStylesheets.filter({ $0.name == components.first }).first {
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
        guard let superclass = superclass.withinScope else { return false }
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
            return propertyIsOverride(property, superclass: (withinScope: style.superclassName, nested: style.nestedInfo.superclassName, external: nil), isStyleProperty: isStyleProperty)
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

// MARK: - Determinism

extension Stylesheet: Determinism {
    func ensureDeterminism() -> Stylesheet {
        styles = styles.compactMap({ $0.ensureDeterminism() }).sorted(by: { $0.name < $1.name })
        animations = animations.compactMap({ $0.ensureDeterminism() }).sorted(by: { $0.name < $1.name })
        return self
    }
}

// MARK: - Generator

extension Stylesheet: Generatable {
    
    private var isDependencyOfOtherStylesheet: Bool {
        return parentStylesheet != nil
    }
    
    private var parentStylesheet: String? {
        return Generator.Stylesheets.first(where: { $0.dependencies?.first(where: { $0.name == self.name }) != nil })?.name
    }
    
    public func generate(_ nested: Bool = false, includePrefix: Bool = true) -> String {
        let importDef = "UIKit"
        var stylesheet = ""
        stylesheet += "/// Autogenerated file\n"
        stylesheet += "\n// swiftlint:disable all\n"
        
        stylesheet += "import \(importDef)\n\n"
        if let namespace = Generator.Config.importFrameworks {
            stylesheet += "import \(namespace)\n\n"
        }
        
        let isBaseStylesheet = superclassName == nil && isDependencyOfOtherStylesheet == false
        var superclass = ": NSObject"
        if let s = superclassName { superclass = ": \(s)" }
    
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
        if isDependencyOfOtherStylesheet == false {
            stylesheet += generateStylesheetManager()
        }
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
        
        if styles.count > 0 || animatorName != nil {

            if isDependencyOfOtherStylesheet == false {
                let objc = Generator.Config.objcGeneration ? "@objc(STR\(self.name)) @objcMembers " : ""

                stylesheet += "/// Entry point for the app stylesheet\n"
                stylesheet += "\(objc)public class \(self.name)\(superclass) {\n\n"
                
                let override = superclassName != nil ? "override " : ""
                stylesheet += "\tpublic \(override)class func shared() -> \(self.name) {\n"
                stylesheet += "\t\t struct __ { static let _sharedInstance = \(self.name)() }\n"
                stylesheet += "\t\treturn __._sharedInstance\n"
                stylesheet += "\t}\n"
            } else if let parentStylesheet = parentStylesheet {
                let objc = Generator.Config.objcGeneration ? "@objc " : ""
                stylesheet += "/// Entry point for the app stylesheet\n"
                stylesheet += "\(objc)extension \(parentStylesheet) {\n\n"
            }

            for style in styles {
                if style.isDependency && isDependencyOfOtherStylesheet {
                    style.isDependencyInItsOwnStylesheet = true
                }
                stylesheet += style.generate()
                
                if style.isDependencyInItsOwnStylesheet {
                    style.isDependencyInItsOwnStylesheet = false
                }
            }
            
            if animatorName != nil {
                stylesheet += generateAnimator()
                for animation in animations {
                    stylesheet += animation.generate()
                }
                stylesheet += "\t\n\n}"
            }
            
            stylesheet += "\n}"
        }
        
        if Generator.Config.namespace != nil {
            stylesheet += "\n}"
        }
        
        if Generator.Config.extensionsEnabled {
            styles.forEach({
                if $0.isDependency && isDependencyOfOtherStylesheet {
                    $0.isDependencyInItsOwnStylesheet = true
                }
            })

            stylesheet += generateExtensions()
            
            styles.forEach({
                if $0.isDependencyInItsOwnStylesheet {
                    $0.isDependencyInItsOwnStylesheet = false
                }
            })
        }
        if isBaseStylesheet && animatorName != nil {
            stylesheet += generateAnimatorExtension()
        }
        return stylesheet
    }
}


extension Stylesheet {
    func generateGlobal() -> String {
        if superclassName != nil { return "" }
        
        let styleFilter: (Style) -> Bool = isDependencyOfOtherStylesheet
            ? { _ in return true }
            : { $0.isDependency == false }
        let enumGeneratables = styles.filter(styleFilter).flatMap({ $0.properties }).sorted(by: { $0.key < $1.key }).compactMap({ $0.rhs }).filter({ $0.isGlobal })
        if enumGeneratables.count == 0 { return "" }
        
        let isBaseStylesheet = Generator.Config.importStylesheetManagerName == nil && superclassName == nil && isDependencyOfOtherStylesheet == false
        
        var global: String = ""
        if isBaseStylesheet {
            global = Generator.Config.objcGeneration ? "@objc(\(NamespaceEnums)) public class \(NamespaceEnums): NSObject {\n\n" : "public struct \(NamespaceEnums) {\n\n"
        } else {
            global = "\(Generator.Config.objcGeneration ? "@objc " : "")public extension \(NamespaceEnums) {\n\n"
        }
        
        var enums = ""
        enumGeneratables.forEach({
            let toGenerate = $0.generate(false)
            if enums.contains(toGenerate) == false { enums += toGenerate }
        })
        
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
        let isBaseStylesheet = superclassName == nil && isDependencyOfOtherStylesheet == false
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
                header += "\tstatic let didChangeTheme = Notification.Name(\"\(LibraryName).stylesheet.theme\")\n"
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
                header += "\t\tstatic let theme = \"\(LibraryName).theme\"\n"
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
        let visibility = "private"
        var header = ""

        if Generator.Config.importStylesheetManagerName != nil {
            return header
        }

        header += """
/// Your view should conform to 'AppearaceProxyComponent'.
public protocol AppearaceProxyComponent: class {
    associatedtype ApperanceProxyType
    var appearanceProxy: ApperanceProxyType { get }
    var themeAware: Bool { get set }
    func didChangeAppearanceProxy()
}

public extension AppearaceProxyComponent {
    func initAppearanceProxy(themeAware: Bool = true) {
        self.themeAware = themeAware
        didChangeAppearanceProxy()
    }
}


"""

        if hasSymbolFont {
            header += """
public extension \(NamespaceEnums).\(IconicFontStyle) {
    var name: String {
        switch self {
"""
            let cases = IconicWeight.allCases.sorted(by: { $0.rawValue < $1.rawValue }).map({ $0.rawValue }).sorted()
            cases.forEach { enumCase in
                header += """

        case .\(enumCase):
            return \(Generator.Config.stylesheetManagerName).S.\(IconicFontSectionName).\(enumCase)FontName
"""
            }

            header += """

        }
    }
}


"""
        }

        let textStyleType = "\(NamespaceEnums).\(FontTextStyle)"

        header += """
private extension \(textStyleType) {
    var style: UIFont.TextStyle? {
        switch self {
"""

        let textStyleNames = Generator.Config.typographyTextStyles.keys.sorted()
        for enumCase in textStyleNames {
            let info = Generator.Config.typographyTextStyles[enumCase]!
            if let availableVersion = info.version {
                header += """

        case .\(enumCase):
            if #available(iOS \(availableVersion).0, *) {
                return .\(info.mapsTo)
            } else {
                return nil
            }
"""
            } else {
                header += """

        case .\(enumCase):
            return .\(info.mapsTo)
"""
            }
        }

        header += """

        }
    }

    var defaultPointSize: CGFloat? {
        switch self {

"""

        var needsDefaultCase: Bool = false
        for enumCase in textStyleNames {
            let info = Generator.Config.typographyTextStyles[enumCase]!
            if let defaultPointSize = info.defaultPointSize {
                header += """

        case .\(enumCase):
            return \(defaultPointSize)
"""
            } else {
                needsDefaultCase = true
            }
        }

        if needsDefaultCase {
            header += """
        default:
            return nil
"""
        }

        header += """

        }
    }

    var maximumPointSize: CGFloat? {
        switch self {

"""

        needsDefaultCase = false
        for enumCase in textStyleNames {
            let info = Generator.Config.typographyTextStyles[enumCase]!
            if let maximumPointSize = info.maximumPointSize {
                header += """

        case .\(enumCase):
            return \(maximumPointSize)
"""
            } else {
                needsDefaultCase = true
            }
        }

        if needsDefaultCase {
            header += """
        default:
            return nil
"""
        }

        header += """

        }
    }
}

private let defaultSizes: [UIFont.TextStyle: CGFloat] = {
    var sizes: [UIFont.TextStyle: CGFloat] = [.body: 17,
                                              .callout: 16,
                                              .caption2: 11,
                                              .caption1: 12,
                                              .footnote: 13,
                                              .headline: 17,
                                              .largeTitle: 34,
                                              .subheadline: 15,
                                              .title3: 20,
                                              .title2: 22,
                                              .title1: 28]
    return sizes
}()

private class FluentUIFontCache: NSObject {
    private lazy var cache = [UIFont.FontType: UIFont]()

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleApplicationDidReceiveMemoryWarning),
                                               name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }

    @objc private func handleApplicationDidReceiveMemoryWarning() {
        cache.removeAll()
    }

    func font(name: String? = nil,
              size: CGFloat? = nil,
              textStyle: \(textStyleType)? = nil,
              weight: UIFont.Weight? = nil,
              traits: UIFontDescriptor.SymbolicTraits,
              traitCollection: UITraitCollection? = nil,
              isScalable: Bool = true) -> UIFont {
        let key = UIFont.FontType(name: name,
                                  size: size,
                                  textStyle: textStyle,
                                  weight: weight,
                                  traits: traits,
                                  traitCollection: traitCollection,
                                  isScalable: isScalable)
        if let font = cache[key] {
            return font
        }

        var font: UIFont!
        var isAlreadyScalable = false
        let fontSize = size ?? textStyle?.defaultPointSize

        if let name = name, let size = fontSize, let customFontWithSpecificSize = UIFont(name: name, size: size) {
            font = customFontWithSpecificSize
        } else if let size = fontSize {
            if let weight = weight {
                font = UIFont.systemFont(ofSize: size, weight: weight)
            } else {
                font = UIFont.systemFont(ofSize: size)
            }
        } else if let nativeTextStyle = textStyle?.style {
            isAlreadyScalable = isScalable && textStyle?.maximumPointSize == nil
            font = UIFont.preferredFont(forTextStyle: nativeTextStyle,
                                        compatibleWith: isScalable ? traitCollection : UITraitCollection(preferredContentSizeCategory: .large))
        }

        guard font != nil else {
            fatalError("Failed to load the font.")
        }

        if !traits.isEmpty {
            font = font.with(traits: traits)
        }

        if isScalable && !isAlreadyScalable {
            if let nativeTextStyle = textStyle?.style {
                if let maximumPointSize = textStyle?.maximumPointSize {
                    font = UIFontMetrics(forTextStyle: nativeTextStyle).scaledFont(for: font, maximumPointSize: maximumPointSize, compatibleWith: traitCollection)
                } else {
                    font = UIFontMetrics(forTextStyle: nativeTextStyle).scaledFont(for: font, compatibleWith: traitCollection)
                }
            } else {
                font = UIFontMetrics.default.scaledFont(for: font, compatibleWith: traitCollection)
            }
        }

        font.isScalable = isScalable
        font.fontType = key
        cache[key] = font
        return font
    }
}

\(visibility) var fontTypeHandle: UInt8 = 0

\(visibility) extension UIFont {
    struct FontType: Hashable {
        let name: String?
        let size: CGFloat?
        let textStyle: \(textStyleType)?
        let weight: UIFont.Weight?
        let traits: UIFontDescriptor.SymbolicTraits
        let traitCollection: UITraitCollection?
        let isScalable: Bool
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(size)
            hasher.combine(textStyle)
            hasher.combine(weight)
            hasher.combine(traits.rawValue)
            hasher.combine(traitCollection)
            hasher.combine(isScalable)
        }
    }

    var fontType: FontType? {
        get { return objc_getAssociatedObject(self, &fontTypeHandle) as? FontType }
        set { objc_setAssociatedObject(self, &fontTypeHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

\(visibility) var scalableHandle: UInt8 = 0

private extension UIFont {
    private static var cache = FluentUIFontCache()

"""

        if hasSymbolFont {
            header += """
    convenience init?(style: \(NamespaceEnums).\(IconicFontStyle), size: CGFloat) {
        self.init(name: style.name, size: size)
    }

"""
        }

        header += """
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }

    class func font(name: String? = nil,
                    size: CGFloat? = nil,
                    textStyle: \(textStyleType)? = nil,
                    weight: UIFont.Weight? = nil,
                    traits: UIFontDescriptor.SymbolicTraits,
                    traitCollection: UITraitCollection? = nil,
                    isScalable: Bool = true) -> UIFont {
        return cache.font(name: name,
                          size: size,
                          textStyle: textStyle,
                          weight: weight,
                          traits: traits,
                          traitCollection: traitCollection,
                          isScalable: isScalable)
    }

    var isScalable: Bool {
        get { return objc_getAssociatedObject(self, &scalableHandle) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &scalableHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var textStyle: UIFont.TextStyle? {
        return fontDescriptor.fontAttributes[.textStyle] as? UIFont.TextStyle
    }

    var fixedFont: UIFont {
        if isScalable == false {
            return self
        }

        if let fontType = fontType {
            return UIFont.font(name: fontType.name, size: fontType.size, textStyle: fontType.textStyle, weight: fontType.weight, traits: fontType.traits, traitCollection: fontType.traitCollection, isScalable: false)
        }

        guard let textStyle = textStyle, let defaultSize = defaultSizes[textStyle] else {
            return self
        }

        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        return UIFont(descriptor: fontDescriptor, size: defaultSize)
    }
}


"""

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
        let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil
        let namespace = hasNamespace ? "\(Generator.Config.namespace!)." : ""
        let styleToGenerate = styles.filter({ $0.isExtension && ($0.isDependency == false || $0.isDependencyInItsOwnStylesheet) })
        
        if styleToGenerate.isEmpty {
            return ""
        }
        
        var extensions = "\n"

        let visibility = "fileprivate"
        extensions += "\(visibility) var __ApperanceProxyHandle: UInt8 = 0\n"
        extensions += "\(visibility) var __ThemeAwareHandle: UInt8 = 0\n"
        extensions += "\(visibility) var __ObservingDidChangeThemeHandle: UInt8 = 0\n"
        
        for style in styleToGenerate {
            
            if let superclassName = superclassName, let _ = Generator.Stylesheets.filter({ $0.name == superclassName }).first?.styles.filter({ $0.name == style.name }).first {
                continue
            }
            let name = style.belongsToStylesheetName ?? self.name
            let stylesheetName = (style.nestedInfo.isOverride || style.isNestedOverridable) ? "\(Generator.Config.stylesheetManagerName).stylesheet(\(namespace)\(name).shared())" : name
            let visibility = "public"
            
            func extendedStyles(style: Style) -> [Style] {
                let styles = Generator.Stylesheets.first(where: { $0.name == name })?.styles ?? self.styles
                let extendedStylesInBaseStylesheet = styles.filter({ $0.superclassName == style.name }).sorted(by: { $0.name < $1.name })
                if extendedStylesInBaseStylesheet.count == 0 { return extendedStylesInBaseStylesheet }
                
                let result = extendedStylesInBaseStylesheet.reduce(extendedStylesInBaseStylesheet) { (accumulation: [Style], nextValue: Style) -> [Style] in
                    return extendedStyles(style: nextValue) + accumulation
                }
                return result
            }
            
            let extendedStylesInBaseStylesheet = extendedStyles(style: style)
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
            
            if Generator.Config.importStylesheetManagerName == nil && sortedStatements.count > 0 {
                extensions += "\t\t\t\tif let proxyString = Optional(String(reflecting: type(of: proxy))), proxyString.hasPrefix(\"\(LibraryName)\") == false {\n"
                extensions += "\t\t\t\t\treturn proxy\n"
                extensions += "\t\t\t\t}\n\n"
            }
            
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
