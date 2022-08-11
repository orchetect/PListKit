//
//  Sample plist Files.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import XCTest
import PListKit

#if !os(watchOS)

// MARK: - kSamplePList

let kSamplePList = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>TestArray</key>
        <array>
            <string>String value in the array</string>
            <integer>999</integer>
        </array>
        <key>TestBool</key>
        <true/>
        <key>TestData</key>
        <data>AP8=</data>
        <key>TestDate</key>
        <date>2018-06-02T01:47:34Z</date>
        <key>TestDict</key>
        <dict>
            <key>DictInt</key>
            <integer>789</integer>
            <key>DictString</key>
            <string>A dict string value</string>
        </dict>
        <key>TestDouble</key>
        <real>456.789</real>
        <key>TestInt</key>
        <integer>234</integer>
        <key>TestNestedDict1</key>
        <dict>
            <key>TestNestedDict2</key>
            <dict>
                <key>NestedString</key>
                <string>A nested string value</string>
            </dict>
        </dict>
        <key>TestString</key>
        <string>A string value</string>
    </dict>
    </plist>
    """

func verifySamplePListContent(_ pl: PList) {
    // sample plist has 9 root-level keys
    XCTAssertEqual(pl.storage.count, 9)
    
    XCTAssertEqual(
        pl.storage[array: "TestArray"]?.count,
        2
    )
    XCTAssertEqual(
        pl.storage[array: "TestArray"]?[0] as? String,
        "String value in the array"
    )
    XCTAssertEqual(
        pl.storage[array: "TestArray"]?[1] as? Int,
        999
    )
    
    XCTAssertEqual(
        pl.storage[dict: "TestDict"]?.count,
        2
    )
    XCTAssertEqual(
        pl.storage[dict: "TestDict"]?[int: "DictInt"],
        789
    )
    XCTAssertEqual(
        pl.storage[dict: "TestDict"]?[string: "DictString"],
        "A dict string value"
    )
    
    XCTAssertEqual(
        pl.storage[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?.count,
        1
    )
    XCTAssertEqual(
        pl.storage[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "NestedString"],
        "A nested string value"
    )
    
    XCTAssertEqual(
        pl.storage[bool: "TestBool"],
        true
    )
    XCTAssertEqual(
        pl.storage[data: "TestData"],
        Data([0x00, 0xFF])
    )
    XCTAssertEqual(
        pl.storage[date: "TestDate"],
        Date(timeIntervalSince1970: 1_527_904_054.0)
    )
    XCTAssertEqual(
        pl.storage[double: "TestDouble"],
        456.789
    )
    XCTAssertEqual(
        pl.storage[int: "TestInt"],
        234
    )
    XCTAssertEqual(
        pl.storage[string: "TestString"],
        "A string value"
    )
}

#endif
