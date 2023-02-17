import Foundation

if CommandLine.arguments.count != 3 {
    print("usage: swift sizeDiffTable.swift <path to old libFluentUI.a> <path to new libFluentUI.a>")
}

struct SizeDiff {
    var oldSize: Int = 0
    var newSize: Int = 0
    var delta: Int {
        return newSize - oldSize
    }
}

let oldPath: String = CommandLine.arguments[1]
let newPath: String = CommandLine.arguments[2]
var sizeDict: [String: SizeDiff] = [:]

do {
    parseArFor(path: oldPath, isOld: true)
    parseArFor(path: newPath, isOld: false)

    print("| file | before | after | delta |")
    print("|------|--------|-------|-------|")

    let sortedDict = sizeDict.sorted { abs($0.value.delta) > abs($1.value.delta) }
    for element in sortedDict {
        let value = element.value
        let delta = value.delta
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let beforeString = numberFormatter.string(from: NSNumber(value: value.oldSize)) ?? "0"
        let afterString = numberFormatter.string(from: NSNumber(value: value.newSize)) ?? "0"
        let deltaString = numberFormatter.string(from: NSNumber(value: delta)) ?? "0"
        if delta != 0 {
            print("| \(element.key) | \(beforeString) bytes | \(afterString) bytes | \(deltaString) bytes |")
        }
    }
}

func parseArFor(path: String, isOld: Bool) {
    let pipe = Pipe()
    let ar = Process()
    ar.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    ar.arguments = ["ar", "tv", path]
    ar.standardOutput = pipe
    
    do {
        try ar.run()
        let data = try pipe.fileHandleForReading.readToEnd()
        if let data, let output = String(data: data, encoding: .utf8) {
            let lines = output.split(separator: "\n")
            for line in lines {
                let fields = line.split(separator: " ")
                let fileName = String(fields[7])
                let fileSize = fields[2]
                if let sizeInt = Int(fileSize) {
                    if isOld {
                        sizeDict[fileName, default: SizeDiff()].oldSize = sizeInt
                    } else {
                        sizeDict[fileName, default: SizeDiff()].newSize = sizeInt
                    }
                }
            }
        }
    } catch {
        return
    }
}
