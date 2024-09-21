//
//  kSamplePList Verify.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import PListKit
import XCTest

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
    
    // MARK: - StringRoot
    
    func testStringRoot_XML_Verify() throws {
        // verifies the verifier... how meta
        let plist = try kSamplePList.StringRoot.XML.plist()
        kSamplePList.StringRoot.verify(matches: plist)
    }
    
    func testStringRoot_Binary_Verify() throws {
        // verifies the verifier... how meta
        let plist = try kSamplePList.StringRoot.Binary.plist()
        kSamplePList.StringRoot.verify(matches: plist)
    }
}
