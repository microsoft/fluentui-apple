//
//  Style.swift
//  sgen
//
//  Created by Daniele Pizziconi on 12/06/2020.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class Style {
    var name: String
    var isDependency: Bool = false
    var isDependencyInItsOwnStylesheet: Bool = false
    var isExternalOverride = false
    var superclassName: String? = nil
    var properties: [Property]
    var isExtension = false
    var isAnimation = false
    var isOverridable = false
    var isNestedOverridable = false
    var viewClass: String = "UIView"
    var isInjected = false
    var belongsToStylesheetName: String?
    var extendsStylesheetName: String?
    var nestedIn: String?
    var nestedInfo: (isOverride: Bool, superclassName: String?, returnClass: String?, overrideName: String?) = (false, nil, nil, nil)
    var isNestedInExternal: (Bool, isOverride: Bool) = (false, false)
    
    init(name: String, properties: [Property]) {
        var styleName = name.trimmingCharacters(in: CharacterSet.whitespaces)
        
        // Check if this could generate an extension.
        let extensionPrefix = "__appearance_proxy"
        if styleName.contains(extensionPrefix) {
            styleName = styleName.replacingOccurrences(of: extensionPrefix, with: "")
            isExtension = true
        }
        let openPrefix = "__open"
        styleName = styleName.replacingOccurrences(of: openPrefix, with: "")
        isOverridable = true
        
        let protocolPrefix = "__style"
        if styleName.contains(protocolPrefix) {
            styleName = styleName.replacingOccurrences(of: protocolPrefix, with: "")
        }

        // Trims spaces
        styleName = styleName.replacingOccurrences(of: " ", with: "")
        
        // Superclass defined.
        if let components = Optional(styleName.components(separatedBy: "extends")), components.count == 2 {
            styleName = components[0].replacingOccurrences(of: " ", with: "")
            if Generator.Config.importStylesheetNames != nil && (components[1].hasPrefix("S.") || components[1].hasPrefix("\(LibraryName).")) {
                let prefix = components[1].hasPrefix("\(LibraryName).") ? LibraryName : "S"
                let extendedClass = components[1].replace(prefix: prefix, with: Generator.Config.importStylesheetNames!.first!)
                superclassName = extendedClass.replacingOccurrences(of: " ", with: "")
                isExternalOverride = true
//                for property in properties where property.style != nil {
//                    property.style!.isExternalOverride = true
//                }
            } else {
                superclassName = components[1].replacingOccurrences(of: " ", with: "")
            }
        }
        if isOverridable {
            properties.forEach({ $0.isOverridable = true })
        }
        
        self.name = styleName
        self.properties = properties
    }
}

extension Style: Determinism {
    @discardableResult func ensureDeterminism() -> Style {
        properties = properties.compactMap({ $0.ensureDeterminism() }).sorted(by: { $0.key < $1.key })
        return self
    }
}

extension Style: Generatable {
    
    public func generate(_ isNested: Bool = false, includePrefix: Bool = true) -> String {
        
        var indentation = isNested ? "\t\t" : "\t"
        if isAnimation {
            indentation.append("\t")
        }
        var wrapper = isNested ? "\n\n" + indentation : indentation
        if let nestedOverrideName = nestedInfo.overrideName {
            wrapper += "//MARK: - \(nestedOverrideName)"
        } else {
            wrapper += "//MARK: - \(name)"
        }
                
        var superclass = Generator.Config.objcGeneration ? ": NSObject" : ""
        var nestedSuperclass = Generator.Config.objcGeneration ? ": NSObject" : ""
        var nestedReturn = ""
        
        var objcName: String = ""
        if let nestedOverrideName = nestedInfo.overrideName {
            objcName = nestedOverrideName.replacingOccurrences(of: name, with: "") + name.firstUppercased
        } else if let nestedIn = nestedIn {
            objcName = nestedIn + name.firstUppercased
        } else  {
            objcName = name.firstUppercased
        }
        
        let hasNamespace = Generator.Config.importStylesheetManagerName != nil && Generator.Config.namespace != nil && Generator.Config.importFrameworks != nil
        let namespace = hasNamespace ? "\(Generator.Config.importFrameworks!)." : ""
        
        let objc = Generator.Config.objcGeneration ? "@objc(\(objcName)AppearanceProxy) @objcMembers " : ""
        if let s = superclassName {
            superclass = ": \(isExternalOverride ? namespace : "")\(s)AppearanceProxy"
        }
        if let s = nestedInfo.superclassName { nestedSuperclass = ": \(s)AppearanceProxy" }
        if let s = nestedInfo.returnClass { nestedReturn = ": \(s)AppearanceProxy" }
        let visibility = isOverridable ? "open" : "public"
        let staticModifier = isNested ? "" : " static"
        let variableVisibility = !isNested ? "public" : visibility
        let styleClass = nestedInfo.isOverride ? "\(nestedInfo.overrideName!)AppearanceProxy" : "\(name)AppearanceProxy"
        
        if isDependency || !isDependencyInItsOwnStylesheet {
            if nestedInfo.isOverride || isNestedOverridable {
                let override = nestedInfo.isOverride ? "override " : ""
                wrapper += "\n\(indentation)open \(override)var \(name): \(styleClass)"
                
                let injectedProxy: String
                if isNested && isNestedInExternal.0 == false {
                    injectedProxy = "proxy: mainProxy"
                } else {
                    injectedProxy = "proxy: { return self }"
                }
                
                wrapper += " {\n\(indentation)\treturn \(styleClass)(\(injectedProxy))"
                wrapper += "\n\(indentation)}"
            } else {
                wrapper += "\n\(indentation)\(objc)\(variableVisibility)\(staticModifier) let \(name) = \(name)AppearanceProxy()"
            }
        }
        
        if !isDependency || isDependencyInItsOwnStylesheet {
            let superclassDeclaration = nestedInfo.isOverride ? nestedSuperclass : superclass
            
            wrapper += "\n\(indentation)\(objc)\(visibility) class \(styleClass)\(superclassDeclaration) {"
            
            if superclassName == nil && !nestedInfo.isOverride && !isInjected {
                let baseStyleName = Generator.Stylesheets.filter({ $0.superclassName == nil }).first!
                wrapper += "\n\(indentation)\tpublic let mainProxy: () -> \(baseStyleName.name)"
                wrapper += "\n\(indentation)\tpublic init(proxy: @escaping () -> \(baseStyleName.name)) {"
                wrapper += "\n\(indentation)\t\tself.mainProxy = proxy"
                wrapper += "\n\(indentation)\t}"
            }
            for property in properties {
                wrapper += property.generate(isNested)
            }
            
            wrapper += "\n\(indentation)}\n"
        } else {
            wrapper += "\n"
        }
        return wrapper
    }
}
