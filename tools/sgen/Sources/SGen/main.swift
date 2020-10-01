//
//  main.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Commander
import Foundation
import PathKit
import xcodeproj

// MARK: Validators

extension Config.Entry.Output {
    func checkPaths() throws {
        if path?.parent().exists == false && link?.project.parent().exists == false {
            throw Config.Error.pathNotFound(path: path != nil ? path!.parent() : link!.project.parent())
        }
    }
}

extension Config.Entry {
    func checkPaths() throws {
        if let baseStylePath = baseStylePath, baseStylePath.exists == false {
            throw Config.Error.pathNotFound(path: baseStylePath)
        }
        for inputPath in inputs {
            guard inputPath.exists else {
                throw Config.Error.pathNotFound(path: inputPath)
            }
        }
        try output.checkPaths()
    }
    
    func run() throws {
        Generator.Config.stylesheetNames = []
        Generator.Config.objcGeneration = objc
        Generator.Config.generateAppearanceProxyProtocol = generateAppearanceProxyProtocol
        Generator.Config.generateFilePerAppearanceProxy = generateFilePerAppearanceProxy
        
        if let extendedName = extendedName, let importStyle = importStyle {
            Generator.Config.namespace = namespace
            //we're generating an extended stylesheet
            let baseStylesheetManagerName = Generator.Config.stylesheetManagerName
            Generator.Config.stylesheetManagerName = extendedName + Generator.Config.stylesheetManagerName
            Generator.Config.importStylesheetManagerName = baseStylesheetManagerName
            Generator.Config.importFrameworks = importStyle.name
            Generator.Config.importStylesheetNames = [importStyle.baseStylePath.lastComponentWithoutExtension] + (importStyle.styles ?? [])
        }
        
        let generables: [StyleGenerable] = ((baseStylePath != nil ? [baseStylePath!.url] : []) + inputs.map({ $0.url })).compactMap({ StyleGenerable(url: $0) })
        let baseStyleName = baseStylePath != nil
            ? ":\(baseStylePath!.lastComponentWithoutExtension)"
            : ""
        var names: [String] =
            (baseStylePath != nil ? [baseStylePath!.lastComponentWithoutExtension] : [])
            + (self.names?.compactMap({ "\($0)\(baseStyleName)" }) ?? inputs.compactMap({ "\($0.lastComponentWithoutExtension)\(baseStyleName)" }))
        names.forEach({ Generator.Config.stylesheetNames.append($0) })
        names = names.map({ $0.replacingOccurrences(of: baseStyleName, with: "") })
        
        Generator.Config.stylesheetNames.forEach { (name) in
            let normalizedName = name.contains(":") ? name.replacingOccurrences(of: baseStyleName, with: "") : name
            if let fontSymbol = symbolsFont?.names[normalizedName] {
                Generator.Config.symbolFontNames.append(Dictionary(uniqueKeysWithValues: fontSymbol.map { (key, value) in (IconicWeight(rawValue: key.rawValue)!, value) }))
            } else {
                Generator.Config.symbolFontNames.append([IconicWeight: String]())
            }
        }
        
        if let typographyStyles = typography?.styles {
            Generator.Config.typographyTextStyles = Dictionary(uniqueKeysWithValues: typographyStyles.map { (key, value) in (key, TypographyInfo(dict: value)) })
        } else {
            Generator.Config.typographyTextStyles = [String: TypographyInfo]()
        }
        
        // Icon generator
        var symbolAssetsInputs = [Path]()
        if let symbolsAsset = symbolsAsset {
            
            for input in symbolsAsset.inputs {
                logMessage(.info, "Generating icon stylesheet \(input.lastComponentWithoutExtension)...")
                
                let assetFile = Path(input.url.path)
                
                if assetFile.exists == false {
                    throw GeneratorError.fileDoesNotExist(error: "File \(input) not found.")
                }
                    
                var assetsComponents = assetFile.components
                let temporaryName = "_" + assetFile.lastComponent
                assetsComponents = assetsComponents.dropLast()
                assetsComponents.append(temporaryName)
            
                let temporaryAssetFile = Path(components: assetsComponents)
                if temporaryAssetFile.exists {
                    try temporaryAssetFile.delete()
                }
                try assetFile.copy(temporaryAssetFile)
                symbolAssetsInputs.append(temporaryAssetFile)
                    
                let supportedIconNames = symbolsAsset.icons.names.keys
                let generator = temporaryAssetFile.iterateChildren(options: .skipsHiddenFiles).makeIterator()
                
                struct IconFileName: Hashable {
                    let variation: String
                    let filename: String
                }
                typealias IconInfo = (iconResourceName: String, variations: [IconSupportedKeys: [IconFileName]])
                
                var iconAssets = [String: IconInfo]()
                                
                while let child = generator.next() {
                    generator.skipDescendants()
                    var keepsChild = false
                    
                    defer {
                        if keepsChild == false {
                            do {
                                try child.delete()
                            }
                            catch let error as NSError {
                                
                            }
                        }
                    }
                    
                    // expecting a file with [format].imageSet
                    var imageSetFolderName = child.lastComponentWithoutExtension
                    // matches: [[imageSetFolderName, icon_name]]
                    guard let regex = symbolsAsset.format.first(where: { $0.key == IconNameKey })?.regex, let iconName = imageSetFolderName.matchingStrings(regex: regex).first?.last else {
                        continue
                    }
                    
                    let camelCaseIconName = iconName.camelized
                    imageSetFolderName = imageSetFolderName.replacingOccurrences(of: iconName, with: camelCaseIconName)
                    
                    if supportedIconNames.contains(camelCaseIconName) == false {
                        continue
                    }
                        
                    var supportedIconDict = iconAssets[camelCaseIconName]?.variations
                    if supportedIconDict == nil { supportedIconDict = [IconSupportedKeys: [IconFileName]]() }
                    
                    if symbolsAsset.format.count > 1 {
                        var possibleKeysDict = [IconSupportedKeys: [IconFileName]]()
                        var satisfiedAllDefault = true
                        for (key, regex) in symbolsAsset.format where key != IconNameKey {
                            // matches: [[imageSetFolderName, key]]
                            guard let extractedField = imageSetFolderName.matchingStrings(regex: regex).first?.last else {
                                continue
                            }
                            
                            // check if it's the icons default
                            guard let supportedKey = IconSupportedKeys(rawValue: key) else {
                                continue
                            }
                            var supportedKeyArray = supportedIconDict?[supportedKey]
                            if supportedKeyArray == nil { supportedKeyArray = [IconFileName]() }
                            if let icon = symbolsAsset.icons.names[camelCaseIconName], icon[supportedKey]?.contains(extractedField) == true {
                                if supportedKeyArray!.compactMap({ $0.variation }).contains(extractedField) == false {
                                    supportedKeyArray?.append(IconFileName(variation: extractedField, filename: child.lastComponentWithoutExtension))
                                }
                                keepsChild = true
                            }
                            
                            var possibleKeysArray = possibleKeysDict[supportedKey]
                            if possibleKeysArray == nil { possibleKeysArray = [IconFileName]() }

                            if keepsChild == false {
                                if symbolsAsset.icons.version[supportedKey]?.contains(extractedField) ?? false == true {
                                    if possibleKeysArray!.compactMap({ $0.variation }).contains(extractedField) == false {
                                        possibleKeysArray!.append(IconFileName(variation: extractedField, filename: child.lastComponentWithoutExtension))
                                    }
                                } else {
                                    satisfiedAllDefault = false
                                }
                            }
                            
                            supportedIconDict?[supportedKey] = supportedKeyArray
                            possibleKeysDict[supportedKey] = possibleKeysArray
                        }
                        if keepsChild == false && satisfiedAllDefault {
                            supportedIconDict = supportedIconDict?.merging(possibleKeysDict) {
                                (current, new) in
                                Array(Set(current + new))
                            }
                        }
                        
                        keepsChild = keepsChild || satisfiedAllDefault
                        
                    } else {
                        keepsChild = true
                    }
                    iconAssets[camelCaseIconName] = (iconResourceName: iconName, variations: supportedIconDict!)
                }
                
                // we need to create a *Icon.yml prior to the Stylesheet generation, so we need to find the correspondent style and its input path
                if let correspondentStyle = symbolsAsset.names.first(where: { (_, value) in value == input.lastComponent })?.key,
                    let correspondentStyleInput = generables.first(where: { generatable in Path(generatable.url.path).lastComponentWithoutExtension == correspondentStyle }) {
                    let isBaseStyle = correspondentStyle == (baseStylePath != nil ? baseStylePath!.lastComponentWithoutExtension : (names.first ?? inputs.compactMap({ $0.lastComponentWithoutExtension }).first))
                    
                    let iconStyleName = correspondentStyle + "Icon.yml"
                    var iconPathComponents = correspondentStyleInput.url.pathComponents.dropLast()
                    iconPathComponents.append(iconStyleName)
                    let iconPath = Path(components: iconPathComponents)
                    
                    let ResourceString = "resourceString"
                    let IconDefaults = "IconDefaults"
                    
                    let tab: (yml: String, swift: String) = ("  ", "\t")
                    var iconFileContent = ""
                    var generateString = ""
                    let KeySorting: ((key: IconSupportedKeys, value: SymbolAsset.Icon.Mapping), (key: IconSupportedKeys, value: SymbolAsset.Icon.Mapping)) -> Bool = { $0.key.rawValue < $1.key.rawValue }
                    let keysSorted: [Dictionary<IconSupportedKeys, Config.Entry.SymbolAsset.Icon.Mapping>.Element] = symbolsAsset.icons.keys.sorted(by: KeySorting)
                    let objc = self.objc ? "@objc " : ""
                    
                    if isBaseStyle {
                        
                        // UIImage extensions
                        generateString += "//MARK: - UIImage\n\n"
                        generateString += "private class IconsBundleCheck {}\n"
                        generateString += "\n"
                        generateString += "\(objc)public extension UIImage {\n"
                        generateString += "\(tab.swift)\n"
                        generateString += "\(tab.swift)private static let iconBundle = Bundle(for: IconsBundleCheck.self)\n"
                        generateString += "\(tab.swift)\n"
                        
                        func parametersImageExtension(keys: [IconSupportedKeys], showsType: Bool, setsDefaultTo: [IconSupportedKeys]?) -> String {
                            var strings = [String]()
                            keys.forEach { key in
                                let type = showsType ? "\(NamespaceEnums + "." + IconEnum + key.rawValue.capitalized) = " : ""
                                let value = setsDefaultTo?.contains(key) ?? false ? "\(StylesheetManagerName).S.\(IconDefaults).\(key.rawValue)" : "\(key.rawValue)"
                                strings.append("\(key.rawValue): \(type)\(value)")
                            }
                            return strings.joined(separator: ", ")
                        }
                                                
                        let powerSet = keysSorted.powerSet
                        powerSet.forEach { keysWithMapping in
                            let keys = keysWithMapping.compactMap({ $0.key })
                            let allKeysSorted = keysSorted.compactMap({ $0.key })
                            var parameters: String = parametersImageExtension(keys: keys, showsType: true, setsDefaultTo: keys)
                            parameters = parameters.isEmpty == false ? ", \(parameters)" : ""
                            generateString += "\(tab.swift)convenience init(icon: \(NamespaceEnums + "." + IconEnum)\(parameters)) {\n"
                            if keys.count == keysSorted.count {
                                generateString += "\(tab.swift)\(tab.swift)self.init(named: icon.\(ResourceString)(\(parametersImageExtension(keys: allKeysSorted, showsType: false, setsDefaultTo: nil))), in: UIImage.iconBundle, compatibleWith: nil)!\n"
                            } else {                                 generateString += "\(tab.swift)\(tab.swift)self.init(icon: icon, \(parametersImageExtension(keys: allKeysSorted, showsType: false, setsDefaultTo: allKeysSorted.filter({ keys.contains($0) == false }))))\n"
                            }
                            
                            generateString += "\(tab.swift)}\n"
                            generateString += "\(tab.swift)\n"
                        }
                        
                        generateString += "}\n"
                        generateString += "\n"
                        
                        iconFileContent += "IconEnums:\n"
                        
                        keysSorted.forEach { (key: IconSupportedKeys, value: SymbolAsset.Icon.Mapping) in
                            
                            // We create an enum in the stylesheet: EnumName: EnumDef(values,..)
                            let enumName = IconEnum + key.rawValue.capitalized
                            var enumCases = ""
                            if let mapsTo = value.mapsTo {
                                enumCases.append(mapsTo.joined(separator: ", "))
                            } else {
                                enumCases.append(value.values.joined(separator: ", "))
                            }
                            iconFileContent += "\(tab.yml)\(enumName): \(StylesheetGrammar.Primitive.enumDef.rawValue)(\(enumCases))\n"
                            
                            // We create an extension to return the resourceString of each of the enum
                            generateString += "//MARK: - \(NamespaceEnums).\(enumName)\n\n"
                            generateString += "fileprivate extension \(NamespaceEnums).\(enumName) {\n"
                            generateString += "\(tab.swift)var \(ResourceString): String {\n"
                            generateString += "\(tab.swift)\(tab.swift)switch self {\n"
                            for (index, enumCase) in enumCases.split(separator: ",").enumerated() {
                                generateString += "\(tab.swift)\(tab.swift)case .\(enumCase.trimmingCharacters(in: .whitespacesAndNewlines)): return \"\(value.values[index])\"\n"
                            }
                            generateString += "\(tab.swift)\(tab.swift)}\n"
                            generateString += "\(tab.swift)}\n"
                            
                            // if the extension is a number return also that
                            if value.isNumber {
                                generateString += "\(tab.swift)var \(key.rawValue): CGFloat {\n"
                                generateString += "\(tab.swift)\(tab.swift)return CGFloat(Float(\(ResourceString))!)\n"
                                generateString += "\(tab.swift)}\n"
                            }
                            
                            generateString += "}\n"
                            generateString += "\n"
                        }
                        
                        // This is the list of supported icons in the stylesheet
                        let sortedIcons = iconAssets.sorted(by: { $0.key < $1.key })
                        let icons = sortedIcons.compactMap { (key: String, _) in key }.sorted().joined(separator: ",\n\(tab.yml)\(tab.yml)")
                        iconFileContent += "\(tab.yml)\(IconEnum): \(StylesheetGrammar.Primitive.enumDef.rawValue)(\(EnumCaseNone),\n\(tab.yml)\(tab.yml)\(icons))\n"
                        
                        // Extension for Symbol
                        let iconSymbolEnum = NamespaceEnums + "." + IconEnum
                        generateString += "//MARK: - \(iconSymbolEnum) \n\n"
                        generateString += "extension \(iconSymbolEnum) {\n"
                        generateString += "\n"
                        
                        let parametersResource = keysSorted
                            .compactMap({
                                var defaultParameter: String = ""
                                if let defaultValue = symbolsAsset.icons.default[$0.key] {
                                    if let mapping = $0.value.mapsTo, let index = $0.value.values.firstIndex(of: defaultValue) {
                                        defaultParameter = " = .\(mapping[index])"
                                    } else {
                                        defaultParameter = " = .\(defaultValue)"
                                    }
                                }
                                return "\($0.key.rawValue): \(iconSymbolEnum + $0.key.rawValue.capitalized)\(defaultParameter)"
                            })
                            .joined(separator: ", ")
                        
                        // func resourceString(parameters) -> String
                        let AvailablePrefix = "available"
                        let Glyph = "glyph"
                        let MaxConsecutiveEnumCases = 100
                        
                        generateString += "\(tab.swift)public var \(Glyph): UIImage {\n"
                        generateString += "\(tab.swift)\(tab.swift)return \(Glyph)()\n"
                        generateString += "\(tab.swift)}\n"
                        
                        generateString += "\(tab.swift)\n"
                        generateString += "\(tab.swift)public func \(Glyph)(_ \(parametersImageExtension(keys: keysSorted.compactMap({ $0.key }), showsType: true, setsDefaultTo: keysSorted.compactMap({ $0.key })))) -> UIImage {\n"
                        generateString += "\(tab.swift)\(tab.swift)return UIImage(icon: self, \(parametersImageExtension(keys: keysSorted.compactMap({ $0.key }), showsType: false, setsDefaultTo: nil)))\n"
                        generateString += "\(tab.swift)}\n"
                        generateString += "\(tab.swift)\n"
                        
                        generateString += "\(tab.swift)public var isValid: Bool {\n"
                        generateString += "\(tab.swift)\(tab.swift)return self != \(iconSymbolEnum).\(EnumCaseNone)\n"
                        generateString += "\(tab.swift)}\n"
                        generateString += "\(tab.swift)\n"
                        
                        generateString += "\(tab.swift)fileprivate func \(ResourceString)(\(parametersResource)) -> String {\n"
                        // fallback values (e.g. let safeSize = ....)
                        
                        keysSorted.forEach { (key: IconSupportedKeys, value: SymbolAsset.Icon.Mapping) in
                            let keyCapitalized = key.rawValue.capitalized
                            let propertyName = "safe" + keyCapitalized
                            if value.isNumber {
                                // e.g. availableSizes.enumerated().min(by: { abs($0.1.size - size.size) < abs($1.1.size - size.size) })?.element ?? StylesheetManager.S.IconDefaults.size
                                generateString += "\(tab.swift)\(tab.swift)let \(propertyName): \(iconSymbolEnum + keyCapitalized) = \(AvailablePrefix + keyCapitalized + "s").enumerated().min(by: { abs($0.1.\(key.rawValue) - \(key.rawValue).\(key.rawValue)) < abs($1.1.\(key.rawValue) - \(key.rawValue).\(key.rawValue)) })?.element ?? \(StylesheetManagerName).S.\(IconDefaults).\(key.rawValue)\n"
                            } else {
                                // e.g. availableStyles.contains(style) ? style : (availableStyles.count == 1 ? availableStyles.first! : StylesheetManager.S.IconDefaults.style)
                                generateString += "\(tab.swift)\(tab.swift)let \(propertyName): \(iconSymbolEnum + keyCapitalized) = \(AvailablePrefix + keyCapitalized + "s").contains(\(key.rawValue)) ? \(key.rawValue) : (\(AvailablePrefix + keyCapitalized + "s").count == 1 ? \(AvailablePrefix + keyCapitalized + "s").first! :  \(StylesheetManagerName).S.\(IconDefaults).\(key.rawValue))\n"

                            }
                        }
                        
                        // we need to extract any fixed string
                        var templateIconString: String = ""
                        var templateIconResolvedString: String = ""
                        let Separator = (symbolsAsset.separator ?? "")
                        for (_, templateIconInfo) in sortedIcons {
                            let iconResourceName = templateIconInfo.iconResourceName
                            templateIconInfo.variations.forEach { (key: IconSupportedKeys, variations: [IconFileName]) in
                                for variation in variations {
                                    if templateIconString.isEmpty {
                                        templateIconString = variation.filename
                                        templateIconResolvedString = templateIconString
                                    }
                                    templateIconResolvedString = templateIconResolvedString.replacingOccurrences(of: Separator + variation.variation, with: "")
                                }
                            }
                            templateIconResolvedString = templateIconResolvedString.replacingOccurrences(of: Separator + iconResourceName, with: "")
                            break
                        }
                        let fixedStringIndex = templateIconString.range(of: templateIconResolvedString)
                            
                        var resourceStringProperties = [String]()
                        symbolsAsset.format.forEach { (key: String, regex: String) in
                            if let keyInfo = keysSorted.first(where: { $0.key == IconSupportedKeys(rawValue: key) }) {
                                let propertyName = "safe" + keyInfo.key.rawValue.capitalized
                                if keyInfo.key.rawValue == IconNameKey {
                                    resourceStringProperties.append("\\(\(IconNameKey))")
                                } else {
                                    resourceStringProperties.append("\\(\(propertyName).\(ResourceString))")
                                }
                            } else if key == IconNameKey {
                                resourceStringProperties.append("\\(\(IconNameKey))")
                            }
                        }
                        var resourceStringExtended = resourceStringProperties.joined(separator: Separator)
                        if fixedStringIndex!.lowerBound == templateIconString.startIndex {
                            resourceStringExtended.insert(contentsOf: templateIconResolvedString + Separator, at: fixedStringIndex!.lowerBound)
                        } else {
                            resourceStringExtended.insert(contentsOf: Separator + templateIconResolvedString, at: fixedStringIndex!.lowerBound)
                        }
                        
                        generateString += "\(tab.swift)\(tab.swift)return \"\(resourceStringExtended)\"\n"
                        generateString += "\(tab.swift)}\n"
                        generateString += "\n"
                                                
                        // generate all available variations
                        keysSorted.forEach { (key: IconSupportedKeys, mapping: SymbolAsset.Icon.Mapping) in
                            let keyCapitalized = key.rawValue.capitalized
                            generateString += "\(tab.swift)private var \(AvailablePrefix + keyCapitalized + "s"): [\(iconSymbolEnum + keyCapitalized)] {\n"
                            
                            for (index, sortedIcon) in sortedIcons.enumerated() {
                                let iconName = sortedIcon.key
                                let iconInfo = sortedIcon.value
                                if (index % MaxConsecutiveEnumCases) == 0 {
                                    if index > 0 { generateString += "\(tab.swift)\(tab.swift)default: break }\n" }
                                    generateString += "\(tab.swift)\(tab.swift)switch self {\n"
                                }
                                var supportedValues = [String]()
                                if let supportedVariations = iconInfo.variations[key] {
                                    supportedVariations.forEach { supportedVariation in
                                        if let mapsTo = mapping.mapsTo,
                                            let index = mapping.values.firstIndex(of: supportedVariation.variation) {
                                            if let toAdd = Optional("." + mapsTo[index]), supportedValues.contains(toAdd) == false {
                                                supportedValues.append(toAdd)
                                            }
                                        } else if let toAdd = Optional("." + supportedVariation.variation), supportedValues.contains(toAdd) == false {
                                            supportedValues.append(toAdd)
                                        }
                                    }
                                }
                                generateString += "\(tab.swift)\(tab.swift)case .\(iconName): return [\(supportedValues.sorted().joined(separator: ", "))]\n"
                            }
                            
                            generateString += "\(tab.swift)\(tab.swift)case .\(EnumCaseNone): fatalError(\"Icon not supported\")\n"
                            generateString += "\(tab.swift)\(tab.swift)default: break\n"
                            generateString += "\(tab.swift)\(tab.swift)}\n"
                            generateString += "\(tab.swift)\(tab.swift)// Swift compiler cannot check this enum is exhaustive without breaking it up\n"
                            generateString += "\(tab.swift)\(tab.swift)// into smaller buckets\n"
                            generateString += "\(tab.swift)\(tab.swift)// https://bugs.swift.org/browse/SR-11533\n"
                            generateString += "\(tab.swift)\(tab.swift)fatalError(\"Icon not supported\")\n"
                            generateString += "\(tab.swift)}\n"
                            generateString += "\n"
                        }
                                                
                        // generate all filename
                        generateString += "\(tab.swift)public var \(IconNameKey): String {\n"
                    
                        for (index, sortedIcon) in sortedIcons.enumerated() {
                            let iconName = sortedIcon.key
                            let iconInfo = sortedIcon.value
                            if (index % MaxConsecutiveEnumCases) == 0 {
                                if index > 0 { generateString += "\(tab.swift)\(tab.swift)default: break }\n" }
                                generateString += "\(tab.swift)\(tab.swift)switch self {\n"
                            }
                            generateString += "\(tab.swift)\(tab.swift)case .\(iconName): return \"\(iconInfo.iconResourceName)\"\n"
                        }
                        generateString += "\(tab.swift)\(tab.swift)default: break\n"
                        generateString += "\(tab.swift)\(tab.swift)}\n"
                        generateString += "\(tab.swift)\(tab.swift)// Swift compiler cannot check this enum is exhaustive without breaking it up\n"
                        generateString += "\(tab.swift)\(tab.swift)// into smaller buckets\n"
                        generateString += "\(tab.swift)\(tab.swift)// https://bugs.swift.org/browse/SR-11533\n"
                        generateString += "\(tab.swift)\(tab.swift)fatalError(\"Icon not supported\")\n"
                        generateString += "\(tab.swift)}\n"
                        
                        generateString += "\(tab.swift)\n"
                        
                        let parametersAllCases = keysSorted
                            .compactMap({ "\($0.key.rawValue)s: [\(iconSymbolEnum + $0.key.rawValue.capitalized)]" })
                            .joined(separator: ", ")
                        
                        generateString += "\(tab.swift)public static var allCases: [(name: String, icon: \(NamespaceEnums).\(IconEnum), \(parametersAllCases))] {\n"
                        generateString += "\(tab.swift)  [\n"
                        
                        var allCases = [String]()
                        sortedIcons.forEach { (iconName: String, iconInfo: IconInfo) in
                            var parameters = [String]()
                            keysSorted.forEach { (key: IconSupportedKeys, value: SymbolAsset.Icon.Mapping) in
                                // An icon can have several variations (e.g. [12, 24], [filled, regular])
                                guard let variations = iconInfo.variations[key], variations.count > 0 else { return }
                                var resolvedVariations = [String]()
                                variations.forEach { variation in
                                    if let mapping = value.mapsTo, let index = value.values.firstIndex(of: variation.variation) {
                                        if let toAdd = Optional(".\(mapping[index])"), resolvedVariations.contains(toAdd) == false {
                                            resolvedVariations.append(toAdd)
                                        }
                                    } else if let toAdd = Optional(".\(variation.variation)"), resolvedVariations.contains(toAdd) == false {
                                        resolvedVariations.append(toAdd)
                                    }
                                }
                                parameters.append("\(key.rawValue)s: [\(resolvedVariations.sorted().joined(separator: ", "))]")
                            }
                            allCases.append("\(tab.swift)\(tab.swift)(name: \"\(iconName.titleCased)\", icon: .\(iconName), \(parameters.joined(separator: ", ")))")
                        }
                        generateString += "\(allCases.joined(separator: ",\n"))\n"
                        generateString += "\(tab.swift)  ]\n"
                        generateString += "\(tab.swift)}\n"
                        
                        generateString += "}\n"
                        
                        correspondentStyleInput.onAdditional = { name in
                            guard name == iconPath.lastComponentWithoutExtension else { return nil }
                            return (generateString, nil)
                        }
                    }
                    
                    iconFileContent += "\n"
                    iconFileContent += "IconMappings:\n"
                    keysSorted.filter({ (_, mapping) in mapping.mapsTo != nil }).forEach { (key: IconSupportedKeys, value: SymbolAsset.Icon.Mapping) in
                        var mapping = [String]()
                        for (index, map) in value.mapsTo!.enumerated() {
                            mapping.append("\(map): \(value.values[index])")
                        }
                        iconFileContent += "\(tab.yml)\(key.rawValue): [\(mapping.joined(separator: ", "))]\n"
                    }
                    
                    iconFileContent += "\n"
                    iconFileContent += "\(IconDefaults):\n"
                    symbolsAsset.icons.default.sorted(by: { $0.key.rawValue < $1.key.rawValue }).forEach { (defaultKey: IconSupportedKeys, defaultValue: String) in
                        guard let mapping = symbolsAsset.icons.keys.first(where: { (key, _) in key == defaultKey })?.value else { return }
                        let enumName = IconEnum + defaultKey.rawValue.capitalized
                        var value: String = defaultValue
                        if let maps = mapping.mapsTo, let indexValue = mapping.values.firstIndex(of: defaultValue) {
                            value = maps[indexValue]
                        }
                        
                        // key: Enum(case)
                        iconFileContent += "\(tab.yml)\(defaultKey.rawValue): \(StylesheetGrammar.Primitive.enum.rawValue)(\(enumName).\(value))\n"
                    }
                    
                    try iconPath.write(iconFileContent)
                    
                    // we create a new yml that has to imported from the main stylesheet
                    let stylePath = Path(correspondentStyleInput.url.path)
                    let existingYmlString: String = try stylePath.read(.utf8)
                    var newYmlString = existingYmlString
                    var importLine: String = ""
                    existingYmlString.enumerateLines { (line, stop) in
                        importLine = line
                        stop = true
                    }
                    let importToAdd = iconPath.lastComponent
                    if importLine.hasPrefix(StylesheetGrammar.import.rawValue) {
                        // other imports exist
                        var line: String = importLine.replacingOccurrences(of: StylesheetGrammar.import.rawValue, with: "")
                        line = line.replacingOccurrences(of: "[", with: "")
                        line = line.replacingOccurrences(of: "]", with: "")
                        line = line.trimmingCharacters(in: .whitespacesAndNewlines)
                        var existingImports = line.components(separatedBy: ",")
                        if existingImports.contains(importToAdd) == false {
                            existingImports.append(importToAdd)
                        }
                        newYmlString = existingYmlString.replacingOccurrences(of: importLine, with: "\(StylesheetGrammar.import.rawValue): [\(importToAdd)]")
                    } else {
                        newYmlString.insert(contentsOf: "\(StylesheetGrammar.import.rawValue): [\(importToAdd)]\n\n", at: existingYmlString.startIndex)
                    }
                    
                    if newYmlString != existingYmlString {
                        try stylePath.write(newYmlString)
                        logMessage(.info, "Stylesheet \(input.lastComponentWithoutExtension) generated.")
                    } else {
                        logMessage(.info, "Stylesheet \(input.lastComponentWithoutExtension) skipped (no changes).")
                    }
                    
                }
                 
            }
        }
        
        // Stylesheet generator
        
        let outputParsed = try prepareOutput(withOutput: output)
        var needsProjectChanges = outputParsed.needsProjectChanges
        let outputPath = outputParsed.outputPath
        let fileGroup = outputParsed.fileGroup
        let xcodeProject = outputParsed.xcodeProject
        
        let suffixName = extendedName != nil ? ".\(extendedName!)" : ""
        let destinations = names.map({ outputPath + Path($0+"\(suffixName).generated.swift") })
        
        let generator = try Generator(generatable: generables, importedUrl: importStyle?.baseStylePath.url)
        if outputPath.exists == false {
            try outputPath.mkpath()
        }
        var stylesheetsHasChanged = false
        let payloads = generator.generate()
        for i in 0..<payloads.count {
            let payload = payloads[i]
            let filename = payload.name
            let dest = outputPath + Path(filename+"\(suffixName).generated.swift")
            if generateBaseStyle == false && (dest.lastComponentWithoutExtension.replacingOccurrences(of: ".generated", with: "") == baseStylePath?.lastComponentWithoutExtension || payload.dependencyOfName == baseStylePath?.lastComponentWithoutExtension) {
                continue
            }
            logMessage(.info, "Generating stylesheet \(filename)...")
            
            guard dest.exists else {
                try dest.write(payload.string)
                stylesheetsHasChanged = true
                logMessage(.info, "Stylesheet \(filename) generated.")
                continue
            }
            
            let existing = try dest.read(.utf8)
            if existing != payload.string {
                stylesheetsHasChanged = true
                try dest.write(payload.string)
                logMessage(.info, "Stylesheet \(filename) generated.")
            } else {
                logMessage(.info, "Stylesheet \(filename) skipped (no changes).")
            }
        }
        
        if let linkTo = output.link, stylesheetsHasChanged {
            guard let target = xcodeProject?.pbxproj.targets(named: linkTo.target).first else {
                logMessage(.error, "Target -\(linkTo.target)- not found.")
                return
            }
            
            for destination in destinations where destination.lastComponentWithoutExtension.replacingOccurrences(of: ".generated", with: "") != baseStylePath?.lastComponentWithoutExtension && fileGroup!.file(named: destination.lastComponent) == nil {
                needsProjectChanges = true
                let file = try fileGroup!.addFile(at: destination, sourceTree: .absolute, sourceRoot: linkTo.project.parent())
                _ = try target.sourcesBuildPhase()?.add(file: file)
            }
            if needsProjectChanges {
                try xcodeProject!.pbxproj.write(path: XcodeProj.pbxprojPath(linkTo.project), override: true)
            }
        }
        
        // symbol changes
        var outputs = [Config.Entry.Output]()
        var inputPaths = [[Path]]()
        var shouldMoveInputs = [Bool]()
        var outputFilenames = [String]()
        if let symbolAssetOutput = symbolsAsset?.output, let symbolAssetInputs = Optional(symbolAssetsInputs) {
            outputs.append(symbolAssetOutput)
            inputPaths.append(symbolAssetInputs)
            shouldMoveInputs.append(true)
            outputFilenames.append(contentsOf: symbolsAsset?.names != nil ? Array(symbolsAsset!.names.values) : symbolAssetInputs.compactMap({ $0.lastComponent }))
        }
        
        if let symbolFontOutput = symbolsFont?.output, let symbolFontInputs = symbolsFont?.inputs {
            outputs.append(symbolFontOutput)
            inputPaths.append(symbolFontInputs)
            shouldMoveInputs.append(false)
            outputFilenames.append(contentsOf: symbolFontInputs.compactMap({ $0.lastComponent }))
        }
        
        for (index, output) in outputs.enumerated() {
            let shouldMoveInput = shouldMoveInputs[index]
            let symbolOutputParsed = try prepareOutput(withOutput: output)
            var symbolNeedsProjectChanges = symbolOutputParsed.needsProjectChanges
            let symbolOutputPath = symbolOutputParsed.outputPath
            let symbolFileGroup = symbolOutputParsed.fileGroup
            let symbolXcodeProject = symbolOutputParsed.xcodeProject
                
            guard let inputs = Optional(inputPaths[index]) else {
                logMessage(.error, "Missing inputs for the symbol font.")
                return
            }
                
            let symbolDestinations: [Path] = outputFilenames.map({ symbolOutputPath + $0 })
            if symbolOutputPath.exists == false {
                try symbolOutputPath.mkpath()
            }
            
            for (index, value) in inputs.enumerated() {
                if symbolDestinations[index].exists {
                    try symbolDestinations[index].delete()
                }
                
                if shouldMoveInput {
                    try value.move(symbolDestinations[index])
                } else {
                    try value.copy(symbolDestinations[index])
                }
            }
                
            if let plist = output.plist {
            
                let fontNames = inputs.map({ input -> String in
                    if let fontFolder = output.folderFontForPlist {
                        return fontFolder + input.lastComponent
                    } else {
                        return input.lastComponent
                    }
                })
                var plistData: [String : Any] = [:]
                let plistFileData = try plist.read()
                plistData = try PropertyListSerialization.propertyList(from: plistFileData, options: [], format: nil) as! [String : Any]
                var plistHasChanged = false
                if var existingFont = plistData["UIAppFonts"] as? [String] {
                    fontNames.forEach { (fontName) in
                        if existingFont.contains(fontName) == false {
                            existingFont.append(fontName)
                            plistHasChanged = true
                        }
                    }
                    plistData["UIAppFonts"] = existingFont
                } else {
                    plistData["UIAppFonts"] = fontNames
                    plistHasChanged = true
                }
                
                if plistHasChanged {
                    (plistData as NSDictionary).write(toFile: plist.string, atomically: false)
                }
            }
                
            guard let linkTo = output.link else { return }
            guard let target = symbolXcodeProject?.pbxproj.targets(named: linkTo.target).first else {
                logMessage(.error, "Target -\(linkTo.target)- not found.")
                return
            }
            for destination in symbolDestinations where symbolFileGroup!.file(named: destination.lastComponent) == nil {
                symbolNeedsProjectChanges = true
                let file = try symbolFileGroup!.addFile(at: destination, sourceTree: .absolute, sourceRoot: linkTo.project.parent())
                _ = try target.resourcesBuildPhase()?.add(file: file)
            }
            if symbolNeedsProjectChanges {
                try symbolXcodeProject!.pbxproj.write(path: XcodeProj.pbxprojPath(linkTo.project), override: true)
            }
        }
    }
}

func prepareOutput(withOutput output: Config.Entry.Output) throws -> (needsProjectChanges: Bool, outputPath: Path, fileGroup: PBXGroup?, xcodeProject: XcodeProj?) {
    
    var needsProjectChanges = false
    var outputPath: Path
    var fileGroup: PBXGroup?
    var xcodeProject: XcodeProj?
    
    if let linkTo = output.link {
        xcodeProject = try XcodeProj(path: linkTo.project)
        let sourceRoot = linkTo.project.parent()
        let rootGroup = try xcodeProject!.pbxproj.rootGroup()!
        if let groupName = linkTo.group {            
            var lastExistingGroup: PBXGroup?
            var groupNameToAppend: String?
            let existingGroup = groupName.components(separatedBy: "/").reduce(rootGroup) { (group, name) -> PBXGroup? in
                guard let group = group?.children.first(where: { (element) -> Bool in
                    element.path == name || element.name == name
                }) as? PBXGroup else {
                    groupNameToAppend = name
                    return nil
                }
                lastExistingGroup = group
                return group
            }
            
            if let existingGroup = existingGroup {
                fileGroup = existingGroup
            } else {
                var groupNameToAdd = groupName
                var groupToBeAddedTo = rootGroup
                if let lastExistingGroup = lastExistingGroup, let groupNameToAppend = groupNameToAppend {
                    groupNameToAdd = groupNameToAppend
                    groupToBeAddedTo = lastExistingGroup
                }
                
                let addedGroup = try groupToBeAddedTo.addGroup(named: groupNameToAdd).last!
                let addedGroupPath = try addedGroup.fullPath(sourceRoot: sourceRoot)!.absolute()
                if addedGroupPath.exists == false {
                    try addedGroupPath.mkpath()
                }
                fileGroup = addedGroup
                needsProjectChanges = true
            }
            
        } else {
            fileGroup = rootGroup
        }
        outputPath = try fileGroup!.fullPath(sourceRoot: sourceRoot)!.absolute()
    } else {
        outputPath = output.path!
    }
    
    return (needsProjectChanges, outputPath, fileGroup, xcodeProject)
}

func checkPath(type: String, assertion: @escaping (Path) -> Bool) -> ((Path) throws -> Path) {
    return { (path: Path) throws -> Path in
        guard assertion(path) else { throw ArgumentError.invalidType(value: path.description, type: type, argument: nil) }
        return path
    }
}

typealias PathValidator = ([Path]) throws -> ([Path])
let pathsExist: PathValidator = { paths in try paths.map(checkPath(type: "path") { $0.exists }) }
let filesExist: PathValidator = { paths in try paths.map(checkPath(type: "file") { $0.isFile }) }
let dirsExist: PathValidator = { paths in try paths.map(checkPath(type: "directory") { $0.isDirectory }) }

// MARK: Path as Input Argument

extension Path: ArgumentConvertible {
    public init(parser: ArgumentParser) throws {
        guard let path = parser.shift() else {
            throw ArgumentError.missingValue(argument: nil)
        }
        self = Path(path)
    }
}

private let configOption = Option<Path>(
    "config",
    default: "sgen.yml",
    flag: "c",
    description: "Path to the configuration file to use",
    validator: checkPath(type: "config file") { $0.isFile }
)

let configRunCommand = command(
    configOption,
    Flag("verbose", default: false, flag: "v", description: "Print each command being executed")
) { file, verbose in
    do {
        try ErrorPrettifier.execute {

            let config = try Config(file: file)
            try file.parent().chdir {
                if verbose {
                    logMessage(.info, "Executing configuration file \(file)")
                }
                try config.command.checkPaths()
                try config.command.run()
            }
        }
    } catch let error as Config.Error {
        logMessage(.error, error)
    }
}

let main = Group {
    $0.noCommand = { path, group, parser in
        if parser.hasOption("help") {
            logMessage(.info, "Note: If you invoke sgen with no subcommand, it will default to `sgen config run`\n")
            throw GroupError.noCommand(path, group)
        } else {
            try configRunCommand.run(parser)
        }
    }
    $0.group("config", "manage and run configuration files") {
        $0.addCommand("run", "Run commands listed in the configuration file", configRunCommand)
    }
}

#if os(macOS)
import AppKit

if !inUnitTests {
    main.run(
        """
        SGen v\(version)
        """
    )
} else {
    //! Need to run something for tests to work
    final class TestApplicationController: NSObject, NSApplicationDelegate {
        let window = NSWindow()
        
        func applicationDidFinishLaunching(aNotification: NSNotification) {
            window.setFrame(CGRect(x: 0, y: 0, width: 0, height: 0), display: false)
            window.makeKeyAndOrderFront(self)
        }
        
        func applicationWillTerminate(aNotification: NSNotification) {
        }
        
    }
    
    autoreleasepool { () -> Void in
        let app =   NSApplication.shared
        let controller =   TestApplicationController()
        
        app.delegate   = controller
        app.run()
    }
}
#endif
