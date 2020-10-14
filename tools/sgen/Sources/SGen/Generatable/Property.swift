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
    
    func generate(_ isNested: Bool = false) -> String {
        var generated = ""
        if let style = self.style {
            generated = style.generate(true)
        } else if let rhs = self.rhs, rhs.isGlobal == false {
            
            var method = ""
            let indentation = isNested ? "\t\t\t" : "\t\t"
            method += "\n\n\(indentation)//MARK: \(self.key) "
            
            if !isOverride {
                let visibility = isOverridable ? "public" : "fileprivate"
                method += "\n\(indentation)\(visibility) var _\(key): \(rhs.returnValue())?"
            }
            
            // Options.
            let screen = "UIScreen.main"
            let methodArgs = "_ traitCollection: UITraitCollection? = \(screen).traitCollection"
            let override = isOverride ? "override " : ""
            let visibility = isOverridable ? "open" : "public"
            
            method +=
            "\n\(indentation)\(override)\(visibility) func \(key)Property(\(methodArgs)) -> \(rhs.returnValue()) {"
            method += "\n\(indentation)\tif let override = _\(key) { return override }"
            method += "\(rhs.generate(isNested))"
            method += "\n\(indentation)\t}"
            
            if !isOverride {
                method += "\n\(indentation)public var \(key == "default" ? "`\(key)`" : key): \(rhs.returnValue()) {"
                method += "\n\(indentation)\tget { return self.\(key)Property() }"
                method += "\n\(indentation)\tset { _\(key) = newValue }"
                method += "\n\(indentation)}"
            }
            generated = method
        }
        return generated
    }
}
