//
//  Version.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation
import PathKit

private func getVersion(name: String, type: AnyClass) -> String {
  return getVersion(name: name, bundle: Bundle(for: type))
}

private func getVersion(name: String, bundle: Bundle) -> String {
  if let version = bundle.infoDictionary?["CFBundleShortVersionString"] as? String {
    return version
  }

  guard let path = Bundle.main.path(forResource: "\(name)-Info", ofType: "plist").flatMap({ Path($0) }),
    let data: Data = try? path.read(),
    let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
    let dictionary = plist as? [String: Any],
    let version = dictionary["CFBundleShortVersionString"] as? String else { return "0.0" }

  return version
}

let version = getVersion(name: "SGen", bundle: .main)
var inUnitTests = NSClassFromString("XCTest") != nil
