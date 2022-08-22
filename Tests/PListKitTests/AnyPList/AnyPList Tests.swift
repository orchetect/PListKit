//
//  AnyPList Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import PListKit

final class AnyPList_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit_XML_DictionaryRoot() throws {
        let anyPL = try AnyPList(xml: kSamplePList.DictRootAllValues.XML.raw)
        guard case let .dictionaryRoot(pl) = anyPL.plist else { XCTFail(); return }
        kSamplePList.DictRootAllValues.verify(matches: pl)
    }
    
    func testInit_XML_ArrayRoot() throws {
        let anyPL = try AnyPList(xml: kSamplePList.ArrayRootBasicValues.XML.raw)
        guard case let .arrayRoot(pl) = anyPL.plist else { XCTFail(); return }
        kSamplePList.ArrayRootBasicValues.verify(matches: pl)
    }
    
    func testInit_XML_StringRoot() throws {
        let anyPL = try AnyPList(xml: kSamplePList.StringRoot.XML.raw)
        guard case let .stringRoot(pl) = anyPL.plist else { XCTFail(); return }
        kSamplePList.StringRoot.verify(matches: pl)
    }
}

#endif
