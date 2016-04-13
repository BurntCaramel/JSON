//
//  JSONTests.swift
//  JSONTests
//
//  Created by Patrick Smith on 13/04/2016.
//  Copyright © 2016 Burnt Caramel. All rights reserved.
//

import XCTest
import Foundation
@testable import JSON

class JSONTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
			let jsonString = "{\"number\": 5.5, \"string\": \"abc\"}"
			guard let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) else {
				XCTFail("JSON string to data")
			}
			
			let bytesPointer = UnsafePointer<UInt8>(jsonData.bytes)
			let buffer = UnsafeBufferPointer(start: bytesPointer, count: jsonData.length)
			
			let parser = GenericJSONParser(buffer)
			do {
				let sourceJSON = try parser.parse()
				
				guard let sourceDecoder = sourceJSON.objectDecoder else {
					XCTFail("JSON not object")
				}
				
				let number: Double = try sourceDecoder.decode("number")
				let string: String = try sourceDecoder.decode("string")
			}
			catch {
				XCTFail("JSON error \(error)")
			}
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
