//
//  Constants.swift
//  sgen
//
//  Created by Daniele Pizziconi on 11/06/2020.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

let IconicFontStyle = "IconicFontStyle"
let IconicFontSectionName = "__SymbolFont"
let FontTextStyle = "FontTextStyle"
let FontTextStyleSectionName = "__TextStyle"
let TypographyStyle = "Typography"
let SymbolNamePlaceholder = "-"
let NamespaceEnums = "S"
let LibraryName = "Stardust"
let IconNameKey = "name"
let IconEnum = "IconSymbol"
let StylesheetManagerName = "StylesheetManager"
let EnumCaseNone = "none"

enum IconSupportedKeys: String, CodingKey {
    case size
    case style
    case weight
}


enum StylesheetGrammar: String, CodingKey {
    case `import`
    
    enum Primitive: String, CodingKey {
        case enumDef = "EnumDef"
        case `enum` = "Enum"
    }
}

enum IconicWeight: String, CodingKey, CaseIterable {
    case light
    case regular
}

struct TypographyInfo {
    let defaultPointSize: String
    let maximumPointSize: String?
    let mapsTo: String
    let version: String?
    
    init(dict: [Config.Entry.Typography.SupportedStyleKeys: String]) {
        self.defaultPointSize = dict[.defaultPointSize]!
        self.maximumPointSize = dict[.maximumPointSize]
        self.mapsTo = dict[.mapsTo]!
        self.version = dict[.version]
    }
}

