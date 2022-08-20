//
//  PList Init Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
import PListKit

class PListInitTests: XCTestCase {
    func testInit() {
        let pl = PList()
        
        XCTAssertNil(pl.filePath)
        XCTAssertNil(pl.fileURL)
        XCTAssertTrue(pl.storage.isEmpty)
    }
    
    func testInitLoadFailure() {
        // test throwing inits
        
        XCTAssertThrowsError(
            try PList(url: URL(fileURLWithPath: "/aldkfjalkfgjalkfdja8u248jv34cf"))
        )
        
        XCTAssertThrowsError(
            try PList(file: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        )
        
        XCTAssertThrowsError(
            try PList(data: Data([0, 1, 0, 3, 6, 9]))
        )
        
        XCTAssertThrowsError(
            try PList(string: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        )
    }
    
    func testInit_URL() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePListRawXML.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(url:)
        let pl = try PList(url: url)
        verifySamplePListContent(pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_File() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePListRawXML.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(file:)
        let pl = try PList(file: url.path)
        verifySamplePListContent(pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_Data() throws {
        let pl = try PList(data: kSamplePListRawXML.data(using: .utf8)!)
        verifySamplePListContent(pl)
    }
    
    func testInit_String() throws {
        let pl = try PList(string: kSamplePListRawXML)
        verifySamplePListContent(pl)
    }
    
    func testInit_PListDictionary() throws {
        // empty dict
        
        let dict1: PListDictionary = [:]
        
        let pl1 = PList(dictionary: dict1)
        
        XCTAssertEqual(pl1.storage.count, 0)
        
        // dict with content
        
        let dict2: PListDictionary = [
            "key1": 123,
            "key2": 456.789,
            "key3": "A string"
        ]
        
        let pl2 = PList(dictionary: dict2)
        
        XCTAssertEqual(pl2.storage.count, 3)
        
        XCTAssertEqual(pl2.storage[int: "key1"], 123)
        XCTAssertEqual(pl2.storage[double: "key2"], 456.789)
        XCTAssertEqual(pl2.storage[string: "key3"], "A string")
    }
    
    func testInit_RawDictionary() throws {
        // empty dict
        
        let dict1: PList.RawDictionary = [:]
        
        let pl1 = try PList(dictionary: dict1)
        
        XCTAssertEqual(pl1.storage.count, 0)
        
        // dict with content
        
        let dict2: PList.RawDictionary = [
            "key1" as NSString: 123 as NSNumber,
            "key2" as NSString: 456.789 as NSNumber,
            "key3" as NSString: "A string" as NSString
        ]
        
        let pl2 = try PList(dictionary: dict2)
        
        XCTAssertEqual(pl2.storage.count, 3)
        
        XCTAssertEqual(pl2.storage[int: "key1"], 123)
        XCTAssertEqual(pl2.storage[double: "key2"], 456.789)
        XCTAssertEqual(pl2.storage[string: "key3"], "A string")
    }
}

#endif