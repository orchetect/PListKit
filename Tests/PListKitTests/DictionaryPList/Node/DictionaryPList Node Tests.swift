//
//  DictionaryPList Node Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
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
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSetAndOverwrite_InRoot_Array() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = false
        
        // set
        pl.root.array(key: "NewArray").value = [123, "A string"]
        let arr = try XCTUnwrap(pl.storage["NewArray"] as? PListArray)
        XCTAssertEqual(arr.count, 2)
        XCTAssertEqual(arr[0] as? Int, 123)
        XCTAssertEqual(arr[1] as? String, "A string")
        
        // overwrite
        pl.root.array(key: "NewArray").value = [456]
        let arr2 = try XCTUnwrap(pl.storage["NewArray"] as? PListArray)
        XCTAssertEqual(arr2.count, 1)
        XCTAssertEqual(arr2[0] as? Int, 456)
        
        // nil
        pl.root.array(key: "NewArray").value = nil
        XCTAssertNil(pl.storage["NewArray"])
    }
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSet_InRoot_Dictionary() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = true
        
        // set
        pl.root.dict(key: "NewDict").value = ["Key1": 123, "Key2": "A string"]
        let dict = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict.count, 2)
        XCTAssertEqual(dict["Key1"] as? Int, 123)
        XCTAssertEqual(dict["Key2"] as? String, "A string")
        
        // overwrite
        pl.root.dict(key: "NewDict").value = ["Key3": 456]
        let dict2 = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict2.count, 1)
        XCTAssertEqual(dict2["Key3"] as? Int, 456)
        
        // nil
        pl.root.dict(key: "NewDict").value = nil
        XCTAssertNil(pl.storage["NewDict"])
    }
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSet_InRoot_Bool() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = false
        
        // set
        pl.root.bool(key: "NewBool").value = true
        XCTAssertEqual(pl.storage["NewBool"] as? Bool, true)
        
        // overwrite
        pl.root.bool(key: "NewBool").value = false
        XCTAssertEqual(pl.storage["NewBool"] as? Bool, false)
        
        // nil
        pl.root.dict(key: "NewBool").value = nil
        XCTAssertNil(pl.storage["NewBool"])
    }
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSet_InRoot_Data() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = false
        
        // set
        pl.root.data(key: "NewData").value = Data([0x00, 0xFF])
        XCTAssertEqual(pl.storage["NewData"] as? Data, Data([0x00, 0xFF]))
        
        // overwrite
        pl.root.data(key: "NewData").value = Data([0x01])
        XCTAssertEqual(pl.storage["NewData"] as? Data, Data([0x01]))
        
        // nil
        pl.root.data(key: "NewData").value = nil
        XCTAssertNil(pl.storage["NewData"])
    }
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSet_InRoot_Date() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = false
        
        // set
        pl.root.date(key: "NewDate").value = Date(timeIntervalSince1970: 1_527_904_054.0)
        XCTAssertEqual(pl.storage["NewDate"] as? Date, Date(timeIntervalSince1970: 1_527_904_054.0))
        
        // overwrite
        pl.root.date(key: "NewDate").value = Date(timeIntervalSince1970: 1_527_904_055.0)
        XCTAssertEqual(pl.storage["NewDate"] as? Date, Date(timeIntervalSince1970: 1_527_904_055.0))
        
        // nil
        pl.root.date(key: "NewDate").value = nil
        XCTAssertNil(pl.storage["NewDate"])
    }
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSet_InRoot_Double() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = false
        
        // set
        pl.root.double(key: "NewDouble").value = 456.789
        XCTAssertEqual(pl.storage["NewDouble"] as? Double, 456.789)
        
        // overwrite
        pl.root.double(key: "NewDouble").value = 123.5
        XCTAssertEqual(pl.storage["NewDouble"] as? Double, 123.5)
        
        // nil
        pl.root.double(key: "NewDouble").value = nil
        XCTAssertNil(pl.storage["NewDouble"])
    }
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSet_InRoot_Int() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = false
        
        // set
        pl.root.int(key: "NewInt").value = 234
        XCTAssertEqual(pl.storage["NewInt"] as? Int, 234)
        
        // overwrite
        pl.root.int(key: "NewInt").value = 456
        XCTAssertEqual(pl.storage["NewInt"] as? Int, 456)
        
        // nil
        pl.root.int(key: "NewInt").value = nil
        XCTAssertNil(pl.storage["NewInt"])
    }
    
    /// Ensure `.value` setter works for:
    /// 1. setting value for a new key
    /// 2. overwriting value for an existing key
    /// 3. removing key by setting value to `nil`
    func testSet_InRoot_String() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = false
        
        // set
        pl.root.string(key: "NewString").value = "A new string"
        XCTAssertEqual(pl.storage["NewString"] as? String, "A new string")
        
        // overwrite
        pl.root.string(key: "NewString").value = "A newer string"
        XCTAssertEqual(pl.storage["NewString"] as? String, "A newer string")
        
        // nil
        pl.root.string(key: "NewString").value = nil
        XCTAssertNil(pl.storage["NewString"])
    }
    
    func testSet_Nested_Dictionary1() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = true
        
        // create new dictionary in root
        pl.root
            .dict(key: "NewDict")
            .value = ["Key1": 123, "Key2": "A string"]
        // verify root
        XCTAssertEqual(pl.root.value.count, 1)
        // verify first dict
        let dict = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict.count, 2)
        XCTAssertEqual(dict["Key1"] as? Int, 123)
        XCTAssertEqual(dict["Key2"] as? String, "A string")
        
        // add a nested dictionary
        pl.root
            .dict(key: "NewDict")
            .dict(key: "NestedDict")
            .value = ["Key3": 456]
        // verify root
        XCTAssertEqual(pl.root.value.count, 1)
        // re-verify first dict contents are the same, but with the added nested dict
        let dict2A = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict2A.count, 3) // +1 for nested dict
        XCTAssertEqual(dict2A["Key1"] as? Int, 123)
        XCTAssertEqual(dict2A["Key2"] as? String, "A string")
        // verify nested dict
        let dict2B = try XCTUnwrap(dict2A["NestedDict"] as? PListDictionary)
        XCTAssertEqual(dict2B.count, 1)
        XCTAssertEqual(dict2B["Key3"] as? Int, 456)
        
        // overwrite nested dictionary
        pl.root
            .dict(key: "NewDict")
            .dict(key: "NestedDict")
            .value = ["Key4": 789, "Key5": 111]
        // verify root
        XCTAssertEqual(pl.root.value.count, 1)
        // re-verify first dict contents are the same, but with the added nested dict
        let dict3A = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict3A.count, 3) // +1 for nested dict
        XCTAssertEqual(dict3A["Key1"] as? Int, 123)
        XCTAssertEqual(dict3A["Key2"] as? String, "A string")
        // verify nested dict
        let dict3B = try XCTUnwrap(dict3A["NestedDict"] as? PListDictionary)
        XCTAssertEqual(dict3B.count, 2)
        XCTAssertEqual(dict3B["Key4"] as? Int, 789)
        XCTAssertEqual(dict3B["Key5"] as? Int, 111)
        
        // nil nested dictionary
        pl.root
            .dict(key: "NewDict")
            .dict(key: "NestedDict")
            .value = nil
        // verify root
        XCTAssertEqual(pl.root.value.count, 1)
        // re-verify first dict contents are the same, but with the added nested dict
        let dict4A = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict4A.count, 2) // +1 for nested dict
        XCTAssertEqual(dict4A["Key1"] as? Int, 123)
        XCTAssertEqual(dict4A["Key2"] as? String, "A string")
        // verify nested dict
        let dict4B = dict4A["NestedDict"] as? PListDictionary
        XCTAssertNil(dict4B)
    }
    
    func testSet_Nested_Dictionary2() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = true
        
        // create new dictionary in root
        pl.root
            .dict(key: "NewDict")
            .value = [
                "Key1": 123,
                "Key2": "A string",
                "NestedDict": ["Key3": 456]
            ]
        // verify root
        XCTAssertEqual(pl.root.value.count, 1)
        // verify first dict
        let dict2A = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict2A.count, 3) // +1 for nested dict
        XCTAssertEqual(dict2A["Key1"] as? Int, 123)
        XCTAssertEqual(dict2A["Key2"] as? String, "A string")
        // verify nested dict
        let dict2B = try XCTUnwrap(dict2A["NestedDict"] as? PListDictionary)
        XCTAssertEqual(dict2B.count, 1)
        XCTAssertEqual(dict2B["Key3"] as? Int, 456)
        
        // nil first dictionary
        pl.root
            .dict(key: "NewDict")
            .value = nil
        // verify root
        XCTAssertEqual(pl.root.value.count, 0)
        // verify first dict
        let dict4A = pl.storage["NewDict"] as? PListDictionary
        XCTAssertNil(dict4A)
        // verify nested dict
        let dict4B = dict4A?["NestedDict"] as? PListDictionary
        XCTAssertNil(dict4B)
    }
    
    func testSet_Nested_Dictionary3() throws {
        let pl = DictionaryPList()
        pl.createIntermediateDictionaries = true
        
        // create new dictionary in root
        pl.root
            .dict(key: "NewDict")
            .value = [
                "Key1": 123,
                "Key2": "A string",
                "NestedDict": ["Key3": 456]
            ]
        // verify first dict
        let dict2A = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict2A.count, 3) // +1 for nested dict
        XCTAssertEqual(dict2A["Key1"] as? Int, 123)
        XCTAssertEqual(dict2A["Key2"] as? String, "A string")
        // verify nested dict
        let dict2B = try XCTUnwrap(dict2A["NestedDict"] as? PListDictionary)
        XCTAssertEqual(dict2B.count, 1)
        XCTAssertEqual(dict2B["Key3"] as? Int, 456)
        
        // overwrite first dictionary
        pl.root
            .dict(key: "NewDict")
            .value = ["Key4": 789, "Key5": 111]
        // verify root
        XCTAssertEqual(pl.root.value.count, 1)
        // verify first dict
        let dict4A = try XCTUnwrap(pl.storage["NewDict"] as? PListDictionary)
        XCTAssertEqual(dict4A.count, 2)
        XCTAssertEqual(dict4A["Key4"] as? Int, 789)
        XCTAssertEqual(dict4A["Key5"] as? Int, 111)
        // verify nested dict
        let dict4B = dict4A["NestedDict"] as? PListDictionary
        XCTAssertNil(dict4B)
    }
    
    func testStoringPListNodeObjects() throws {
        // test to ensure that root and sub-objects can be stored in variables and subsequently
        // acted upon
        
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
        // as a workaround of PropertyListSerialization's merging of <integer> and <real> types into
        // NSNumber
        
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
