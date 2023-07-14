import Foundation

guard CommandLine.arguments.count >= 2 else {
    print("Please provide a version in the format X.Y.Z.")
    exit(0)
}

let newValue = CommandLine.arguments[1]
let versionRegex = try? Regex("^\\d+\\.\\d+\\.\\d+$")
let versionRange = NSRange(location: 0, length: newValue.utf16.count)
guard let _ = try versionRegex?.firstMatch(in: newValue) else {
    print("Invalid version format. Please provide a version in the format X.Y.Z.")
    exit(0)
}

let currentDirectory = FileManager.default.currentDirectoryPath
let podspecPath = "\(currentDirectory)/MicrosoftFluentUI.podspec"

guard var fileContents = try? String(contentsOfFile: podspecPath, encoding: .utf8) else {
    print("Failed to read MicrosoftFluentUI.podspec file.")
    exit(0)
}

let regexPattern = "s.version\\s*=\\s*'([^']*)'"

if let range = fileContents.range(of: regexPattern, options: .regularExpression) {
    let oldValue = fileContents[range]
    let oldVersion = "\\d+\\.\\d+\\.\\d+"
    if let oldVersionRange = oldValue.range(of: oldVersion, options: .regularExpression) {
        let version = oldValue[oldVersionRange]
        let updatedValue = oldValue.replacingOccurrences(of: version, with: newValue)
        fileContents.replaceSubrange(range, with: updatedValue)
    }
} else {
    print("Failed to find the field s.version in the MicrosoftFluentUI.podspec file.")
    exit(0)
}

do {
    try fileContents.write(toFile: podspecPath, atomically: true, encoding: .utf8)
    print("Successfully updated the value of s.version in the MicrosoftFluentUI.podspec file.")
} catch {
    print("Failed to write to the MicrosoftFluentUI.podspec file.")
}


