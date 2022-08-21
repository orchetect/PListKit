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
    
    func testRawData_FromXML() throws {
        let pl = try kSamplePList.DictRootAllValues.xmlDictionaryPList()
        
        // check that rawData succeeds
        
        // xml
        let rawDataXML = try pl.rawData(format: .xml)
        let plFromXML = try DictionaryPList(data: rawDataXML)
        kSamplePList.DictRootAllValues.verify(matches: plFromXML)
        
        // binary
        let rawDataBinary = try pl.rawData(format: .binary)
        let plFromBinary = try DictionaryPList(data: rawDataBinary)
        kSamplePList.DictRootAllValues.verify(matches: plFromBinary)
        
        // openStep
        // Apple docs:
        // "The NSPropertyListOpenStepFormat constant is not supported for writing. It can be used only for reading old-style property lists."
    }
    
    func testRawData_FromBinary() throws {
        let pl = try kSamplePList.DictRootAllValues.xmlDictionaryPList()
        
        // check that rawData succeeds
        
        // xml
        let rawDataXML = try pl.rawData(format: .xml)
        let plFromXML = try DictionaryPList(data: rawDataXML)
        kSamplePList.DictRootAllValues.verify(matches: plFromXML)
        
        // binary
        let rawDataBinary = try pl.rawData(format: .binary)
        let plFromBinary = try DictionaryPList(data: rawDataBinary)
        kSamplePList.DictRootAllValues.verify(matches: plFromBinary)
        
        // openStep
        // Apple docs:
        // "The NSPropertyListOpenStepFormat constant is not supported for writing. It can be used only for reading old-style property lists."
    }
}

#endif
