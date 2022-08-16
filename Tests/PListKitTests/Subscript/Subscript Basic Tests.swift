//
//  Subscript Basic Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
import PListKit

class SubscriptBasicTests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSubscript_BasicSetGet() {
        // basic types and setters/getters
        
        let pl = PList()
        
        pl.storage[string: "TestString"] = "A test string"
        XCTAssertEqual(pl.storage[string: "TestString"], "A test string") // String?
        
        pl.storage[int: "TestInt"] = 10
        XCTAssertEqual(pl.storage[int: "TestInt"], 10) // Int?
        
        pl.storage[double: "TestDouble"] = 5.2
        XCTAssertEqual(pl.storage[double: "TestDouble"], 5.2) // Double?
        
        pl.storage[bool: "TestBool"] = true
        XCTAssertEqual(pl.storage[bool: "TestBool"], true) // Bool?
        
        let date = Date()
        pl.storage[date: "TestDate"] = date
        XCTAssertEqual(pl.storage[date: "TestDate"], date) // Date?
        
        pl.storage[data: "TestData"] = Data([1, 5, 10, 15])
        XCTAssertEqual(pl.storage[data: "TestData"], Data([1, 5, 10, 15])) // Data?
        
        // PListArray?, aka: Array<PListValue>
        pl.storage[array: "TestArray"] = [1, 2, 3]
        XCTAssertEqual(pl.storage[array: "TestArray"]?[0] as? Int, 1)
        XCTAssertEqual(pl.storage[array: "TestArray"]?[1] as? Int, 2)
        XCTAssertEqual(pl.storage[array: "TestArray"]?[2] as? Int, 3)
        XCTAssertEqual(pl.storage[array: "TestArray"]?.count, 3)
        
        // PListDictionary?, aka: Dictionary<String, PListValue>
        pl.storage[dict: "TestDict"]?[string: "DictString"] = "Dictionary string"
        XCTAssertNil(pl.storage[dict: "TestDict"]?[string: "DictString"])
        
        pl.storage[dictCreate: "TestDict"]?[string: "DictString"] = "Dictionary string"
        XCTAssertEqual(pl.storage[dict: "TestDict"]?[string: "DictString"], "Dictionary string")
        
        // nil for non-existent keys
        
        XCTAssertNil(pl.storage[string: "KeyDoesNotExist"])
        XCTAssertNil(pl.storage[int: "KeyDoesNotExist"])
        XCTAssertNil(pl.storage[double: "KeyDoesNotExist"])
        XCTAssertNil(pl.storage[bool: "KeyDoesNotExist"])
        XCTAssertNil(pl.storage[date: "KeyDoesNotExist"])
        XCTAssertNil(pl.storage[data: "KeyDoesNotExist"])
        XCTAssertNil(pl.storage[array: "KeyDoesNotExist"])
        XCTAssertNil(pl.storage[dict: "KeyDoesNotExist"])
        
        // deleting keys
        
        pl.storage[string: "TestString"] = nil
        XCTAssertNil(pl.storage[string: "TestString"])
    }
}

#endif
