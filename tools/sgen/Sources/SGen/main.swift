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
        
        if let extendedName = extendedName, let importStyle = importStyle {
            Generator.Config.namespace = namespace
            //we're generating an extended stylesheet
            let baseStylesheetManagerName = Generator.Config.stylesheetManagerName
            Generator.Config.stylesheetManagerName = extendedName + Generator.Config.stylesheetManagerName
            Generator.Config.importStylesheetManagerName = baseStylesheetManagerName
            Generator.Config.importFrameworks = importStyle.name
            Generator.Config.importStylesheetNames = [importStyle.baseStylePath.lastComponentWithoutExtension] + (importStyle.styles ?? [])
        }
        
        let urls = (baseStylePath != nil ? [baseStylePath!.url] : []) + inputs.map({ $0.url })
        let baseStyleName = baseStylePath != nil ? ":\(baseStylePath!.lastComponentWithoutExtension)" : ""
        var names: [String] = (baseStylePath != nil ? [baseStylePath!.lastComponentWithoutExtension] : []) + (self.names?.compactMap({ "\($0)\(baseStyleName)" }) ?? inputs.compactMap({ "\($0.lastComponentWithoutExtension)\(baseStyleName)" }))
        names.forEach({ Generator.Config.stylesheetNames.append($0) })
        names = names.map({ $0.replacingOccurrences(of: baseStyleName, with: "") })
        
        Generator.Config.stylesheetNames.forEach { (name) in
            let normalizedName = name.contains(":") ? name.replacingOccurrences(of: baseStyleName, with: "") : name
            if let fontSymbol = symbolsFont?.names[normalizedName] {
                Generator.Config.fontNames.append(Dictionary(uniqueKeysWithValues: fontSymbol.map { (key, value) in (IconicWeight(rawValue: key.rawValue)!, value) }))
            } else {
                Generator.Config.fontNames.append([IconicWeight: String]())
            }
        }
        
        let outputParsed = try prepareOutput(withOutput: output)
        var needsProjectChanges = outputParsed.needsProjectChanges
        let outputPath = outputParsed.outputPath
        let fileGroup = outputParsed.fileGroup
        let xcodeProject = outputParsed.xcodeProject
        
        let suffixName = extendedName != nil ? ".\(extendedName!)" : ""
        let destinations = names.map({ outputPath + Path($0+"\(suffixName).generated.swift") })
        
        let generator = try Generator(urls: urls, importedUrl: importStyle?.baseStylePath.url)
        if outputPath.exists == false {
            try outputPath.mkpath()
        }
        var stylesheetsHasChanged = false
        let payloads = generator.generate()
        for i in 0..<payloads.count {
            let payload = payloads[i]
            let dest = destinations[i]
            if dest.lastComponentWithoutExtension.replacingOccurrences(of: ".generated", with: "") == baseStylePath?.lastComponentWithoutExtension && generateBaseStyle == false {
                continue
            }
            logMessage(.info, "Generating stylesheet \(names[i])...")
            sleep(1)
            
            guard dest.exists else {
                try dest.write(payload)
                stylesheetsHasChanged = true
                logMessage(.info, "Stylesheet \(names[i]) generated.")
                continue
            }
            
            let existing = try dest.read(.utf8)
            if existing != payload {
                stylesheetsHasChanged = true
                try dest.write(payload)
                logMessage(.info, "Stylesheet \(names[i]) generated.")
            } else {
                logMessage(.info, "Stylesheet \(names[i]) skipped (no changes).")
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
        
        // font changes
        guard let output = symbolsFont?.output else { return }
        
        let fontOutputParsed = try prepareOutput(withOutput: output)
        var fontNeedsProjectChanges = fontOutputParsed.needsProjectChanges
        let fontOutputPath = fontOutputParsed.outputPath
        let fontFileGroup = fontOutputParsed.fileGroup
        let fontXcodeProject = fontOutputParsed.xcodeProject
        
        guard let inputs = symbolsFont?.inputs else {
            logMessage(.error, "Missing inputs for the symbol font.")
            return
        }
        
        let fontDestinations = inputs.map({ fontOutputPath + $0.lastComponent })
        if fontOutputPath.exists == false {
            try fontOutputPath.mkpath()
        }
        for (index, value) in inputs.enumerated() {
            if fontDestinations[index].exists {
                try fontDestinations[index].delete()
            }
            try value.copy(fontDestinations[index])
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
                (plistData as NSDictionary).write(toFile: plist.string, atomically: false)            }
        }
        
        guard let linkTo = output.link else { return }
        guard let target = fontXcodeProject?.pbxproj.targets(named: linkTo.target).first else {
            logMessage(.error, "Target -\(linkTo.target)- not found.")
            return
        }
        for destination in fontDestinations where fontFileGroup!.file(named: destination.lastComponent) == nil {
            fontNeedsProjectChanges = true
            let file = try fontFileGroup!.addFile(at: destination, sourceTree: .absolute, sourceRoot: linkTo.project.parent())
            _ = try target.resourcesBuildPhase()?.add(file: file)
        }
        if fontNeedsProjectChanges {
            try fontXcodeProject!.pbxproj.write(path: XcodeProj.pbxprojPath(linkTo.project), override: true)
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
            
            if verbose {
                logMessage(.info, "Executing configuration file \(file)")
            }
            try file.parent().chdir {
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
