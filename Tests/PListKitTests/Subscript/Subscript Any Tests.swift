//
//  Subscript Any Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//

#if !os(watchOS)

import XCTest
import PListKit

class SubscriptAnyTests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSubscript_GetAny() throws {
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
        let val = pl.storage[any: "TestString"]
        
        // type check
        
        XCTAssertTrue(val is String)
        XCTAssertFalse(val is Int)
        XCTAssertFalse(val is Double)
        XCTAssertFalse(val is Bool)
        XCTAssertFalse(val is Date)
        XCTAssertFalse(val is Data)
        XCTAssertFalse(val is PListArray)
        XCTAssertFalse(val is PListDictionary)
        
        XCTAssertEqual(val as? String, "A string value")
        
        // set
        
        pl.storage[any: "TestAny"] = 123
        XCTAssertEqual(pl.storage[any: "TestAny"] as? Int, 123)
        
        pl.storage[any: "TestAny"] = "A new string"
        XCTAssertEqual(pl.storage[any: "TestAny"] as? String, "A new string")
    }
}

#endif
