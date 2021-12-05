//
//  File Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//

#if !os(watchOS)

import XCTest
import PListKit

class FileTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - File Save
    
    func testSaveFailure() throws {
        
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
        // no filePath or fileURL set, save will fail
        
        XCTAssertThrowsError(try pl.save())
        XCTAssertThrowsError(try pl.save(format: .xml))
        XCTAssertThrowsError(try pl.save(format: .binary))
        
    }
    
    func testSave() throws {
        
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
        
        // prep target filename
        
        let temporaryDirectoryURL = FileManager.temporaryDirectoryCompat
        
        let randomFileName1 = "temp-\(UUID().uuidString).plist"
        let url1 = temporaryDirectoryURL.appendingPathComponent(randomFileName1)
        
        // save file
        
        pl.format = .xml
        try pl.save(toURL: url1)
        
        XCTAssertTrue(url1.fileExists) // file written to disk
        
        let randomFileName2 = "temp-\(UUID().uuidString).plist"
        let url2 = temporaryDirectoryURL.appendingPathComponent(randomFileName2)
        
        pl.format = .binary
        try pl.save(toFile: url2.path)
        
        XCTAssertTrue(url2.fileExists) // file written to disk
        
        // clean up
        
        print("Cleaning up file(s)...")
        
        XCTAssertNoThrow(try url1.trashOrDelete())
        XCTAssertNoThrow(try url2.trashOrDelete())
        
    }
    
}

#endif
