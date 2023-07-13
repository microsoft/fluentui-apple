import Foundation

let currentDirectory = FileManager.default.currentDirectoryPath
let filePath = "\(currentDirectory)/MicrosoftFluentUI.podspec"

guard var fileContents = try? String(contentsOfFile: filePath, encoding: .utf8) else {
    print("Failed to read MicrosoftFluentUI.podspec file.")
    exit(0)
}

let regexPattern = "s.version\\s*=\\s*'([^']*)'"
let newValue = "0.20.0"

if let range = fileContents.range(of: regexPattern, options: .regularExpression) {
    let oldValue = fileContents[range]
    let updatedValue = oldValue.replacingOccurrences(of: oldValue, with: "s.version          = '\(newValue)'")
    fileContents.replaceSubrange(range, with: updatedValue)
} else {
    print("Failed to find the field s.version in the MicrosoftFluentUI.podspec file.")
    exit(0)
}

do {
    try fileContents.write(toFile: filePath, atomically: true, encoding: .utf8)
    print("Successfully updated the value of s.version in the MicrosoftFluentUI.podspec file.")
} catch {
    print("Failed to write to the MicrosoftFluentUI.podspec file.")
}

