//
//  PList rawData Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import PListKit
import XCTest

final class PList_rawData_Tests: XCTestCase {
    func testRawData_FromXML() throws {
        let pl = try kSamplePList.StringRoot.XML.plist()
        
        // check that rawData succeeds
        
        // xml
        let rawDataXML = try pl.rawData(format: .xml)
        let plFromXML = try PList<String>(data: rawDataXML)
        kSamplePList.StringRoot.verify(matches: plFromXML)
        
        // binary
        let rawDataBinary = try pl.rawData(format: .binary)
        let plFromBinary = try PList<String>(data: rawDataBinary)
        kSamplePList.StringRoot.verify(matches: plFromBinary)
        
        // openStep
        // Apple docs:
        // "The NSPropertyListOpenStepFormat constant is not supported for writing. It can be used
        // only for reading old-style property lists."
    }
    
    func testRawData_FromBinary() throws {
        let pl = try kSamplePList.StringRoot.XML.plist()
        
        // check that rawData succeeds
        
        // xml
        let rawDataXML = try pl.rawData(format: .xml)
        let plFromXML = try PList<String>(data: rawDataXML)
        kSamplePList.StringRoot.verify(matches: plFromXML)
        
        // binary
        let rawDataBinary = try pl.rawData(format: .binary)
        let plFromBinary = try PList<String>(data: rawDataBinary)
        kSamplePList.StringRoot.verify(matches: plFromBinary)
        
        // openStep
        // Apple docs:
        // "The NSPropertyListOpenStepFormat constant is not supported for writing. It can be used
        // only for reading old-style property lists."
    }
}
