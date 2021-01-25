//
//  PListKit Tests.swift
//  PListKit
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

#if !os(watchOS)

import XCTest
@testable import PListKit
import OTCore

class PList_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - Boilerplate
	
	fileprivate let samplePList = """
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
		<plist version="1.0">
		<dict>
			<key>TestArray</key>
			<array>
				<string>String value in the array</string>
				<integer>999</integer>
			</array>
			<key>TestBool</key>
			<true/>
			<key>TestData</key>
			<data>AP8=</data>
			<key>TestDate</key>
			<date>2018-06-02T01:47:34Z</date>
			<key>TestDict</key>
			<dict>
				<key>DictInt</key>
				<integer>789</integer>
				<key>DictString</key>
				<string>A dict string value</string>
			</dict>
			<key>TestDouble</key>
			<real>456.789</real>
			<key>TestInt</key>
			<integer>234</integer>
			<key>TestNestedDict1</key>
			<dict>
				<key>TestNestedDict2</key>
				<dict>
					<key>NestedString</key>
					<string>A nested string value</string>
				</dict>
			</dict>
			<key>TestString</key>
			<string>A string value</string>
		</dict>
		</plist>
		"""
	
	
	// MARK: - Constructors / File Load
	
	func testInit() {
		
		let pl = PList()
		
		XCTAssertNil( pl.filePath)
		XCTAssertNil( pl.fileURL)
		XCTAssertTrue(pl.storage.isEmpty)
		
	}
	
	func testInitLoadFailure() {
		
		// test failable inits
		
		XCTAssertNil(PList(fromURL: URL(fileURLWithPath: "/aldkfjalkfgjalkfdja8u248jv34cf")))
		XCTAssertNil(PList(fromFile: "asdfsdflk44ucr384cuwurm9xu38fnianaif"))
		
		XCTAssertNil(PList(data: Data([0,1,0,3,6,9])))
		
	}
	
	func testLoadResult() {
		
		let pl = PList()
		var result: Result<NSNull, PList.LoadError>
		
		// success
		
		result = pl.load(data: samplePList.data(using: .utf8)!)
		XCTAssertEqual(result, .success(NSNull()))
		
		// failure
		
		result = pl.load(fromURL: URL(fileURLWithPath: "/aldkfjalkfgjalkfdja8u248jv34cf"))
		XCTAssertNotEqual(result, .success(NSNull()))
		
	}
	
	func testInitFromURLandFile() {
		
		// write sample plist to disk
		
		let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
		
		let randomFileName = "temp-\(UUID().uuidString).plist"
		
		let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
		
		guard (try? samplePList.write(to: url, atomically: false, encoding: .utf8)) != nil else {
			XCTFail("Could not write temporary plist file to disk. Can't continue test.")
			return
		}
		
		// init(fromURL:)
		
		var pl: PList?
		
		pl = PList(fromURL: url)
		
		if pl == nil {
			XCTFail("Could not init PList from file URL. Can't continue test.")
			return
		}
		
		XCTAssertEqual(pl?.storage.count, 9)	// sample plist has 9 root-level keys
		
		XCTAssertEqual(pl?.storage[array:  "TestArray"]?.count					, 2)
		XCTAssertEqual(pl?.storage[array:  "TestArray"]?[0] as? String			, "String value in the array")
		XCTAssertEqual(pl?.storage[array:  "TestArray"]?[1] as? Int				, 999)
		
		XCTAssertEqual(pl?.storage[dict:   "TestDict"]?.count					, 2)
		XCTAssertEqual(pl?.storage[dict:   "TestDict"]?[int: "DictInt"]			, 789)
		XCTAssertEqual(pl?.storage[dict:   "TestDict"]?[string: "DictString"]	, "A dict string value")
		
		XCTAssertEqual(pl?.storage[dict:   "TestNestedDict1"]?[dict: "TestNestedDict2"]?.count, 1)
		XCTAssertEqual(pl?.storage[dict:   "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "NestedString"], "A nested string value")
		
		XCTAssertEqual(pl?.storage[bool:   "TestBool"]			, true)
		XCTAssertEqual(pl?.storage[data:   "TestData"]			, Data([0x00, 0xFF]))
		XCTAssertEqual(pl?.storage[date:   "TestDate"]			, Date(timeIntervalSince1970: 1527904054.0))
		XCTAssertEqual(pl?.storage[double: "TestDouble"]		, 456.789)
		XCTAssertEqual(pl?.storage[int:    "TestInt"]			, 234)
		XCTAssertEqual(pl?.storage[string: "TestString"]		, "A string value")
		
		// init(fromFile:)
		
		pl = nil
		
		pl = PList(fromFile: url.path)
		
		if pl == nil {
			XCTFail("Could not init PList from file path. Can't continue test.")
			return
		}
		
		// just do a basic check to see if file loaded correctly, since init(fromURL:) calls out to the same parsing code and we already tested that above
		XCTAssertEqual(pl?.storage.count, 9)
		
		// clean up
		
		print("Cleaning up file(s)...")
		
		XCTAssertNoThrow(try url.trashOrDelete())
		
	}
	
	func testInitFromDictionary() {
		
		// empty dict
		
		let dict1: PList.PListDictionary = [:]
		
		let pl1 = PList(fromDictionary: dict1)
		
		XCTAssertEqual(pl1.storage.count, 0)
		
		// dict with content
		
		let dict2: PList.PListDictionary = ["key1" : 123,
											"key2" : 456.789,
											"key3" : "A string"]
		
		let pl2 = PList(fromDictionary: dict2)
		
		XCTAssertEqual(pl2.storage.count, 3)
		
		XCTAssertEqual(pl2.storage[int: "key1"]		, 123)
		XCTAssertEqual(pl2.storage[double: "key2"]	, 456.789)
		XCTAssertEqual(pl2.storage[string: "key3"]	, "A string")
		
	}
	
	
	// MARK: - File Save
	
	func testSaveFailure() {
		
		let pl = PList(data: samplePList.data(using: .utf8)!)
		
		// no filePath or fileURL set, save will fail
		
		XCTAssertNil(try? pl?.save())
		XCTAssertNil(try? pl?.save(format: .xml))
		XCTAssertNil(try? pl?.save(format: .binary))
		
	}
	
	func testSave() {
		
		let pl = PList(data: samplePList.data(using: .utf8)!)
		XCTAssertEqual(pl?.storage.count, 9) // basic data load check
		
		// prep target filename
		
		let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
		
		let randomFileName1 = "temp-\(UUID().uuidString).plist"
		let url1 = temporaryDirectoryURL.appendingPathComponent(randomFileName1)
		
		// save file
		
		pl?.format = .xml
		try? pl?.save(toURL: url1)
		
		XCTAssertTrue(url1.fileExists) // file written to disk
		
		let randomFileName2 = "temp-\(UUID().uuidString).plist"
		let url2 = temporaryDirectoryURL.appendingPathComponent(randomFileName2)
		
		pl?.format = .binary
		try? pl?.save(toFile: url2.path)
		
		XCTAssertTrue(url2.fileExists) // file written to disk
		
		// clean up
		
		print("Cleaning up file(s)...")
		
		XCTAssertNoThrow(try url1.trashOrDelete())
		XCTAssertNoThrow(try url2.trashOrDelete())
		
	}
	
	
	func testRawData() {
		
		let pl = PList(data: samplePList.data(using: .utf8)!)
		XCTAssertEqual(pl?.storage.count, 9) // basic data load check
		
		// check that rawData succeeds
		
		// xml
		let rawDataXML = try? pl?.rawData(format: .xml)
		XCTAssertNotNil(rawDataXML)
		XCTAssertGreaterThan(rawDataXML?.count ?? 0, 780)		// basic data size check
		
		// binary
		let rawDataBinary = try? pl?.rawData(format: .binary)
		XCTAssertNotNil(rawDataBinary)
		XCTAssertGreaterThan(rawDataBinary?.count ?? 0, 380)	// basic data size check
		
		// check integrity of data
		
		// xml
		let plFromXML = PList(data: rawDataXML!)
		XCTAssertNotNil(plFromXML)
		XCTAssertEqual(plFromXML?.storage.count, 9) // basic data load check
		
		// binary
		let plFromBinary = PList(data: rawDataBinary!)
		XCTAssertNotNil(plFromBinary)
		XCTAssertEqual(plFromBinary?.storage.count, 9) // basic data load check
		
	}
	
	
	// MARK: - Data Accessors
	
	func testSubscript_BasicSetGet() {
		
		// basic types and setters/getters
		
		let pl = PList()
		
		pl.storage[string: "TestString"] = "A test string"
		XCTAssertEqual(pl.storage[string: "TestString"], "A test string")	// String?
		
		pl.storage[int: "TestInt"] = 10
		XCTAssertEqual(pl.storage[int: "TestInt"], 10)						// Int?
		
		pl.storage[double: "TestDouble"] = 5.2
		XCTAssertEqual(pl.storage[double: "TestDouble"], 5.2)				// Double?
		
		pl.storage[bool: "TestBool"] = true
		XCTAssertEqual(pl.storage[bool: "TestBool"], true)					// Bool?
		
		let date = Date()
		pl.storage[date: "TestDate"] = date
		XCTAssertEqual(pl.storage[date: "TestDate"], date)					// Date?
		
		pl.storage[data: "TestData"] = Data([1,5,10,15])
		XCTAssertEqual(pl.storage[data: "TestData"], Data([1,5,10,15]))		// Data?
		
		// PListArray?, aka: Array<PListValue>
		pl.storage[array: "TestArray"] = [1,2,3]
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
	
	func testSubscript_GetAny() {
		
		let pl = PList(data: samplePList.data(using: .utf8)!)
		XCTAssertEqual(pl?.storage.count, 9) // basic data load check
		
		let val = pl?.storage[any: "TestString"]
		
		// type check
		
		XCTAssertTrue (val is String)
		XCTAssertFalse(val is Int)
		XCTAssertFalse(val is Double)
		XCTAssertFalse(val is Bool)
		XCTAssertFalse(val is Date)
		XCTAssertFalse(val is Data)
		XCTAssertFalse(val is PList.PListArray)
		XCTAssertFalse(val is PList.PListDictionary)
		
		XCTAssertEqual(val as? String, "A string value")
		
		// set
		
		pl?.storage[any: "TestAny"] = 123
		XCTAssertEqual(pl?.storage[any: "TestAny"] as? Int, 123)
		
		pl?.storage[any: "TestAny"] = "A new string"
		XCTAssertEqual(pl?.storage[any: "TestAny"] as? String, "A new string")
		
	}
	
	func testSubscript_Array() {
		
		// PListArray?, aka: Array<PListValue>
		
		let pl = PList()
		
		XCTAssertNil(pl.storage[array: "TestArray"])
		
		pl.storage[array: "TestArray"] = [1,2,3]
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
		pl.storage[array: "TestArray"]?.append(Data([1,2,3]))
		pl.storage[array: "TestArray"]?.append([])
		pl.storage[array: "TestArray"]?.append([:])
		
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 as? String == "A string" })	, true)
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 as? Int == 1 })				, true)
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 as? Double == 5.2 })		, true)
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 as? Bool == true })			, true)
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 as? Date == date })			, true)
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 as? Data == Data([1,2,3]) }), true)
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 is PList.PListArray })		, true)
		XCTAssertEqual(pl.storage[array: "TestArray"]?.contains(where: { $0 is PList.PListDictionary })	, true)
		
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
		
		pl.storage[dict: "TestDict"]?[dict: "NestedDict"]?[string: "NestedString"] = "A nested string"
		XCTAssertEqual(pl.storage[dict: "TestDict"]?[dict: "NestedDict"]?[string: "NestedString"], "A nested string")
		
		// copy dict
		pl.storage[dict: "TestDict2"] = pl.storage[dict: "TestDict"]
		XCTAssertNotNil(pl.storage[dict: "TestDict2"])
		XCTAssertEqual( pl.storage[dict: "TestDict2"]?[dict: "NestedDict"]?[string: "NestedString"], "A nested string")
		
		// get keys
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getStringKeys.first, "DictString")
		XCTAssertNil(  pl.storage[dict: "TestDict"]?.getIntKeys.first)
		XCTAssertNil(  pl.storage[dict: "TestDict"]?.getDoubleKeys.first)
		XCTAssertNil(  pl.storage[dict: "TestDict"]?.getBoolKeys.first)
		XCTAssertNil(  pl.storage[dict: "TestDict"]?.getDateKeys.first)
		XCTAssertNil(  pl.storage[dict: "TestDict"]?.getDataKeys.first)
		XCTAssertNil(  pl.storage[dict: "TestDict"]?.getArrayKeys.first)
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDictionaryKeys.first, "NestedDict")
		
		// get key pairs
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getStringKeyPairs, ["DictString" : "Dictionary string"])
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getIntKeyPairs  , [:])
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDoubleKeyPairs, [:])
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getBoolKeyPairs , [:])
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDateKeyPairs , [:])
		XCTAssertEqual(pl.storage[dict: "TestDict"]?.getDataKeyPairs , [:])
		
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
	
	func testPListRawDictionary() {
		
		let dict: PList.RawDictionary = ["A key" as NSString : 123 as NSNumber]
		
		let newDict: PList.PListDictionary? = dict.PListDictionaryRepresentation
		XCTAssertNotNil(newDict)
		XCTAssertEqual(newDict?.count, 1)
		XCTAssertEqual(newDict?[int: "A key"], 123)
		
	}
	
	func testPListRawArray() {
		
		let array: PList.RawArray = ["A key" as NSString, 123 as NSNumber]
		
		let newArray: PList.PListArray? = array.PListArrayRepresentation
		XCTAssertNotNil(newArray)
		XCTAssertEqual(newArray?.count, 2)
		XCTAssertEqual(newArray?[0] as? String, "A key")
		XCTAssertEqual(newArray?[1] as? Int, 123)
		
	}
	
	func testPListNode_samplePList() {
		
		// basic value reads using .root
		
		let pl = PList(data: samplePList.data(using: .utf8)!)!
		XCTAssertEqual(pl.storage.count, 9) // basic data load check
		
		XCTAssertEqual(pl.root.array (key: "TestArray") .value?[0] as? String	, "String value in the array")
		XCTAssertEqual(pl.root.array (key: "TestArray") .value?[1] as? Int		, 999)
		XCTAssertEqual(pl.root.bool  (key: "TestBool")  .value					, true)
		XCTAssertEqual(pl.root.data  (key: "TestData")  .value					, Data([0x00, 0xFF]))
		XCTAssertEqual(pl.root.date  (key: "TestDate")  .value					, Date(timeIntervalSince1970: 1527904054.0))
		XCTAssertEqual(pl.root
						.dict(key: "TestDict")
						.int(key: "DictInt")
						.value													, 789)
		XCTAssertEqual(pl.root
						.dict(key: "TestDict")
						.string(key: "DictString")
						.value													, "A dict string value")
		XCTAssertEqual(pl.root.double(key: "TestDouble").value					, 456.789)
		XCTAssertEqual(pl.root.int   (key: "TestInt")   .value					, 234)
		XCTAssertEqual(pl.root.string(key: "TestString").value					, "A string value")
		
		XCTAssertEqual(pl.root
						.dict(key: "TestNestedDict1")
						.dict(key: "TestNestedDict2")
						.string(key: "NestedString")
						.value													, "A nested string value")
		
	}
	
	func testPListNode_ArrayMutation() {
		
		// ensure arrays can be modified directly
		
		let pl = PList(data: samplePList.data(using: .utf8)!)!
		XCTAssertEqual(pl.storage.count, 9) // basic data load check
		
		pl.root.array(key: "TestArray").value?[0] = "new string"
		XCTAssertEqual(pl.root.array (key: "TestArray") .value?[0] as? String	, "new string")
		
		pl.root.array(key: "TestArray").value?.append("appended item")
		XCTAssertEqual(pl.root.array (key: "TestArray") .value?[2] as? String	, "appended item")
		
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
		
		XCTAssertNil(pl.root
						.dict(key: "Dict1")
						.value)
		
		XCTAssertNil(pl.root
						.dict(key: "Dict1")
						.dict(key: "Nested Dict")
						.value)
		
		XCTAssertNil(pl.root
						.dict(key: "Dict1")
						.dict(key: "Nested Dict")
						.string(key: "a string")
						.value)
		
		// create nested dictionaries and set a value
		
		pl.createIntermediateDictionaries = true
		
		pl.root
			.dict(key: "Dict1")
			.dict(key: "Nested Dict")
			.string(key: "a string")
			.value = "string value"
		
		XCTAssertEqual(pl.root
						.dict(key: "Dict1")
						.dict(key: "Nested Dict")
						.string(key: "a string")
						.value,
					   "string value")
		
	}
	
	func testPListNode_StoringPListNodeObjects() {
		
		// test to ensure that root and sub-objects can be stored in variables and subsequently acted upon
		
		let pl = PList(data: samplePList.data(using: .utf8)!)!
		XCTAssertEqual(pl.storage.count, 9) // basic data load check
		
		let root = pl.root
		
		XCTAssertEqual(root.array (key: "TestArray") .value?[0] as? String	, "String value in the array")
		XCTAssertEqual(root.array (key: "TestArray") .value?[1] as? Int		, 999)
		XCTAssertEqual(root.bool  (key: "TestBool")  .value					, true)
		XCTAssertEqual(root.data  (key: "TestData")  .value					, Data([0x00, 0xFF]))
		XCTAssertEqual(root.date  (key: "TestDate")  .value					, Date(timeIntervalSince1970: 1527904054.0))
		XCTAssertEqual(root
						.dict(key: "TestDict")
						.int(key: "DictInt")
						.value												, 789)
		XCTAssertEqual(root
						.dict(key: "TestDict")
						.string(key: "DictString")
						.value												, "A dict string value")
		XCTAssertEqual(root.double(key: "TestDouble").value					, 456.789)
		XCTAssertEqual(root.int   (key: "TestInt")   .value					, 234)
		XCTAssertEqual(root.string(key: "TestString").value					, "A string value")
		
		let nestedDict = root.dict(key: "TestNestedDict1")
		
		XCTAssertEqual(nestedDict
						.dict(key: "TestNestedDict2")
						.string(key: "NestedString")
						.value												, "A nested string value")
		
	}
	
	func testNumberCasting() {
		
		// test ground rules that were implemented regarding Int and Double casting
		// as a workaround of PropertyListSerialization's merging of <integer> and <real> types into NSNumber
		
		let pl = PList()
		
		pl.root.double(key: "double").value = 123
		pl.root.int(key: "int").value = 123
		
		// serialize plist then load it again
		
		let data = try! pl.rawData(format: .xml)
		
		let pl2 = PList(data: data)!
		
		// both cast/convert as a Double
		
		XCTAssertEqual(pl2.root.double(key: "double").value, 123.0)
		XCTAssertEqual(pl2.root.double(key: "int").value, 123.0)
		
		// both cast/convert as an Int
		
		XCTAssertEqual(pl2.root.int(key: "double").value, 123)
		XCTAssertEqual(pl2.root.int(key: "int").value, 123)
		
	}
	
	func testNSCopying() {
		
		let pl = PList(data: samplePList.data(using: .utf8)!)!
		XCTAssertEqual(pl.storage.count, 9) // basic data load check
		
		// set up other properties
		
		pl.format = .openStep
		
		// make copy
		
		let copy = pl.copy() as! PList
		
		// basic data load check
		
		XCTAssertEqual(copy.storage.count, 9)
		
		// stored properties
		
		XCTAssertEqual(copy.storage.count, 9)
		XCTAssertEqual(copy.format, .openStep)
		
	}
	
}

#endif
