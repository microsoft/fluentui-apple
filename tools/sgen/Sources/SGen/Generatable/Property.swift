//
//  Property.swift
//  sgen
//
//  Created by Daniele Pizziconi on 12/06/2020.
//  Copyright © 2020 Microsoft. All rights reserved.
//

class Property {
    var style: Style?
    var rhs: RhsValue?
    let key: String
    var isOverride: Bool = false
    var isOverridable: Bool = false
    
    init(key: String, rhs: RhsValue?, style: Style?) {
        self.style = style
        self.rhs = rhs
        self.key = key.replacingOccurrences(of: ".", with: "_")
    }
}

extension Property: Determinism {
    func ensureDeterminism() -> Property {
        style = style?.ensureDeterminism()
        return self
    }
}

extension Property: Generatable {
    
    func generate(_ isNested: Bool = false, includePrefix: Bool = true) -> String {
        var generated = ""
        if let style = self.style {
            generated = style.generate(true)
        } else if let rhs = self.rhs, !rhs.isGlobal {
            var method = ""
            let indentation = isNested ? "\t\t\t" : "\t\t"
            method += "\n\n\(indentation)//MARK: \(self.key) "
            
            let visibility = isOverridable ? "open" : "fileprivate"
            let overrideString = isOverride ? " override" : ""
            method += "\n\(indentation)\(visibility)\(overrideString) var \(key): \(rhs.returnValue()) { \(rhs.generate(isNested)) \n\(indentation)}"
            
            generated = method
        }
        return generated
    }
}
