//
//  Config.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation
import PathKit
import Yaml
import xcodeproj

let Command = "stylesheet"

// MARK: Config

struct Config {
    
    let command: Config.Entry
    
    struct Entry {
        enum Keys: String, CodingKey {
            case `import`
            case objc
            case extendedName
            case namespace
            case generateBaseStyle
            case generateAppearanceProxyProtocol
            case generateFilePerAppearanceProxy
            case baseStylePath
            case inputDir
            case inputs
            case names
            case symbolsFont
            case symbolsAsset
            case typography
            case output
        }
        
        var importStyle: Config.Entry.Import?
        var objc: Bool = false
        var generateBaseStyle: Bool = false
        var generateAppearanceProxyProtocol: Bool = true
        var generateFilePerAppearanceProxy: Bool = false
        var extendedName: String?
        var namespace: String?
        var baseStylePath: Path?
        var inputDir: Path?
        var inputs: [Path]
        var names: [String]?
        var symbolsFont: Config.Entry.SymbolFont?
        var symbolsAsset: Config.Entry.SymbolAsset?
        var typography: Config.Entry.Typography?
        var output: Config.Entry.Output
        
        struct Import {
            enum Keys: String, CodingKey {
                case name
                case baseStylePath
                case styles
            }
            
            var name: String
            var baseStylePath: Path
            var styles: [String]?
        }
        
        struct SymbolFont {
            
            public enum SupportedWeight: String, CodingKey {
                case light
                case regular
            }
            
            enum Keys: String, CodingKey {
                case inputDir
                case inputs
                case output
                case names
            }
            var inputDir: Path?
            var inputs: [Path]?
            var output: Output?
            let names: [String: [SupportedWeight: String]]
        }
        
        struct SymbolAsset {
            enum Keys: String, CodingKey {
                case inputDir
                case inputs
                case icons
                case format
                case output
                case icon = "Icon"
                case separator
                case names
            }
            
            struct Icon {
                enum Keys: String, CodingKey {
                    case keys
                    case `default`
                    case version
                    case names
                }
                
                struct Mapping {
                    enum Keys: String, CodingKey {
                        case values
                        case mapsTo
                    }
                    var values: [String]
                    var mapsTo: [String]?
                    
                    var isNumber: Bool {
                        return mapsTo != nil && values.compactMap({ Double($0) }).count > 0
                    }
                }
                
                let keys: [IconSupportedKeys: Mapping]
                let `default`: [IconSupportedKeys: String]
                let version: [IconSupportedKeys: [String]]
                var names: [String: [IconSupportedKeys: [String]]]
            }
            
            typealias Format = (key: String, regex: String)
            
            var inputDir: Path?
            var inputs: [Path]
            let icons: Icon
            var format: [Format]
            var separator: String?
            var output: Output?
            let names: [String: String]
        }
        
        struct Typography {
            
            public enum SupportedStyleKeys: String, CodingKey {
                case defaultPointSize
                case maximumPointSize
                case mapsTo
                case version
            }
            
            enum Keys: String, CodingKey {
                case styles
            }
            let styles: [String: [SupportedStyleKeys: String]]
        }
        
        struct Output {
            enum Keys: String, CodingKey {
                case path
                case link
                case plist
                case folderFontForPlist
            }
            
            struct LinkTo {
                enum Keys: String, CodingKey {
                    case project
                    case target
                    case group
                }
                
                let project: Path
                let target: String
                var group: String?
            }
        
            var path: Path?
            var link: LinkTo?
            var plist: Path?
            var folderFontForPlist: String?
        }
    }
}

extension Config {
    
    init(file: Path, env: [String: String] = ProcessInfo.processInfo.environment) throws {
        if !file.exists {
            throw Config.Error.pathNotFound(path: file)
        }
        let anyConfig = try? Yaml.load(file.read())
        guard let config = anyConfig else {
            throw Config.Error.wrongType(key: nil, expected: "Dictionary", got: type(of: anyConfig))
        }
        var cmd: Config.Entry!
        try file.parent().chdir {
            do {
                cmd = try Config.Entry(yaml: config)
            } catch let error as Config.Error {
                // Prefix the name of the command for a better error message
                throw error.withKeyPrefixed(by: Command)
            }
        }
        self.command = cmd
    }
}

// MARK: Config.Error

extension Config {
    enum Error: Swift.Error, CustomStringConvertible {
        case missingEntry(key: String)
        case wrongType(key: String?, expected: String, got: Any.Type)
        case pathNotFound(path: Path)
        
        var description: String {
            switch self {
            case .missingEntry(let key):
                return "Missing entry for key \(key)."
            case .wrongType(let key, let expected, let got):
                return "Wrong type for key \(key ?? "root"): expected \(expected), got \(got)."
            case .pathNotFound(let path):
                return "File \(path) not found."
            }
        }
        
        func withKeyPrefixed(by prefix: String) -> Config.Error {
            switch self {
            case .missingEntry(let key):
                return Config.Error.missingEntry(key: "\(prefix).\(key)")
            case .wrongType(let key, let expected, let got):
                let fullKey = [prefix, key].compactMap({ $0 }).joined(separator: ".")
                return Config.Error.wrongType(key: fullKey, expected: expected, got: got)
            default:
                return self
            }
        }
    }
}

// MARK: Config.Entry extension

extension Config.Entry {
    init(yaml: Yaml) throws {
        if let importStruct = Optional(yaml[.string(Keys.import.rawValue)]), importStruct != .null  {
            do {
                self.importStyle = try Config.Entry.Import(yaml: importStruct)
            } catch let error as Config.Error {
                throw error.withKeyPrefixed(by: Keys.import.rawValue)
            }
        }
        
        self.objc = yaml[.string(Keys.objc.rawValue)].bool ?? false
        self.generateBaseStyle = yaml[.string(Keys.generateBaseStyle.rawValue)].bool ?? false
        self.generateAppearanceProxyProtocol = yaml[.string(Keys.generateAppearanceProxyProtocol.rawValue)].bool ?? true
        self.generateFilePerAppearanceProxy = yaml[.string(Keys.generateFilePerAppearanceProxy.rawValue)].bool ?? false
        self.extendedName = yaml[.string(Keys.extendedName.rawValue)].string
        self.namespace = yaml[.string(Keys.namespace.rawValue)].string
        if let baseStylePath = Optional(yaml[.string(Keys.baseStylePath.rawValue)])?.string {
            self.baseStylePath = Path(baseStylePath)
        }

        self.inputDir = yaml[.string(Keys.inputDir.rawValue)].string.map { Path($0) }
        
        if let inputs = Optional(yaml[.string(Keys.inputs.rawValue)]), inputs != .null {
            var paths: [Path]
            switch inputs {
            case .array(let array):
                paths = array.map({ Path($0.string!) })
            case .string(let input):
                paths = [Path(input)]
            default:
                throw Config.Error.missingEntry(key: Keys.inputs.rawValue)
            }
            if let inputDir = inputDir {
                self.inputs = paths.map { $0.isRelative ? inputDir + $0 : $0 }
            } else {
                self.inputs = paths
            }
        } else {
            throw Config.Error.missingEntry(key: Keys.inputs.rawValue)
        }

        if let names = Optional(yaml[.string(Keys.names.rawValue)]) {
            switch names {
            case .array(let array):
                self.names = array.map({ $0.string! })
            case .string(let input):
                self.names = [input]
            default:
                break
            }
        }
        
        if let symbolFont = Optional(yaml[.string(Keys.symbolsFont.rawValue)]), symbolFont != .null {
            do {
                let inputs = self.inputs
                var names = self.names
                if names == nil {
                    names = [String]()
                    if let baseStyleName = baseStylePath?.lastComponentWithoutExtension {
                        names?.append(baseStyleName)
                    }
                    names?.append(contentsOf: inputs.map({ $0.lastComponentWithoutExtension }))
                }
                self.symbolsFont = try Config.Entry.SymbolFont(yaml: symbolFont, names: names!)
            } catch let error as Config.Error {
                throw error.withKeyPrefixed(by: Keys.symbolsFont.rawValue)
            }
        }
        
        if let symbolAsset = Optional(yaml[.string(Keys.symbolsAsset.rawValue)]), symbolAsset != .null {
            do {
                let inputs = self.inputs
                var names = self.names
                if names == nil {
                    names = [String]()
                    if let baseStyleName = baseStylePath?.lastComponentWithoutExtension {
                        names?.append(baseStyleName)
                    }
                    names?.append(contentsOf: inputs.map({ $0.lastComponentWithoutExtension }))
                }
                self.symbolsAsset = try Config.Entry.SymbolAsset(yaml: symbolAsset, names: names!)
            } catch let error as Config.Error {
                throw error.withKeyPrefixed(by: Keys.symbolsAsset.rawValue)
            }
        }
        
        if let typography = Optional(yaml[.string(Keys.typography.rawValue)]), typography != .null {
            do {
                self.typography = try Config.Entry.Typography(yaml: typography)
            } catch let error as Config.Error {
                throw error.withKeyPrefixed(by: Keys.typography.rawValue)
            }
        }

        if let output = Optional(yaml[.string(Keys.output.rawValue)]) {
            do {
                self.output = try Config.Entry.Output(yaml: output)
            } catch let error as Config.Error {
                throw error.withKeyPrefixed(by: Keys.output.rawValue)
            }
        } else {
            throw Config.Error.missingEntry(key: Keys.output.rawValue)
        }
    }
}

// MARK: Config.Entry.Import extension

extension Config.Entry.Import {
    init(yaml: Yaml) throws {
        guard let name = Optional(yaml[.string(Keys.name.rawValue)])?.string else {
            throw Config.Error.missingEntry(key: Keys.name.rawValue)
        }
        self.name = name
        
        guard let baseStylePath = Optional(yaml[.string(Keys.baseStylePath.rawValue)])?.string else {
            throw Config.Error.missingEntry(key: Keys.baseStylePath.rawValue)
        }
        self.baseStylePath = Path(baseStylePath)
        
        if let styles = Optional(yaml[.string(Keys.styles.rawValue)]) {
            switch styles {
            case .array(let array):
                self.styles = array.map({ $0.string! })
            case .string(let style):
                self.styles = [style]
            default:
                break
            }
        }
    }
}

// MARK: Config.Entry.SymbolFont extension

extension Config.Entry.SymbolFont {
    init(yaml: Yaml, names: [String]) throws {
        if let output = Optional(yaml[.string(Keys.output.rawValue)]), output != .null {
            self.output = try Config.Entry.Output(yaml: output)
        }
        
        if let fontNames = Optional(yaml[.string(Keys.names.rawValue)]) {
            switch fontNames {
            case .array(let array):
                
                let arrayOfFontNames = try array.enumerated().map { (offset: Int, element: Yaml) -> [String: [SupportedWeight: String]] in
                    switch element {
                    case .dictionary(let dict):
                        
                        var arrayOfResult = [String: [SupportedWeight: String]]()
                        try dict.forEach({ (key: Yaml, value: Yaml) in
                            switch value {
                            case .dictionary(let innerDict):
                                
                                arrayOfResult[key.string!] = Dictionary(uniqueKeysWithValues: innerDict.map { (key, value) in (SupportedWeight(rawValue: key.string!)!, value.string!) })
                            case .string(let innerString):
                                if arrayOfResult[names[offset]] == nil {
                                    arrayOfResult[names[offset]] = [SupportedWeight: String]()
                                }
                                arrayOfResult[names[offset]]![SupportedWeight(rawValue: key.string!)!] = innerString
                            default:
                                throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: value))
                            }
                        })
                        return arrayOfResult
                    case .string(let string):
                        return [names[offset]: [.light: string, .regular: string]]
                    default:
                        throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: element))
                    }
                }
                self.names = Dictionary(uniqueKeysWithValues: arrayOfFontNames.flatMap({ $0 }))

            case .string(let input):
                self.names = ["\(names.first!)": [.light: input, .regular: input]]
            default:
                throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: names))
            }
        } else {
            throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: names))
        }
        
        self.inputDir = yaml[.string(Keys.inputDir.rawValue)].string.map { Path($0) }
        
        if let inputs = Optional(yaml[.string(Keys.inputs.rawValue)]), inputs != .null {
            var paths: [Path]
            switch inputs {
            case .array(let array):
                paths = array.map({ Path($0.string!) })
            case .string(let input):
                paths = [Path(input)]
            default:
                throw Config.Error.missingEntry(key: Keys.inputs.rawValue)
            }
            if let inputDir = inputDir {
                self.inputs = paths.map { $0.isRelative ? inputDir + $0 : $0 }
            } else {
                self.inputs = paths
            }
        }
        
        if inputs == nil && output != nil {
            throw Config.Error.missingEntry(key: Keys.inputs.rawValue)
        }
        if inputs != nil && output == nil {
            throw Config.Error.missingEntry(key: Keys.output.rawValue)
        }
    }
}

// MARK: Config.Entry.SymbolAsset extension

extension Config.Entry.SymbolAsset {
    init(yaml: Yaml, names: [String]) throws {
        guard let icons = Optional(yaml[.string(Keys.icons.rawValue)])?.string else {
            throw Config.Error.missingEntry(key: Keys.icons.rawValue)
        }
        
        // Attemps to load the file at the given url.
        var iconsString = ""
        do {
            iconsString = try String(contentsOf: Path(icons).url)
        } catch {
            throw GeneratorError.fileDoesNotExist(error: "File \(icons) not found.")
        }
        guard let iconYaml = try? Yaml.load(iconsString) else {
            throw GeneratorError.malformedYaml(error: "Unable to load Yaml file. \(iconsString)")
        }

        self.icons = try Icon(yaml: iconYaml[.string(Keys.icon.rawValue)])
        
        if let output = Optional(yaml[.string(Keys.output.rawValue)]), output != .null {
            self.output = try Config.Entry.Output(yaml: output)
        }

        self.inputDir = yaml[.string(Keys.inputDir.rawValue)].string.map { Path($0) }
        
        guard let inputs = Optional(yaml[.string(Keys.inputs.rawValue)]), inputs != .null else {
            throw Config.Error.missingEntry(key: Keys.inputs.rawValue)
        }
        
        var paths: [Path]
        switch inputs {
        case .array(let array):
            paths = array.map({ Path($0.string!) })
        case .string(let input):
            paths = [Path(input)]
        default:
            throw Config.Error.missingEntry(key: Keys.inputs.rawValue)
        }
        if let inputDir = inputDir {
            self.inputs = paths.map { $0.isRelative ? inputDir + $0 : $0 }
        } else {
            self.inputs = paths
        }
        
        guard let format = Optional(yaml[.string(Keys.format.rawValue)]), format != .null else {
            throw Config.Error.missingEntry(key: Keys.format.rawValue)
        }
        
        var separator: String?
        switch format {
        case .array(let array):
            let arrayOfGrammar = try array.enumerated().map { (offset: Int, element: Yaml) -> [Format] in
                var arrayOfResult = [Format]()
                switch element {
                case .dictionary(let dict):
                    dict.forEach({ (key: Yaml, value: Yaml) in
                        if let separatorKey = key.string, separatorKey == Keys.separator.rawValue {
                            separator = value.string
                        } else {
                            arrayOfResult.append((key.string!, value.string!))
                        }
                    })
                    return arrayOfResult
                default:
                    throw Config.Error.wrongType(key: Keys.format.rawValue, expected: "Dictionary or String", got: type(of: element))
                }
            }
            self.format = arrayOfGrammar.flatMap({ $0 })
            
            break
        default:
            throw Config.Error.wrongType(key: Keys.format.rawValue, expected: "Dictionary or String", got: type(of: yaml))
        }
        
        if let assetsNames = Optional(yaml[.string(Keys.names.rawValue)]) {
            switch assetsNames {
            case .array(let array):
                
                let arrayOfFontNames = try array.enumerated().map { (offset: Int, element: Yaml) -> [String: String] in
                    switch element {
                    case .dictionary(let dict):
                        
                        var arrayOfResult = [String: String]()
                        try dict.forEach({ (key: Yaml, value: Yaml) in
                            if let string = value.string {
                                arrayOfResult[names[offset]] = string
                            } else {
                                throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "String", got: type(of: value))
                            }
                        })
                        return arrayOfResult
                    case .string(let string):
                        return [names[offset]: string]
                    default:
                        throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: element))
                    }
                }
                self.names = Dictionary(uniqueKeysWithValues: arrayOfFontNames.flatMap({ $0 }))

            case .string(let input):
                self.names = ["\(names.first!)": input]
            default:
                throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: names))
            }
        } else {
            throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: names))
        }
        
        self.separator = separator
        
        if inputs != nil && output == nil {
            throw Config.Error.missingEntry(key: Keys.output.rawValue)
        }
    }
}

// MARK: Config.Entry.Typography extension

extension Config.Entry.Typography {
    
    init(yaml: Yaml) throws {
        
        if let styles = Optional(yaml[.string(Keys.styles.rawValue)]), styles != .null {
            switch styles {
            case .array(let array):
                
                let arrayOfStyles = try array.enumerated().map { (offset: Int, element: Yaml) -> [String: [SupportedStyleKeys: String]] in
                    switch element {
                    case .dictionary(let dict):
                        
                        var arrayOfResult = [String: [SupportedStyleKeys: String]]()
                        try dict.forEach({ (key: Yaml, value: Yaml) in
                            switch value {
                            case .dictionary(let innerDict):
                                arrayOfResult[key.string!] = Dictionary(uniqueKeysWithValues: innerDict.map { (key, value) in
                                    let stringValue: String
                                    if let intValue = value.int {
                                        stringValue = String(intValue)
                                    } else if let doubleValue = value.double {
                                        stringValue = String(doubleValue)
                                    } else {
                                        stringValue = value.string!
                                    }
                                    return (SupportedStyleKeys(rawValue: key.string!)!, stringValue)
                                })
                            default:
                                throw Config.Error.wrongType(key: Keys.styles.rawValue, expected: "Dictionary or String", got: type(of: value))
                            }
                        })
                        return arrayOfResult
                    default:
                        throw Config.Error.wrongType(key: Keys.styles.rawValue, expected: "Dictionary or String", got: type(of: element))
                    }
                }
                self.styles = Dictionary(uniqueKeysWithValues: arrayOfStyles.flatMap({ $0 }))
                
                break
            default:
                throw Config.Error.wrongType(key: Keys.styles.rawValue, expected: "Dictionary or String", got: type(of: yaml))
            }
        } else {
            throw Config.Error.wrongType(key: Keys.styles.rawValue, expected: "Dictionary or String", got: type(of: yaml))
        }
    }
}

// MARK: Config.Entry.Output extension

extension Config.Entry.Output {
    init(yaml: Yaml) throws {
        if let path = Optional(yaml[.string(Keys.path.rawValue)])?.string {
            self.path = Path(path)
        }
        
        if let linkTo = Optional(yaml[.string(Keys.link.rawValue)]), linkTo != .null {
            self.link = try Config.Entry.Output.LinkTo(yaml: linkTo)
        }
        
        if self.path == nil && self.link?.project == nil {
            throw Config.Error.missingEntry(key: Keys.path.rawValue)
        }
        
        if let plist = Optional(yaml[.string(Keys.plist.rawValue)])?.string {
            self.plist = Path(plist)
        }
        self.folderFontForPlist = yaml[.string(Keys.folderFontForPlist.rawValue)].string
        if self.folderFontForPlist?.hasPrefix("/") == true { self.folderFontForPlist?.removeFirst() }
    }
}

// MARK: Config.Entry.Output.LinkTo

extension Config.Entry.Output.LinkTo {
    init(yaml: Yaml) throws {
        guard let project = Optional(yaml[.string(Keys.project.rawValue)])?.string else {
            throw Config.Error.missingEntry(key: Keys.project.rawValue)
        }
        guard let target = Optional(yaml[.string(Keys.target.rawValue)])?.string else {
            throw Config.Error.missingEntry(key: Keys.target.rawValue)
        }
        self.project = Path(project)
        self.target = target
        self.group = yaml[.string(Keys.group.rawValue)].string
        if self.group?.hasSuffix("/") == true { self.group?.removeLast() }
    }
}

// MARK: Config.Entry.SymbolAsset.Icon.Mapping

extension Config.Entry.SymbolAsset.Icon.Mapping {
    
    init(yaml: Yaml) throws {
        guard let values = yaml[.string(Keys.values.rawValue)].array else {
            throw Config.Error.missingEntry(key: Keys.values.rawValue)
        }
        self.values = values.compactMap({ value in
            let valueString: String
            if let valueInt = value.int {
                valueString = String(valueInt)
            } else {
                valueString = value.string!
            }
            return valueString
        })
        
        if let values = yaml[.string(Keys.mapsTo.rawValue)].array {
            self.mapsTo = values.compactMap({ value in
                let valueString: String
                if let valueInt = value.int {
                    valueString = String(valueInt)
                } else {
                    valueString = value.string!
                }
                return valueString
            })
        }
    }
}

// MARK: Config.Entry.SymbolAsset.Icon

extension Config.Entry.SymbolAsset.Icon {

    init(yaml: Yaml) throws {
        
        func string(_ yml: Yaml) -> String? {
            let valueString: String?
            if let int = yml.int {
                valueString = String(int)
            } else {
                valueString = yml.string
            }
            return valueString
        }
        
        guard let icons = Optional(yaml[.string(Keys.names.rawValue)])?.array else {
            throw Config.Error.missingEntry(key: Keys.names.rawValue)
        }
            
        let arrayOfIcons = try icons.enumerated().map { (offset: Int, element: Yaml) -> [String: [IconSupportedKeys: [String]]] in
            switch element {
            case .dictionary(let dict):
                
                var arrayOfResult = [String: [IconSupportedKeys: [String]]]()
                try dict.forEach({ (key: Yaml, value: Yaml) in
                    switch value {
                    case .dictionary(let innerDict):
                        arrayOfResult[key.string!] = Dictionary(uniqueKeysWithValues: innerDict.map { (key, value) in
                            let array: [String]
                            if let valueArray = value.array {
                                array = valueArray.compactMap({ string($0) })
                            } else {
                                array = [string(value)!]
                            }
                            return (IconSupportedKeys(rawValue: key.string!)!, array)
                        })
                    default:
                        throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: value))
                    }
                })
                return arrayOfResult
            case .string(let string):
                return [string: [IconSupportedKeys: [String]]()]
            default:
                throw Config.Error.wrongType(key: Keys.names.rawValue, expected: "Dictionary or String", got: type(of: element))
            }
        }
        self.names = Dictionary(uniqueKeysWithValues: arrayOfIcons.flatMap({ $0 }))
        
        guard let keysArray = Optional(yaml[.string(Keys.keys.rawValue)])?.array else {
            throw Config.Error.missingEntry(key: Keys.keys.rawValue)
        }
        
        let arrayOfKeys = try keysArray.enumerated().map { (offset: Int, element: Yaml) -> [IconSupportedKeys: Mapping] in
            var arrayOfResult = [IconSupportedKeys: Mapping]()
            switch element {
            case .dictionary(let dict):
                try dict.forEach({ (key: Yaml, value: Yaml) in
                    arrayOfResult[IconSupportedKeys(rawValue: key.string!)!] = try Mapping(yaml: value)
                })
                return arrayOfResult
            default:
                throw Config.Error.wrongType(key: Keys.keys.rawValue, expected: "Dictionary", got: type(of: element))
            }
        }
        self.keys = Dictionary(uniqueKeysWithValues: arrayOfKeys.flatMap({ $0 }))
        
        guard let `default` = yaml[.string(Keys.default.rawValue)].dictionary else {
            throw Config.Error.missingEntry(key: Keys.default.rawValue)
        }
        self.default = Dictionary(uniqueKeysWithValues: `default`.map { (key, value) in
            let valueString: String
            if let int = value.int {
                valueString = String(int)
            } else {
                valueString = value.string!
            }
            return (IconSupportedKeys(rawValue: key.string!)!, valueString)
        })
        
        guard let version = Optional(yaml[.string(Keys.version.rawValue)])?.dictionary else {
            throw Config.Error.missingEntry(key: Keys.version.rawValue)
        }
        self.version = Dictionary(uniqueKeysWithValues: version.map { (key, value) in
            let array: [String]
            if let valueArray = value.array {
                array = valueArray.compactMap({ string($0) })
            } else {
                array = [string(value)!]
            }
            return (IconSupportedKeys(rawValue: key.string!)!, array)
        })
    }
}
