import Foundation

guard CommandLine.arguments.count >= 2 else {
    print("C'mon gimme a version")
    exit(0)
}

let newValue = CommandLine.arguments[1]
let versionRegex = try? NSRegularExpression(pattern: "^\\d+\\.\\d+\\.\\d+$")
let versionRange = NSRange(location: 0, length: newValue.utf16.count)
guard versionRegex?.firstMatch(in: newValue, options: [], range: versionRange) != nil else {
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
    let updatedValue = oldValue.replacingOccurrences(of: oldValue, with: "s.version          = '\(newValue)'")
    fileContents.replaceSubrange(range, with: updatedValue)
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


