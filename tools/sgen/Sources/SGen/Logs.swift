//
//  Logs.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation

// MARK: Printing on stderr

enum LogLevel {
    case info, warning, error
}

enum ANSIColor: UInt8, CustomStringConvertible {
    case reset = 0
    
    case black = 30
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case `default`
    
    var description: String {
        return "\u{001B}[\(rawValue)m"
    }
    
    func format(_ string: String) -> String {
        if let termType = getenv("TERM"), String(cString: termType).lowercased() != "dumb" &&
            isatty(fileno(stdout)) != 0 {
            return "\(self)\(string)\(ANSIColor.reset)"
        } else {
            return string
        }
    }
}

func logMessage(_ level: LogLevel, _ string: CustomStringConvertible) {
    switch level {
    case .info:
        fputs(ANSIColor.green.format("\(string)\n"), stdout)
    case .warning:
        fputs(ANSIColor.yellow.format("swiftgen: warning: \(string)\n"), stderr)
    case .error:
        fputs(ANSIColor.red.format("swiftgen: error: \(string)\n"), stderr)
    }
}

struct ErrorPrettifier: Error, CustomStringConvertible {
    let nsError: NSError
    var description: String {
        return "\(nsError.localizedDescription) (\(nsError.domain) code \(nsError.code))"
    }
    
    static func execute(closure: () throws -> Void ) rethrows {
        do {
            try closure()
        } catch let error as NSError where error.domain == NSCocoaErrorDomain {
            throw ErrorPrettifier(nsError: error)
        }
    }
}
