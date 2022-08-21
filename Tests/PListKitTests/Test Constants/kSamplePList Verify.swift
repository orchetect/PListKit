//
//  kSamplePList Verify.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import PListKit

final class kSamplePList_Verify: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - ArrayRootBasicValues
    
    func testArrayRootBasicValues_XML_Verify() throws {
        // verifies the verifier... how meta
        
        let plist = try kSamplePList.ArrayRootBasicValues.XML.plist()
        kSamplePList.ArrayRootBasicValues.verify(matches: plist)
    }
    
    func testArrayRootBasicValues_Binary_Verify() throws {
        // verifies the verifier... how meta
        
        let plist = try kSamplePList.ArrayRootBasicValues.Binary.plist()
        kSamplePList.ArrayRootBasicValues.verify(matches: plist)
    }
    
    // MARK: - DictRootAllValues
    
    func testDictRootAllValues_XML_Verify() throws {
        // verifies the verifier... how meta
        
        let plist = try kSamplePList.DictRootAllValues.XML.plist()
        kSamplePList.DictRootAllValues.verify(matches: plist)
    }
    
    func testDictRootAllValues_Binary_Verify() throws {
        // verifies the verifier... how meta
        
        let plist = try kSamplePList.DictRootAllValues.Binary.plist()
        kSamplePList.DictRootAllValues.verify(matches: plist)
    }
}

#endif
