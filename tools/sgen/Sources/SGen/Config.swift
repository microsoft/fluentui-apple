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
            case baseStylePath
            case inputDir
            case inputs
            case names
            case symbolsFont
            case output
        }
        
        var importStyle: Config.Entry.Import?
        var objc: Bool = false
        var generateBaseStyle: Bool = false
        var generateAppearanceProxyProtocol: Bool = true
        var extendedName: String?
        var namespace: String?
        var baseStylePath: Path?
        var inputDir: Path?
        var inputs: [Path]
        var names: [String]?
        var symbolsFont: Config.Entry.Font?
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
        
        struct Font {
            
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
        var cmd: Config.Entry
        do {
            cmd = try Config.Entry(yaml: config)
        } catch let error as Config.Error {
            // Prefix the name of the command for a better error message
            throw error.withKeyPrefixed(by: Command)
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
        
        if let font = Optional(yaml[.string(Keys.symbolsFont.rawValue)]), font != .null {
            do {
                let inputs = self.inputs
                let names = self.names ?? inputs.map({ $0.lastComponentWithoutExtension })
                self.symbolsFont = try Config.Entry.Font(yaml: font, names: names)
            } catch let error as Config.Error {
                throw error.withKeyPrefixed(by: Keys.symbolsFont.rawValue)
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

// MARK: Config.Entry.Font extension

extension Config.Entry.Font {
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

// MARK: Config.Entry.LinkTo

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
