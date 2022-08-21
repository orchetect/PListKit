//
//  DictionaryPList Init Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import PListKit

final class DictionaryPList_Init_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit() {
        let pl = DictionaryPList()
        
        XCTAssertTrue(pl.storage.isEmpty)
    }
    
    func testInitLoadFailure() {
        // test throwing inits
        
        XCTAssertThrowsError(
            try DictionaryPList(url: URL(fileURLWithPath: "/aldkfjalkfgjalkfdja8u248jv34cf"))
        )
        
        XCTAssertThrowsError(
            try DictionaryPList(file: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        )
        
        XCTAssertThrowsError(
            try DictionaryPList(data: Data([0, 1, 0, 3, 6, 9]))
        )
        
        XCTAssertThrowsError(
            try DictionaryPList(xml: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        )
    }
    
    func testInit_URL() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePList.DictRootAllValues.XML.raw.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(url:)
        let pl = try DictionaryPList(url: url)
        kSamplePList.DictRootAllValues.verify(matches: pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_File() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePList.DictRootAllValues.XML.raw.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(file:)
        let pl = try DictionaryPList(file: url.path)
        kSamplePList.DictRootAllValues.verify(matches: pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_Data() throws {
        let pl = try DictionaryPList(data: kSamplePList.DictRootAllValues.XML.raw.data(using: .utf8)!)
        kSamplePList.DictRootAllValues.verify(matches: pl)
    }
    
    func testInit_String() throws {
        let pl = try DictionaryPList(xml: kSamplePList.DictRootAllValues.XML.raw)
        kSamplePList.DictRootAllValues.verify(matches: pl)
    }
    
    func testInit_PListDictionary() throws {
        // empty dict
        
        let dict1: PListDictionary = [:]
        
        let pl1 = DictionaryPList(root: dict1)
        
        XCTAssertEqual(pl1.storage.count, 0)
        
        // dict with content
        
        let dict2: PListDictionary = [
            "key1": 123,
            "key2": 456.789,
            "key3": "A string"
        ]
        
        let pl2 = DictionaryPList(root: dict2)
        
        XCTAssertEqual(pl2.storage.count, 3)
        
        XCTAssertEqual(pl2.storage[int: "key1"], 123)
        XCTAssertEqual(pl2.storage[double: "key2"], 456.789)
        XCTAssertEqual(pl2.storage[string: "key3"], "A string")
    }
    
    func testInit_RawDictionary() throws {
        // empty dict
        
        let dict1: RawPListDictionary = [:]
        
        let pl1 = try DictionaryPList(root: dict1)
        
        XCTAssertEqual(pl1.storage.count, 0)
        
        // dict with content
        
        let dict2: RawPListDictionary = [
            "key1" as NSString: 123 as NSNumber,
            "key2" as NSString: 456.789 as NSNumber,
            "key3" as NSString: "A string" as NSString
        ]
        
        let pl2 = try DictionaryPList(root: dict2)
        
        XCTAssertEqual(pl2.storage.count, 3)
        
        XCTAssertEqual(pl2.storage[int: "key1"], 123)
        XCTAssertEqual(pl2.storage[double: "key2"], 456.789)
        XCTAssertEqual(pl2.storage[string: "key3"], "A string")
    }
}

#endif
