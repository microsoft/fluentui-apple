import Foundation

if CommandLine.arguments.count != 3 {
    print("usage: swift removeUnusedResourcesFromAssets.swift <xcassets_file_path> <project_root_path>")
} else {
    let xcassetsPath = CommandLine.arguments[1]
    let rootPath = CommandLine.arguments[2]

    let usedResources = findUsedResources(in: rootPath)

    removeResources(from: xcassetsPath,
                    notContainedIn: usedResources)
}


/// Builds a set of resource entries relative to the root of an .xcassets folder based on contents of the .xcfilelist files in the project.
/// - Parameter rootPath: Root path of the project. A search for .resources.xcfilelist files will be performed to build the resource entry list.
/// - Returns: A set containing the combination of all resource entries in the .resources.xcfilelist found in the project.
func findUsedResources(in rootPath: String) -> Set<String> {
    let rootURL = URL(fileURLWithPath: rootPath)
    let resourceFileSuffix = ".resources.xcfilelist"
    var usedResources: Set<String> = []

    print("Parsing *\(resourceFileSuffix) files in path \(rootURL)")
    if let filesEnumerator = FileManager.default.enumerator(at: rootURL,
                                                            includingPropertiesForKeys: [.isRegularFileKey],
                                                            options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
        for case let fileURL as URL in filesEnumerator {
            do {
                let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                let filePath = fileURL.relativePath

                if fileAttributes.isRegularFile! &&
                    filePath.hasSuffix(resourceFileSuffix) {

                    print("\nUsed resources in file: \(filePath)")

                    do {
                        let resourceFileListContents = try String(contentsOf: fileURL)

                        for entry in resourceFileListContents.split(separator: "\n") {
                            let resourceFileEntry = entry.trimmingCharacters(in: .whitespacesAndNewlines)
                            usedResources.insert(resourceFileEntry)
                            print("- \(resourceFileEntry)")
                        }
                    } catch {
                        fatalError("Failed to read contents resource file: \(filePath) \nError: \(error)")
                   }
                }
            } catch {
                fatalError("Failed to retrieve resource file: \(fileURL) \nError: \(error)")
            }
        }
    }

    return usedResources
}


/// Iterates through all folders in a given .xcassets file and removes the .colorset or .imageset folders that are not contained in the used resources set.
/// - Parameters:
///   - xcassetsPath: Root path of the .xcassets file.
///   - usedResourcesSet: Set containing the list of paths (relative to the .xcassets root) of resources that should not be removed.
func removeResources(from xcassetsPath: String, notContainedIn usedResourcesSet: Set<String>) {
    let resourceExtensions = ["colorset", "imageset"]
    let xcassetsURL = URL(fileURLWithPath: xcassetsPath)
    let xcassetsRelativePath = xcassetsURL.relativePath

    print("\n\nProcessing resources of xcassets in path: \(xcassetsPath)")
    if let directoriesEnumerator = FileManager.default.enumerator(at: xcassetsURL,
                                                                  includingPropertiesForKeys: [.isDirectoryKey],
                                                                  options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
        for case let directoryURL as URL in directoriesEnumerator {
            do {
                let directoryAttributes = try directoryURL.resourceValues(forKeys:[.isDirectoryKey])
                let dirExtension = directoryURL.pathExtension

                if directoryAttributes.isDirectory! && resourceExtensions.contains(dirExtension) {
                    let fileEntry = directoryURL.relativePath.withoutPrefix(xcassetsRelativePath).withoutPrefix("/")
                    let shouldBeKept = usedResourcesSet.contains(fileEntry)

                    if (!shouldBeKept) {
                        try FileManager.default.removeItem(at: directoryURL)
                    }

                    print(" - \(fileEntry) (\(shouldBeKept ? "kept" : "removed"))")
                }
            } catch {
                print(error, directoryURL)
            }
        }
    }
}

extension String {
    /// Removes a given prefix from a string.
    /// - Parameter prefix: The prefix to be removed.
    /// - Returns: The resulting string without the prefix.
    func withoutPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
