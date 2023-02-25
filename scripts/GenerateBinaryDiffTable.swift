import Foundation

struct SizePair {
    var oldSize: Int = 0
    var newSize: Int = 0
    var delta: Int {
        return newSize - oldSize
    }
}
var sizeDict: [String: SizePair] = [:]

let numberFormatter = NumberFormatter()
numberFormatter.numberStyle = .decimal

let dangerMin = 250000
let severeMin = 50000

if CommandLine.arguments.count != 3 {
    print("usage: swift GenerateBinaryDiffTable.swift <path to old libFluentUI.a> <path to new libFluentUI.a>")
} else {
    let oldPath: String = CommandLine.arguments[1]
    let newPath: String = CommandLine.arguments[2]

    do {
        parseArFor(path: oldPath, isOld: true)
        parseArFor(path: newPath, isOld: false)

        var totalBefore = 0
        var totalAfter = 0
        var totalIncrease = 0
        var totalDecrease = 0
        var totalDelta = 0
        var stringsToPrint: [String] = []
        let sortedDict = sizeDict.sorted { $0.value.delta > $1.value.delta }
        for element in sortedDict {
            let value = element.value

            let oldSize = value.oldSize
            totalBefore += oldSize
            
            let newSize = value.newSize
            totalAfter += newSize

            let delta = value.delta
            if delta != 0 {
                totalDelta += delta
                stringsToPrint.append(rowString(name: element.key, before: oldSize, after: newSize, delta: delta))
                if delta > 0 {
                    totalIncrease += delta
                } else {
                    totalDecrease += delta
                }
            }
        }
        
        let totalIncreaseString = numberFormatter.string(from: NSNumber(value: totalIncrease)) ?? "0"
        print("Total increase: \(totalIncreaseString) bytes")

        let totalDecreaseString = numberFormatter.string(from: NSNumber(value: totalDecrease)) ?? "0"
        print("Total decrease: \(totalDecreaseString) bytes")

        print("| File | Before | After | Delta |")
        print("|------|-------:|------:|------:|")
        print(rowString(name: "Total", before: totalBefore, after: totalAfter, delta: totalDelta))

        print("<details>")
        print("<summary> Full breakdown </summary>\n")
        print("| File | Before | After | Delta |")
        print("|------|-------:|------:|------:|")
        stringsToPrint.forEach { print($0) }
        print("</details>")
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
                        sizeDict[fileName, default: SizePair()].oldSize = sizeInt
                    } else {
                        sizeDict[fileName, default: SizePair()].newSize = sizeInt
                    }
                }
            }
        }
    } catch {
        return
    }
}

func rowString(name: String, before: Int, after: Int, delta: Int) -> String {
    let beforeString = numberFormatter.string(from: NSNumber(value: before)) ?? "0"
    let afterString = numberFormatter.string(from: NSNumber(value: after)) ?? "0"
    let deltaString = numberFormatter.string(from: NSNumber(value: delta)) ?? "0"
    let emoji: String
    if delta > dangerMin {
        emoji = "⛔️"
    } else if delta > severeMin {
        emoji = "🛑"
    } else if delta > 0 {
        emoji = "⚠️"
    } else {
        emoji = "🎉"
    }
    return "| \(name) | \(beforeString) bytes | \(afterString) bytes | \(emoji) \(deltaString) bytes |"
}
