//
//  PList init Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import PListKit
import XCTest

final class PList_Init_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit() {
        let pl = PList<String>()
        
        XCTAssertEqual(pl.storage, "")
    }
    
    func testInitLoadFailure() {
        // test throwing inits
        
        XCTAssertThrowsError(
            try PList<String>(url: URL(fileURLWithPath: "/aldkfjalkfgjalkfdja8u248jv34cf"))
        )
        
        XCTAssertThrowsError(
            try PList<String>(file: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        )
        
        XCTAssertThrowsError(
            try PList<String>(data: Data([0, 1, 0, 3, 6, 9]))
        )
        
        // special case omitted here, see test below
        // XCTAssertThrowsError(
        //    try PList<String>(xml: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
        // )
    }
    
    func testXMLMalformed() throws {
        // the internal mechanism being used (PropertyListSerialization) seems to
        // allow a malformed plist and just returns the input to the output
        // instead of throwing an error itself.
        // in this case, it outputs a string of the raw XML input which succeeds
        // in initializing a PList<String> instance
        
        let pl = try? PList<String>(xml: "asdfsdflk44ucr384cuwurm9xu38fnianaif")
          
        try XCTSkipIf(
            pl != nil,
            "This succeeds when we would prefer it to throw an error, however it is not a test failure condition."
        )
    }
    
    func testInit_URL() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePList.StringRoot.XML.raw.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(url:)
        let pl = try PList<String>(url: url)
        kSamplePList.StringRoot.verify(matches: pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_File() throws {
        // write sample plist to disk
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        try kSamplePList.StringRoot.XML.raw.write(
            to: url,
            atomically: false,
            encoding: .utf8
        )
        
        // init(file:)
        let pl = try PList<String>(file: url.path)
        kSamplePList.StringRoot.verify(matches: pl)
        
        // clean up
        print("Cleaning up file(s)...")
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testInit_Data() throws {
        let pl = try PList<String>(
            data: kSamplePList.StringRoot.XML.raw
                .data(using: .utf8)!
        )
        kSamplePList.StringRoot.verify(matches: pl)
    }
    
    func testInit_String() throws {
        let pl = try PList<String>(xml: kSamplePList.StringRoot.XML.raw)
        kSamplePList.StringRoot.verify(matches: pl)
    }
    
    func testInit_Root() throws {
        let pl = PList<String>(root: "A string" as String)
        XCTAssertEqual(pl.storage, "A string")
    }
    
    func testInit_RawRoot() throws {
        let value = "A string" as NSString
        let pl = try PList<String>(converting: value)
        XCTAssertEqual(pl.storage, "A string")
    }
}
