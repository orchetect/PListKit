//
//  Data Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//

#if !os(watchOS)

import XCTest
import PListKit

class DataTests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - RawData
    
    func testRawData() throws {
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
        // check that rawData succeeds
        
        // xml
        let rawDataXML = try pl.rawData(format: .xml)
        let plFromXML = try PList(data: rawDataXML)
        verifySamplePListContent(plFromXML)
        
        // binary
        let rawDataBinary = try pl.rawData(format: .binary)
        let plFromBinary = try PList(data: rawDataBinary)
        verifySamplePListContent(plFromBinary)
        
        // openStep
        // Apple docs:
        // "The NSPropertyListOpenStepFormat constant is not supported for writing. It can be used only for reading old-style property lists."
    }
    
    // MARK: - Data Subscripts
    
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
    
    func testSubscript_Array() {
        // PListArray?, aka: Array<PListValue>
        
        let pl = PList()
        
        XCTAssertNil(pl.storage[array: "TestArray"])
        
        pl.storage[array: "TestArray"] = [1, 2, 3]
        XCTAssertEqual(pl.storage[array: "TestArray"]?[0] as? Int, 1)
        XCTAssertEqual(pl.storage[array: "TestArray"]?[1] as? Int, 2)
        XCTAssertEqual(pl.storage[array: "TestArray"]?[2] as? Int, 3)
        XCTAssertEqual(pl.storage[array: "TestArray"]?.count, 3)
        
        // update array
        pl.storage[array: "TestArray"]?.append(4)
        XCTAssertEqual(pl.storage[array: "TestArray"]?[3] as? Int, 4)
        XCTAssertEqual(pl.storage[array: "TestArray"]?.count, 4)
        
        // create empty array
        pl.storage[array: "TestArray2"] = []
        XCTAssertNotNil(pl.storage[array: "TestArray2"])
        XCTAssertEqual(pl.storage[array: "TestArray2"]?.count, 0)
        
        // copy array
        pl.storage[array: "TestArray3"] = pl.storage[array: "TestArray"]
        XCTAssertNotNil(pl.storage[array: "TestArray3"])
        XCTAssertEqual(pl.storage[array: "TestArray3"]?.count, 4)
        
        // variety of types in the same array
        pl.storage[array: "TestArray"] = []
        
        pl.storage[array: "TestArray"]?.append("A string")
        pl.storage[array: "TestArray"]?.append(1)
        pl.storage[array: "TestArray"]?.append(5.2)
        pl.storage[array: "TestArray"]?.append(true)
        let date = Date()
        pl.storage[array: "TestArray"]?.append(date)
        pl.storage[array: "TestArray"]?.append(Data([1, 2, 3]))
        pl.storage[array: "TestArray"]?.append([])
        pl.storage[array: "TestArray"]?.append([:])
        
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 as? String == "A string" })
        )
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 as? Int == 1 })
        )
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 as? Double == 5.2 })
        )
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 as? Bool == true })
        )
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 as? Date == date })
        )
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 as? Data == Data([1, 2, 3]) })
        )
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 is PListArray })
        )
        XCTAssertTrue(
            pl.storage[array: "TestArray"]!
                .contains(where: { $0 is PListDictionary })
        )
        
        // delete array
        pl.storage[array: "TestArray"] = nil
        XCTAssertNil(pl.storage[array: "TestArray"])
        
        // inline array create
        pl.storage[arrayCreate: "TestArrayNew1"]?.append("A substring")
        XCTAssertEqual(pl.storage[array: "TestArrayNew1"]?.count, 1)
        XCTAssertEqual(pl.storage[array: "TestArrayNew1"]?[0] as? String, "A substring")
        
        XCTAssertEqual(pl.storage[arrayCreate: "TestArrayNew2"]?.count, 0)
    }
    
    func testSubscript_Dictionary() {
        // PListDictionary?, aka: Dictionary<String, PListValue>
        
        let pl = PList()
        
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
        
        pl
            .storage[dict: "TestDict"]?[dict: "NestedDict"]?[string: "NestedString"] =
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
    
    // MARK: - Data Collection Types
    
    func testPListRawDictionary_convertedToPListDictionary() {
        let dict: PList.RawDictionary = ["A key" as NSString: 123 as NSNumber]
        
        let newDict: PListDictionary? = dict.convertedToPListDictionary()
        XCTAssertNotNil(newDict)
        XCTAssertEqual(newDict?.count, 1)
        XCTAssertEqual(newDict?[int: "A key"], 123)
    }
    
    func testPListRawArray_convertedToPListArray() {
        let array: PList.RawArray = [
            "A key" as NSString,
            123 as NSNumber
        ]
        
        let newArray: PListArray? = array.convertedToPListArray()
        XCTAssertNotNil(newArray)
        XCTAssertEqual(newArray?.count, 2)
        XCTAssertEqual(newArray?[0] as? String, "A key")
        XCTAssertEqual(newArray?[1] as? Int, 123)
    }
    
    // MARK: - Data Nodes
    
    func testPListNode() throws {
        // basic value reads using .root
        
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
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
    
    func testPListNode_ArrayMutation() throws {
        // ensure arrays can be modified directly
        
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
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
    
    func testPListNode_createIntermediateDictionaries() {
        let pl = PList()
        
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
    
    func testPListNode_StoringPListNodeObjects() throws {
        // test to ensure that root and sub-objects can be stored in variables and subsequently acted upon
        
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
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
        
        let pl = PList()
        
        pl.root.double(key: "double").value = 123
        pl.root.int(key: "int").value = 123
        
        // serialize plist then load it again
        
        let data = try pl.rawData(format: .xml)
        
        let pl2 = try PList(data: data)
        
        // both cast/convert as a Double
        
        XCTAssertEqual(pl2.root.double(key: "double").value, 123.0)
        XCTAssertEqual(pl2.root.double(key: "int").value, 123.0)
        
        // both cast/convert as an Int
        
        XCTAssertEqual(pl2.root.int(key: "double").value, 123)
        XCTAssertEqual(pl2.root.int(key: "int").value, 123)
    }
    
    func testNSCopying() throws {
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
        // set up other properties
        
        pl.format = .binary
        
        // make copy
        
        let copy = pl.copy() as! PList
        
        // verify contents
        
        verifySamplePListContent(copy)
        
        // verify stored properties
        
        XCTAssertEqual(copy.storage.count, 9)
        XCTAssertEqual(copy.format, .binary)
    }
}

#endif
