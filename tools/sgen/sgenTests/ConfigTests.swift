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

protocol Instrumentation {
    func register(events: [String], callback: (String) -> Void)
    func unregister()
}

class XXXCoordinator: Coordinator {
    
    init(instrumentation: Instrumentation, events: [String]) { }
    
    func start() {
        let viewModel = XXXViewModel(instrumentation: instrumentation, events: events)
    }
}

class XXXViewModel {
    init(instrumentation: Instrumentation, events: [String]) {
        instrumentation.register(events: events) { event in
            
        }
    }
}

extension AXPInstrumentationManager: Instrumentation {
    
    func register(events: [String], callback: (String) -> Void) {
        var observers: []
        events.forEach(events) {
            observers.append(NotificationCenter.default.addObserverForName(...., object: nil, queue: mainQueue) { (event) in
                callback(event)
            })
        }
    }
    func unregister() {
        observers.forEach(events) { NotificationCenter.default.removeObserver($0) }
    }
}

