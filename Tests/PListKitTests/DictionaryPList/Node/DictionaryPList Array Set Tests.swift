//
//  DictionaryPList Array Set Tests.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import PListKit

final class DictionaryPList_ArraySet_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    /// Test to deal with an edge case where setting an Array as a
    /// Dictionary key's value as would fail.
    /// GitHub Issue: https://github.com/orchetect/PListKit/discussions/9
    func testArrayReplacementWithinDictionary() throws {
        let plist = try DictionaryPList(xml: plistContent)
        
        func getDriversArray() -> [PListDictionary]? {
            plist.root
                .dict(key: "TestDic")
                .array(key: "TestArr")
                .value?
                .compactMap { $0 as? PListDictionary }
        }
        
        var driversArray = try XCTUnwrap(getDriversArray())
        
        // mutate copied array
        
        for index in driversArray.indices {
            if driversArray[index][string: "A"] == "B" {
                driversArray[index]["A"] = "flags"
            }
        }
        driversArray[1]["A"] = "BB"
        
        // re-assign new mutated array in place of the old one in the plist
        
        plist.root
            .dict(key: "TestDic")
            .array(key: "TestArr")
            .value = driversArray
        
        // diagnostic output
        
        // dump(
        //     plist.root
        //         .dict(key: "TestDic")
        //         .array(key: "TestArr")
        //         .value
        // )
        
        let newDriversArray = try XCTUnwrap(getDriversArray())
        
        XCTAssertEqual(newDriversArray[0][string: "A"], "flags")
        XCTAssertEqual(newDriversArray[1][string: "A"], "BB")
    }
}

fileprivate let plistContent: String = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>TestDic</key>
        <dict>
            <key>TestArr</key>
            <array>
                <dict>
                    <key>A</key>
                    <string>B</string>
                </dict>
                <dict>
                    <key>A</key>
                    <string>E</string>
                </dict>
            </array>
        </dict>
    </dict>
    </plist>
    """

#endif
