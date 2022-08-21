//
//  PList save Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
import PListKit

class PList_save_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - File Save
    
    func testSave() throws {
        let pl = try kSamplePList.DictRootAllValues.xmlDictionaryPList()
        
        // prep target filename
        
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        
        let randomFileName1 = "temp-\(UUID().uuidString).plist"
        let url1 = temporaryDirectoryURL.appendingPathComponent(randomFileName1)
        
        // save file
        
        pl.format = .xml
        try pl.save(toFileAtURL: url1)
        
        XCTAssertTrue(url1.fileExists) // file written to disk
        
        let randomFileName2 = "temp-\(UUID().uuidString).plist"
        let url2 = temporaryDirectoryURL.appendingPathComponent(randomFileName2)
        
        pl.format = .binary
        try pl.save(toFileAtPath: url2.path)
        
        XCTAssertTrue(url2.fileExists) // file written to disk
        
        // clean up
        
        print("Cleaning up file(s)...")
        
        XCTAssertNoThrow(try url1.trashOrDelete())
        XCTAssertNoThrow(try url2.trashOrDelete())
    }
}

#endif
