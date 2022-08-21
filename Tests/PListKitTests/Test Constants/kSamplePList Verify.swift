//
//  kSamplePList Verify.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
import PListKit

final class kSamplePList_Verify: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testDictRootAllValues_XML_Verify() throws {
        // verifies the verifier... how meta
        
        let plist = try kSamplePList.DictRootAllValues.xmlDictionaryPList()
        kSamplePList.DictRootAllValues.verify(matches: plist)
    }
    
    func testDictRootAllValues_Binary_Verify() throws {
        // verifies the verifier... how meta
        
        let plist = try kSamplePList.DictRootAllValues.binaryDictionaryPList()
        kSamplePList.DictRootAllValues.verify(matches: plist)
    }
}

#endif
