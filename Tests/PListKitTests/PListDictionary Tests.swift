//
//  PListDictionary Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//

#if !os(watchOS)

import XCTest
import PListKit

class PListDictionaryTests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSubscripts_Get() {
        // custom array subscripts still require the index to exist like normal indexing subscripts, but it conditionally types the element
        
        let date = Date()
        
        let plistDict: PListDictionary = [
            "a": "String value",
            "b": 1,
            "c": 1.0,
            "d": true,
            "e": date,
            "f": Data([1, 2, 3]),
            "g": ["Array String", 123],
            "h": ["DictKey1": "Dict string value"]
        ]
        
        // key "a"
        XCTAssertEqual(plistDict[string: "a"], "String value")
        XCTAssertEqual(plistDict[int: "a"], nil)
        XCTAssertEqual(plistDict[double: "a"], nil)
        XCTAssertEqual(plistDict[bool: "a"], nil)
        XCTAssertEqual(plistDict[date: "a"], nil)
        XCTAssertEqual(plistDict[data: "a"], nil)
        XCTAssert(plistDict[array: "a"] == nil)
        XCTAssert(plistDict[dict: "a"] == nil)
        XCTAssertNil(plistDict[array: "a"]) // alternate XCT syntax
        XCTAssertNil(plistDict[dict: "a"]) // alternate XCT syntax
        
        // key "b"
        XCTAssertEqual(plistDict[string: "b"], nil)
        XCTAssertEqual(plistDict[int: "b"], 1)
        XCTAssertEqual(plistDict[double: "b"], 1.0) // converts from int
        XCTAssertEqual(plistDict[bool: "b"], nil)
        XCTAssertEqual(plistDict[date: "b"], nil)
        XCTAssertEqual(plistDict[data: "b"], nil)
        XCTAssert(plistDict[array: "b"] == nil)
        XCTAssert(plistDict[dict: "b"] == nil)
        
        // key "c"
        XCTAssertEqual(plistDict[string: "c"], nil)
        XCTAssertEqual(plistDict[int: "c"], nil)
        XCTAssertEqual(plistDict[double: "c"], 1.0)
        XCTAssertEqual(plistDict[bool: "c"], nil)
        XCTAssertEqual(plistDict[date: "c"], nil)
        XCTAssertEqual(plistDict[data: "c"], nil)
        XCTAssert(plistDict[array: "c"] == nil)
        XCTAssert(plistDict[dict: "c"] == nil)
        
        // key "d"
        XCTAssertEqual(plistDict[string: "d"], nil)
        XCTAssertEqual(plistDict[int: "d"], nil)
        XCTAssertEqual(plistDict[double: "d"], nil)
        XCTAssertEqual(plistDict[bool: "d"], true)
        XCTAssertEqual(plistDict[date: "d"], nil)
        XCTAssertEqual(plistDict[data: "d"], nil)
        XCTAssert(plistDict[array: "d"] == nil)
        XCTAssert(plistDict[dict: "d"] == nil)
        
        // key "e"
        XCTAssertEqual(plistDict[string: "e"], nil)
        XCTAssertEqual(plistDict[int: "e"], nil)
        XCTAssertEqual(plistDict[double: "e"], nil)
        XCTAssertEqual(plistDict[bool: "e"], nil)
        XCTAssertEqual(plistDict[date: "e"], date)
        XCTAssertEqual(plistDict[data: "e"], nil)
        XCTAssert(plistDict[array: "e"] == nil)
        XCTAssert(plistDict[dict: "e"] == nil)
        
        // key "f"
        XCTAssertEqual(plistDict[string: "f"], nil)
        XCTAssertEqual(plistDict[int: "f"], nil)
        XCTAssertEqual(plistDict[double: "f"], nil)
        XCTAssertEqual(plistDict[bool: "f"], nil)
        XCTAssertEqual(plistDict[date: "f"], nil)
        XCTAssertEqual(plistDict[data: "f"], Data([1, 2, 3]))
        XCTAssert(plistDict[array: "f"] == nil)
        XCTAssert(plistDict[dict: "f"] == nil)
        
        // key "g"
        XCTAssertEqual(plistDict[string: "g"], nil)
        XCTAssertEqual(plistDict[int: "g"], nil)
        XCTAssertEqual(plistDict[double: "g"], nil)
        XCTAssertEqual(plistDict[bool: "g"], nil)
        XCTAssertEqual(plistDict[date: "g"], nil)
        XCTAssertEqual(plistDict[data: "g"], nil)
        XCTAssertEqual(plistDict[array: "g"]?[string: 0], "Array String")
        XCTAssertEqual(plistDict[array: "g"]?[int: 1], 123)
        XCTAssert(plistDict[dict: "g"] == nil)
        
        // key "h"
        XCTAssertEqual(plistDict[string: "h"], nil)
        XCTAssertEqual(plistDict[int: "h"], nil)
        XCTAssertEqual(plistDict[double: "h"], nil)
        XCTAssertEqual(plistDict[bool: "h"], nil)
        XCTAssertEqual(plistDict[date: "h"], nil)
        XCTAssertEqual(plistDict[data: "h"], nil)
        XCTAssert(plistDict[array: "h"] == nil)
        XCTAssertEqual(plistDict[dict: "h"]?[string: "DictKey1"], "Dict string value")
        
        // key "i" - doesn't exist; should return nil and not crash
        XCTAssertEqual(plistDict[string: "i"], nil)
        XCTAssertEqual(plistDict[int: "i"], nil)
        XCTAssertEqual(plistDict[double: "i"], nil)
        XCTAssertEqual(plistDict[bool: "i"], nil)
        XCTAssertEqual(plistDict[date: "i"], nil)
        XCTAssertEqual(plistDict[data: "i"], nil)
        XCTAssert(plistDict[array: "i"] == nil)
        XCTAssert(plistDict[dict: "i"] == nil)
    }
}

#endif
