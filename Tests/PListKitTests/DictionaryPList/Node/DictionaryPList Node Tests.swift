//
//  DictionaryPList Node Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import PListKit

final class DictionaryPList_Node_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Data Nodes
    
    func testGetAnyKeys() throws {
        // test accessing values using .any(key:)
        
        let pl = try kSamplePList.DictRootAllValues.XML.plist()
        
        XCTAssertEqual(
            (pl.root.any(key: "TestArray").value as? PListArray)?[0] as? String,
            "String value in the array"
        )
        XCTAssertEqual(
            (pl.root.any(key: "TestArray").value as? PListArray)?[1] as? Int,
            999
        )
        
        XCTAssertEqual(
            (pl.root.any(key: "TestDict").value as? PListDictionary)?.count,
            2
        )
        
        XCTAssertEqual(
            pl.root.any(key: "TestBool").value as? Bool,
            true
        )
        
        XCTAssertEqual(
            pl.root.any(key: "TestData").value as? Data,
            Data([0x00, 0xFF])
        )
        
        XCTAssertEqual(
            pl.root.any(key: "TestDate").value as? Date,
            Date(timeIntervalSince1970: 1_527_904_054.0)
        )
        
        XCTAssertEqual(
            pl.root.any(key: "TestDouble").value as? Double,
            456.789
        )
        
        XCTAssertEqual(
            pl.root.any(key: "TestInt").value as? Int,
            234
        )
        
        XCTAssertEqual(
            pl.root.any(key: "TestString").value as? String,
            "A string value"
        )
    }
    
    func testSetAnyKeys() {
        // test setting values using .any(key:)
        
        let pl = DictionaryPList()
        
        pl.root.any(key: "NewString").value = ["A new string", 123]
        XCTAssertEqual(
            (pl.root.any(key: "NewString").value as? PListArray)?[0] as? String,
            "A new string"
        )
        XCTAssertEqual(
            (pl.root.any(key: "NewString").value as? PListArray)?[1] as? Int,
            123
        )
        
        pl.root.any(key: "NewDict").value = ["A": 123, "B": 456]
        XCTAssertEqual(
            (pl.root.any(key: "NewDict").value as? PListDictionary)?["A"] as? Int,
            123
        )
        XCTAssertEqual(
            (pl.root.any(key: "NewDict").value as? PListDictionary)?["B"] as? Int,
            456
        )
        
        pl.root.any(key: "NewBool").value = true
        XCTAssertEqual(
            pl.storage["NewBool"] as? Bool,
            true
        )
        
        pl.root.any(key: "NewData").value = Data([0x00, 0xFF])
        XCTAssertEqual(
            pl.storage["NewData"] as? Data,
            Data([0x00, 0xFF])
        )
        
        let date = Date()
        pl.root.any(key: "NewDate").value = date
        XCTAssertEqual(
            pl.storage["NewDate"] as? Date,
            date
        )
        
        pl.root.any(key: "NewDouble").value = 456.789
        XCTAssertEqual(
            pl.storage["NewDouble"] as? Double,
            456.789
        )
        
        pl.root.any(key: "NewInt").value = 234
        XCTAssertEqual(
            pl.storage["NewInt"] as? Int,
            234
        )
        
        pl.root.any(key: "NewString").value = "A new string"
        XCTAssertEqual(
            pl.storage["NewString"] as? String,
            "A new string"
        )
    }
    
    func testGetTypedKeys() throws {
        // basic value reads using .root
        
        let pl = try kSamplePList.DictRootAllValues.XML.plist()
        
        XCTAssertEqual(
            pl.root.array(key: "TestArray").value?[0] as? String,
            "String value in the array"
        )
        XCTAssertEqual(
            pl.root.array(key: "TestArray").value?[1] as? Int,
            999
        )
        XCTAssertEqual(
            pl.root.bool(key: "TestBool").value,
            true
        )
        XCTAssertEqual(
            pl.root.data(key: "TestData").value,
            Data([0x00, 0xFF])
        )
        XCTAssertEqual(
            pl.root.date(key: "TestDate").value,
            Date(timeIntervalSince1970: 1_527_904_054.0)
        )
        XCTAssertEqual(
            pl.root
                .dict(key: "TestDict")
                .int(key: "DictInt")
                .value,
            789
        )
        XCTAssertEqual(
            pl.root
                .dict(key: "TestDict")
                .string(key: "DictString")
                .value,
            "A dict string value"
        )
        XCTAssertEqual(
            pl.root.double(key: "TestDouble").value,
            456.789
        )
        XCTAssertEqual(
            pl.root.int(key: "TestInt").value,
            234
        )
        XCTAssertEqual(
            pl.root.string(key: "TestString").value,
            "A string value"
        )
        
        XCTAssertEqual(
            pl.root
                .dict(key: "TestNestedDict1")
                .dict(key: "TestNestedDict2")
                .string(key: "NestedString")
                .value,
            "A nested string value"
        )
    }
    
    func testArrayMutation() throws {
        // ensure arrays can be modified directly
        
        let pl = try kSamplePList.DictRootAllValues.XML.plist()
        
        pl.root.array(key: "TestArray").value?[0] = "new string"
        XCTAssertEqual(
            pl.root.array(key: "TestArray").value?[0] as? String,
            "new string"
        )
        
        pl.root.array(key: "TestArray").value?.append("appended item")
        XCTAssertEqual(
            pl.root.array(key: "TestArray").value?[2] as? String,
            "appended item"
        )
    }
    
    func testCreateIntermediateDictionaries() {
        let pl = DictionaryPList()
        
        pl.createIntermediateDictionaries = false
        
        // attempt to set a value in nested dictionaries that don't exist
        
        pl.root
            .dict(key: "Dict1")
            .dict(key: "Nested Dict")
            .string(key: "a string")
            .value = "string value"
        
        XCTAssertEqual(pl.root.value.count, 0)
        
        XCTAssertNil(
            pl.root
                .dict(key: "Dict1")
                .value
        )
        
        XCTAssertNil(
            pl.root
                .dict(key: "Dict1")
                .dict(key: "Nested Dict")
                .value
        )
        
        XCTAssertNil(
            pl.root
                .dict(key: "Dict1")
                .dict(key: "Nested Dict")
                .string(key: "a string")
                .value
        )
        
        // create nested dictionaries and set a value
        
        pl.createIntermediateDictionaries = true
        
        pl.root
            .dict(key: "Dict1")
            .dict(key: "Nested Dict")
            .string(key: "a string")
            .value = "string value"
        
        XCTAssertEqual(
            pl.root
                .dict(key: "Dict1")
                .dict(key: "Nested Dict")
                .string(key: "a string")
                .value,
            "string value"
        )
    }
    
    func testStoringPListNodeObjects() throws {
        // test to ensure that root and sub-objects can be stored in variables and subsequently acted upon
        
        let pl = try kSamplePList.DictRootAllValues.XML.plist()
        
        let root = pl.root
        
        XCTAssertEqual(
            root.array(key: "TestArray").value?[string: 0],
            "String value in the array"
        )
        XCTAssertEqual(
            root.array(key: "TestArray").value?[int: 1],
            999
        )
        XCTAssertEqual(
            root.bool(key: "TestBool").value,
            true
        )
        XCTAssertEqual(
            root.data(key: "TestData").value,
            Data([0x00, 0xFF])
        )
        XCTAssertEqual(
            root.date(key: "TestDate").value,
            Date(timeIntervalSince1970: 1_527_904_054.0)
        )
        XCTAssertEqual(
            root
                .dict(key: "TestDict")
                .int(key: "DictInt")
                .value,
            789
        )
        XCTAssertEqual(
            root
                .dict(key: "TestDict")
                .string(key: "DictString")
                .value,
            "A dict string value"
        )
        XCTAssertEqual(
            root.double(key: "TestDouble").value,
            456.789
        )
        XCTAssertEqual(
            root.int(key: "TestInt").value,
            234
        )
        XCTAssertEqual(
            root.string(key: "TestString").value,
            "A string value"
        )
        
        let nestedDict = root.dict(key: "TestNestedDict1")
        
        XCTAssertEqual(
            nestedDict
                .dict(key: "TestNestedDict2")
                .string(key: "NestedString")
                .value,
            "A nested string value"
        )
    }
    
    func testNumberCasting() throws {
        // test ground rules that were implemented regarding Int and Double casting
        // as a workaround of PropertyListSerialization's merging of <integer> and <real> types into NSNumber
        
        let pl = DictionaryPList()
        
        pl.root.double(key: "double").value = 123
        pl.root.int(key: "int").value = 123
        
        // serialize plist then load it again
        
        let data = try pl.rawData(format: .xml)
        
        let pl2 = try DictionaryPList(data: data)
        
        // both cast/convert as a Double
        
        XCTAssertEqual(pl2.root.double(key: "double").value, 123.0)
        XCTAssertEqual(pl2.root.double(key: "int").value, 123.0)
        
        // both cast/convert as an Int
        
        XCTAssertEqual(pl2.root.int(key: "double").value, 123)
        XCTAssertEqual(pl2.root.int(key: "int").value, 123)
    }
}

#endif
