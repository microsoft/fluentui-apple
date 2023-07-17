import Foundation

let greenColor = "\u{001B}[0;32m"
let resetColor = "\u{001B}[0;0m"
let redColor = "\u{001B}[0;31m"
let yellowColor = "\u{001B}[33m"

guard CommandLine.arguments.count == 2 else {
    print("\(redColor)Please provide a version in the format `major.minor.patch`\(resetColor)")
    exit(1)
}

func isVersionBumped(_ currentVersion: String, _ newVersion: String) -> Bool {
    let currentComponents = currentVersion.components(separatedBy: ".")
    let newComponents = newVersion.components(separatedBy: ".")

    guard currentComponents.count == 3 && newComponents.count == 3 else {
        return false
    }

    let currentMajor = Int(currentComponents[0]) ?? 0
    let currentMinor = Int(currentComponents[1]) ?? 0
    let currentPatch = Int(currentComponents[2]) ?? 0

    let newMajor = Int(newComponents[0]) ?? 0
    let newMinor = Int(newComponents[1]) ?? 0
    let newPatch = Int(newComponents[2]) ?? 0

    if newMajor < currentMajor {
        return false
    }

    if newMajor == currentMajor && newMinor < currentMinor {
        return false
    }

    if newMajor - currentMajor > 1 {
        print("\(yellowColor)Warning: New version major number should not jump by more than 1.\(redColor)")
    }

    if newMajor > currentMajor  {
        if newMinor != 0 {
            print("\(yellowColor)Warning: New major version should have a minor number of 0.\(resetColor)")
        } else if newPatch != 0 {
            print("\(yellowColor)Warning: New major version should have a patch number of 0.\(resetColor)")
        }
    }

    if newMinor - currentMinor > 1 {
        print("\(yellowColor)Warning: New version minor number should not jump by more than 1.\(resetColor)")
    } else if newMinor > currentMinor && newPatch != 0 {
        print("\(yellowColor)Warning: New minor version should have a patch number of 0.\(resetColor)")
    }

    if newPatch - currentPatch > 1 {
        print("\(yellowColor)Warning: New version patch number should not jump by more than 1.\(resetColor)")
    }

    if newMajor > currentMajor {
        return true
    }

    if newMinor > currentMinor {
        return true
    }

    return newPatch > currentPatch
}

// MARK: Update podspec

let newVersion = CommandLine.arguments[1]
let versionRegex = try? Regex("^\\d+\\.\\d+\\.\\d+$")
let versionRange = NSRange(location: 0, length: newVersion.utf16.count)
let croppedPattern = "\\.\\d+\\.\\d+"
var croppedNewValue = ""

if let range = newVersion.range(of: croppedPattern, options: .regularExpression) {
    croppedNewValue = String(newVersion[range])
}

guard let _ = try versionRegex?.firstMatch(in: newVersion) else {
    print("\(redColor)Please provide a version in the format `major.minor.patch`\(resetColor)")
    exit(1)
}

let currentDirectory = FileManager.default.currentDirectoryPath
let podspecPath = "\(currentDirectory)/MicrosoftFluentUI.podspec"

guard var fileContents = try? String(contentsOfFile: podspecPath, encoding: .utf8) else {
    print("\(redColor)Failed to read MicrosoftFluentUI.podspec file.\(resetColor)")
    exit(1)
}

let regexPattern = "s.version\\s*=\\s*'([^']*)'"

if let range = fileContents.range(of: regexPattern, options: .regularExpression) {
    let oldValue = fileContents[range]
    let oldVersion = "\\d+\\.\\d+\\.\\d+"
    if let oldVersionRange = oldValue.range(of: oldVersion, options: .regularExpression) {
        let version = oldValue[oldVersionRange]
        let updatedValue = oldValue.replacingOccurrences(of: version, with: newVersion)

        if !isVersionBumped(String(oldValue[oldVersionRange]), newVersion) {
            print("\(redColor)Please provide a version newer than \(version)\(resetColor)")
            exit(1)
        }

        fileContents.replaceSubrange(range, with: updatedValue)
    }
    else {
        print("\(redColor)Failed to find the field for the old version.\(resetColor)")
        exit(1)
    }
} else {
    print("\(redColor)Failed to find the field s.version in the MicrosoftFluentUI.podspec file.\(resetColor)")
    exit(1)
}

do {
    try fileContents.write(toFile: podspecPath, atomically: true, encoding: .utf8)
} catch {
    print("\(redColor)Failed to write to the MicrosoftFluentUI.podspec file.\(resetColor)")
}

// MARK: Update plists

func updatePlist(path: String, values: [String]) {
    guard let plistData = FileManager.default.contents(atPath: path),
          var plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else {
        print("\(redColor)Error: Failed to read plist file.\(resetColor)")
        exit(1)
    }

    let keysToUpdate = ["CFBundleShortVersionString", "CFBundleVersion"]

    for index in 0..<keysToUpdate.count {
        plistDictionary[keysToUpdate[index]] = values[index]
    }

    guard let modifiedPlistData = try? PropertyListSerialization.data(fromPropertyList: plistDictionary, format: .xml, options: 0) else {
        print("\(redColor)Failed to serialize plist data.\(resetColor)")
        exit(1)
    }

    do {
        try modifiedPlistData.write(to: URL(fileURLWithPath: path))
    } catch {
        print("\(redColor)Failed to write modified plist data. \(error.localizedDescription)\(resetColor)")
        exit(1)
    }
}

let values = newVersion.components(separatedBy: ".")
let majorBump = Int(values[0])!

updatePlist(path: "\(currentDirectory)/ios/FluentUI.Demo/FluentUI.Demo/Info.plist",
            values: ["\(1 + majorBump)\(croppedNewValue)", "\(137 + majorBump)\(croppedNewValue)"])

updatePlist(path: "\(currentDirectory)/ios/FluentUI.Resources/Info.plist",
            values: [newVersion, newVersion])

updatePlist(path: "\(currentDirectory)/macos/FluentUI/FluentUI-Info.plist",
            values: [newVersion, newVersion])

updatePlist(path: "\(currentDirectory)/macos/FluentUITestApp/FluentUITestApp-Info.plist",
            values: [newVersion,  "\(62 + majorBump)\(croppedNewValue)"])

print("\(greenColor)Successfully updated fluent version to \(newVersion)!\nFeel free to verify all strings have been bumped properly. For reference, see https://github.com/microsoft/fluentui-apple/pull/1812/files.\(resetColor)")
