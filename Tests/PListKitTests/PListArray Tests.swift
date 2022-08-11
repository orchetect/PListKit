//
//  PListArray Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//

#if !os(watchOS)

import XCTest
import PListKit

class PListArrayTests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSubscripts_Get() {
        // custom array subscripts still require the index to exist like normal indexing subscripts, but it conditionally types the element
        
        let date = Date()
        
        let plistArray: PList.PListArray = [
            "String value",
            1,
            1.0,
            true,
            date,
            Data([1, 2, 3]),
            ["Array String", 123],
            ["DictKey1": "Dict string value"]
        ]
        
        // index 0
        XCTAssertEqual(plistArray[string: 0], "String value")
        XCTAssertEqual(plistArray[int: 0], nil)
        XCTAssertEqual(plistArray[double: 0], nil)
        XCTAssertEqual(plistArray[bool: 0], nil)
        XCTAssertEqual(plistArray[date: 0], nil)
        XCTAssertEqual(plistArray[data: 0], nil)
        XCTAssert(plistArray[array: 0] == nil)
        XCTAssert(plistArray[dict: 0] == nil)
        XCTAssertNil(plistArray[array: 0]) // alternate XCT syntax
        XCTAssertNil(plistArray[dict: 0]) // alternate XCT syntax
        
        // index 1
        XCTAssertEqual(plistArray[string: 1], nil)
        XCTAssertEqual(plistArray[int: 1], 1)
        XCTAssertEqual(plistArray[double: 1], 1.0) // converts from int
        XCTAssertEqual(plistArray[bool: 1], nil)
        XCTAssertEqual(plistArray[date: 1], nil)
        XCTAssertEqual(plistArray[data: 1], nil)
        XCTAssert(plistArray[array: 1] == nil)
        XCTAssert(plistArray[dict: 1] == nil)
        
        // index 2
        XCTAssertEqual(plistArray[string: 2], nil)
        XCTAssertEqual(plistArray[int: 2], nil)
        XCTAssertEqual(plistArray[double: 2], 1.0)
        XCTAssertEqual(plistArray[bool: 2], nil)
        XCTAssertEqual(plistArray[date: 2], nil)
        XCTAssertEqual(plistArray[data: 2], nil)
        XCTAssert(plistArray[array: 2] == nil)
        XCTAssert(plistArray[dict: 2] == nil)
        
        // index 3
        XCTAssertEqual(plistArray[string: 3], nil)
        XCTAssertEqual(plistArray[int: 3], nil)
        XCTAssertEqual(plistArray[double: 3], nil)
        XCTAssertEqual(plistArray[bool: 3], true)
        XCTAssertEqual(plistArray[date: 3], nil)
        XCTAssertEqual(plistArray[data: 3], nil)
        XCTAssert(plistArray[array: 3] == nil)
        XCTAssert(plistArray[dict: 3] == nil)
        
        // index 4
        XCTAssertEqual(plistArray[string: 4], nil)
        XCTAssertEqual(plistArray[int: 4], nil)
        XCTAssertEqual(plistArray[double: 4], nil)
        XCTAssertEqual(plistArray[bool: 4], nil)
        XCTAssertEqual(plistArray[date: 4], date)
        XCTAssertEqual(plistArray[data: 4], nil)
        XCTAssert(plistArray[array: 4] == nil)
        XCTAssert(plistArray[dict: 4] == nil)
        
        // index 5
        XCTAssertEqual(plistArray[string: 5], nil)
        XCTAssertEqual(plistArray[int: 5], nil)
        XCTAssertEqual(plistArray[double: 5], nil)
        XCTAssertEqual(plistArray[bool: 5], nil)
        XCTAssertEqual(plistArray[date: 5], nil)
        XCTAssertEqual(plistArray[data: 5], Data([1, 2, 3]))
        XCTAssert(plistArray[array: 5] == nil)
        XCTAssert(plistArray[dict: 5] == nil)
        
        // index 6
        XCTAssertEqual(plistArray[string: 6], nil)
        XCTAssertEqual(plistArray[int: 6], nil)
        XCTAssertEqual(plistArray[double: 6], nil)
        XCTAssertEqual(plistArray[bool: 6], nil)
        XCTAssertEqual(plistArray[date: 6], nil)
        XCTAssertEqual(plistArray[data: 6], nil)
        XCTAssertEqual(plistArray[array: 6]?[string: 0], "Array String")
        XCTAssertEqual(plistArray[array: 6]?[int: 1], 123)
        XCTAssert(plistArray[dict: 6] == nil)
        
        // index 7
        XCTAssertEqual(plistArray[string: 7], nil)
        XCTAssertEqual(plistArray[int: 7], nil)
        XCTAssertEqual(plistArray[double: 7], nil)
        XCTAssertEqual(plistArray[bool: 7], nil)
        XCTAssertEqual(plistArray[date: 7], nil)
        XCTAssertEqual(plistArray[data: 7], nil)
        XCTAssert(plistArray[array: 7] == nil)
        XCTAssertEqual(plistArray[dict: 7]?[string: "DictKey1"], "Dict string value")
        
        // index 8 - doesn't exist; should return nil and not crash
        XCTAssertEqual(plistArray[string: 8], nil)
        XCTAssertEqual(plistArray[int: 8], nil)
        XCTAssertEqual(plistArray[double: 8], nil)
        XCTAssertEqual(plistArray[bool: 8], nil)
        XCTAssertEqual(plistArray[date: 8], nil)
        XCTAssertEqual(plistArray[data: 8], nil)
        XCTAssert(plistArray[array: 8] == nil)
        XCTAssert(plistArray[dict: 8] == nil)
    }
}

#endif
