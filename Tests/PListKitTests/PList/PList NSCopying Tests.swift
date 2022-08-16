//
//  PList NSCopying Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
import PListKit

class PList_NSCopying_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }

    func testNSCopying() throws {
        let pl = try PList(data: kSamplePList.data(using: .utf8)!)
        verifySamplePListContent(pl)
    
        // set up other properties
    
        pl.format = .binary
    
        // make copy
    
        let copy = pl.copy() as! PList
    
        // verify contents
    
        verifySamplePListContent(copy)
    
        // verify stored properties
    
        XCTAssertEqual(copy.storage.count, 9)
        XCTAssertEqual(copy.format, .binary)
    }
}

#endif
