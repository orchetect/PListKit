//
//  ArrayPList init Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import PListKit
import XCTest

final class ArrayPList_Init_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit() {
        let pl = ArrayPList()
        
        XCTAssertTrue(pl.storage.isEmpty)
    }
    
    func testInitLoadFailure() {
        // test throwing inits
        
        XCTAssertThrowsError(
            try ArrayPList(url: URL(fileURLWithPath: "/aldkfjalkfgjalkfdja8u248jv34cf"))
        )
        
        XCTAssertThrowsError(
            try ArrayPList(file: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        )
        
        XCTAssertThrowsError(
            try ArrayPList(data: Data([0, 1, 0, 3, 6, 9]))
        )
        
        XCTAssertThrowsError(
            try ArrayPList(xml: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        )
    }
    
    func testInit_URL() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePList.ArrayRootBasicValues.XML.raw.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(url:)
        let pl = try ArrayPList(url: url)
        kSamplePList.ArrayRootBasicValues.verify(matches: pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_File() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePList.ArrayRootBasicValues.XML.raw.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(file:)
        let pl = try ArrayPList(file: url.path)
        kSamplePList.ArrayRootBasicValues.verify(matches: pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_Data() throws {
        let pl = try ArrayPList(data: kSamplePList.ArrayRootBasicValues.XML.raw.data(using: .utf8)!)
        kSamplePList.ArrayRootBasicValues.verify(matches: pl)
    }
    
    func testInit_String() throws {
        let pl = try ArrayPList(xml: kSamplePList.ArrayRootBasicValues.XML.raw)
        kSamplePList.ArrayRootBasicValues.verify(matches: pl)
    }
    
    func testInit_PListArray() throws {
        // empty array
        
        let dict1: PListArray = []
        
        let pl1 = ArrayPList(root: dict1)
        
        XCTAssertEqual(pl1.storage.count, 0)
        
        // array with content
        
        let dict2: PListArray = [
            123,
            456.789,
            "A string"
        ]
        
        let pl2 = ArrayPList(root: dict2)
        
        XCTAssertEqual(pl2.storage.count, 3)
        
        XCTAssertEqual(pl2.storage[int: 0], 123)
        XCTAssertEqual(pl2.storage[double: 1], 456.789)
        XCTAssertEqual(pl2.storage[string: 2], "A string")
    }
    
    func testInit_RawPListArray() throws {
        // empty array
        
        let dict1: RawPListArray = []
        
        let pl1 = try ArrayPList(converting: dict1)
        
        XCTAssertEqual(pl1.storage.count, 0)
        
        // array with content
        
        let dict2: RawPListArray = [
            123 as NSNumber,
            456.789 as NSNumber,
            "A string" as NSString
        ]
        
        let pl2 = try ArrayPList(converting: dict2)
        
        XCTAssertEqual(pl2.storage.count, 3)
        
        XCTAssertEqual(pl2.storage[int: 0], 123)
        XCTAssertEqual(pl2.storage[double: 1], 456.789)
        XCTAssertEqual(pl2.storage[string: 2], "A string")
    }
}

#endif
