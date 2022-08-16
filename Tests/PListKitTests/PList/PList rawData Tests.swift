//
//  PList rawData Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
import PListKit

class PList_rawData_Tests: XCTestCase {
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
}

#endif
