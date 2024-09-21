//
//  PListDictionary Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import PListKit
import XCTest

final class PListDictionary_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testSubscriptGetters() {
        // custom dictionary key subscripts still returns an Optional,
        // but it also conditionally types the element
        
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
    
    func testSubscriptGetterAny() throws {
        var plistDict = try kSamplePList.DictRootAllValues.XML.plist().storage
        
        let val = plistDict[any: "TestString"]
        
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
        
        plistDict[any: "TestAny"] = 123
        XCTAssertEqual(plistDict[any: "TestAny"] as? Int, 123)
        
        plistDict[any: "TestAny"] = "A new string"
        XCTAssertEqual(plistDict[any: "TestAny"] as? String, "A new string")
    }
    
    func testMutation() {
        // PListDictionary?, aka: Dictionary<String, PListValue>
        
        let pl = DictionaryPList()
        
        XCTAssertNil(pl.storage[dict: "TestDict"])
        
        // won't create the dict, so fails to create string key
        pl.storage[dict: "TestDict"]?[string: "DictString"] = "Dictionary string"
        XCTAssertNil(pl.storage[dict: "TestDict"]?[string: "DictString"])
        
        // creates the dict and the string key
        pl.storage[dictCreate: "TestDict"]?[string: "DictString"] = "Dictionary string"
        XCTAssertEqual(pl.storage[dict: "TestDict"]?[string: "DictString"], "Dictionary string")
        
        // create nested dict
        pl.storage[dict: "TestDict"]?[dict: "NestedDict"] = [:]
        XCTAssertNotNil(pl.storage[dict: "TestDict"]?[dict: "NestedDict"])
        
        pl.storage[dict: "TestDict"]?[dict: "NestedDict"]?[string: "NestedString"] =
            "A nested string"
        XCTAssertEqual(
            pl.storage[dict: "TestDict"]?[dict: "NestedDict"]?[string: "NestedString"],
            "A nested string"
        )
        
        // copy dict
        pl.storage[dict: "TestDict2"] = pl.storage[dict: "TestDict"]
        XCTAssertNotNil(pl.storage[dict: "TestDict2"])
        XCTAssertEqual(
            pl.storage[dict: "TestDict2"]?[dict: "NestedDict"]?[string: "NestedString"],
            "A nested string"
        )
        
        // get keys
        XCTAssertEqual(pl.storage[dict: "TestDict"]?.getStringKeys.first, "DictString")
        XCTAssertNil(pl.storage[dict: "TestDict"]?.getIntKeys.first)
        XCTAssertNil(pl.storage[dict: "TestDict"]?.getDoubleKeys.first)
        XCTAssertNil(pl.storage[dict: "TestDict"]?.getBoolKeys.first)
        XCTAssertNil(pl.storage[dict: "TestDict"]?.getDateKeys.first)
        XCTAssertNil(pl.storage[dict: "TestDict"]?.getDataKeys.first)
        XCTAssertNil(pl.storage[dict: "TestDict"]?.getArrayKeys.first)
        XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDictionaryKeys.first, "NestedDict")
        
        // get key pairs
        XCTAssertEqual(
            pl.storage[dict: "TestDict"]?.getStringKeyPairs,
            ["DictString": "Dictionary string"]
        )
        XCTAssertEqual(pl.storage[dict: "TestDict"]?.getIntKeyPairs, [:])
        XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDoubleKeyPairs, [:])
        XCTAssertEqual(pl.storage[dict: "TestDict"]?.getBoolKeyPairs, [:])
        XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDateKeyPairs, [:])
        XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDataKeyPairs, [:])
        
        let getArrayPairs = pl.storage[dict: "TestDict"]?.getArrayKeyPairs
        XCTAssertEqual(getArrayPairs?.count, 0)
        
        let getDictPairs = pl.storage[dict: "TestDict"]?.getDictionaryKeyPairs
        XCTAssertEqual(getDictPairs?.count, 1)
        XCTAssertEqual(getDictPairs?.first?.key, "NestedDict")
        let nestedDict = pl.storage[dict: "TestDict"]?[dict: "NestedDict"]
        XCTAssertEqual(nestedDict?.first?.key, "NestedString")
        XCTAssertEqual(nestedDict?.first?.value as? String, "A nested string")
        
        // delete dict
        pl.storage[dict: "TestDict"] = nil
        XCTAssertNil(pl.storage[dict: "TestDict"])
    }
    
    func testRawPListDictionary_convertedToPListDictionary() {
        let dict: RawPListDictionary = ["A key" as NSString: 123 as NSNumber]
        
        let newDict: PListDictionary? = dict.convertedToPListDictionary()
        XCTAssertNotNil(newDict)
        XCTAssertEqual(newDict?.count, 1)
        XCTAssertEqual(newDict?[int: "A key"], 123)
    }
}
