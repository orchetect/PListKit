//
//  DictionaryPList save Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import PListKit

final class DictionaryPList_save_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - File Save
    
    func testSave_toFileAtURL() throws {
        let pl = try kSamplePList.DictRootAllValues.XML.plist()
        
        // prep target filename
        
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        
        // save file
        
        pl.format = .xml
        try pl.save(toFileAtURL: url)
        
        XCTAssertTrue(url.fileExists) // file written to disk
        
        // clean up
        
        print("Cleaning up file(s)...")
        
        XCTAssertNoThrow(try url.trashOrDelete())
    }
    
    func testSave_toFileAtPath() throws {
        let pl = try kSamplePList.DictRootAllValues.XML.plist()
        
        // prep target filename
        
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        
        let randomFileName = "temp-\(UUID().uuidString).plist"
        let url = temporaryDirectoryURL.appendingPathComponent(randomFileName)
        
        // save file
        
        pl.format = .binary
        try pl.save(toFileAtPath: url.path)
        
        XCTAssertTrue(url.fileExists) // file written to disk
        
        // clean up
        
        print("Cleaning up file(s)...")
        
        XCTAssertNoThrow(try url.trashOrDelete())
    }
}

#endif
