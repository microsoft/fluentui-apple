//
//  ConfigTests.swift
//  sgenTests
//
//  Created by Daniele Pizziconi on 08/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import XCTest
@testable import PathKit

class ConfigTests: XCTestCase {
    
    lazy var bundle = Bundle(for: type(of: self))
    
    func testConfigWithParams() throws {
        guard let path = bundle.path(forResource: "configWithInputs", ofType: "yml") else {
            fatalError("Config not found")
        }
        let file = Path(path)
        do {
            let config = try Config(file: file)
            
            let entry = config.command
            XCTAssertNotNil(entry)
            
            XCTAssertEqual(entry.baseStylePath, "../Inputs/GenericStyle.yml")
            XCTAssertEqual(entry.inputDir, "../Inputs/")
            XCTAssertEqual(entry.inputs, ["../Inputs/LightStyle.yml", "../Inputs/DarkStyle.yml"])
            
            XCTAssertNotNil(entry.output)
        } catch let error {
            XCTFail("Error: \(error)")
        }
    }

}
