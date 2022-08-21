//
//  kSamplePList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import XCTest
import PListKit

#if !os(watchOS)

enum kSamplePList { }

extension kSamplePList {
    enum DictRootAllValues {
        static let rawXML = """
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
        
        static func xmlDictionaryPList() throws -> DictionaryPList {
            let data = try XCTUnwrap(rawXML.data(using: .utf8))
            return try DictionaryPList(data: data)
        }
        
        static let rawBinary: [UInt8] = [
            0x62, 0x70, 0x6C, 0x69, 0x73, 0x74, 0x30, 0x30,
            0xD9, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0D, 0x0E, 0x0F, 0x14, 0x15,
            0x16, 0x17, 0x18, 0x59, 0x54, 0x65, 0x73, 0x74,
            0x41, 0x72, 0x72, 0x61, 0x79, 0x5A, 0x54, 0x65,
            0x73, 0x74, 0x44, 0x6F, 0x75, 0x62, 0x6C, 0x65,
            0x58, 0x54, 0x65, 0x73, 0x74, 0x42, 0x6F, 0x6F,
            0x6C, 0x5F, 0x10, 0x0F, 0x54, 0x65, 0x73, 0x74,
            0x4E, 0x65, 0x73, 0x74, 0x65, 0x64, 0x44, 0x69,
            0x63, 0x74, 0x31, 0x5A, 0x54, 0x65, 0x73, 0x74,
            0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x57, 0x54,
            0x65, 0x73, 0x74, 0x49, 0x6E, 0x74, 0x58, 0x54,
            0x65, 0x73, 0x74, 0x44, 0x61, 0x74, 0x61, 0x58,
            0x54, 0x65, 0x73, 0x74, 0x44, 0x61, 0x74, 0x65,
            0x58, 0x54, 0x65, 0x73, 0x74, 0x44, 0x69, 0x63,
            0x74, 0xA2, 0x0B, 0x0C, 0x5F, 0x10, 0x19, 0x53,
            0x74, 0x72, 0x69, 0x6E, 0x67, 0x20, 0x76, 0x61,
            0x6C, 0x75, 0x65, 0x20, 0x69, 0x6E, 0x20, 0x74,
            0x68, 0x65, 0x20, 0x61, 0x72, 0x72, 0x61, 0x79,
            0x11, 0x03, 0xE7, 0x23, 0x40, 0x7C, 0x8C, 0x9F,
            0xBE, 0x76, 0xC8, 0xB4, 0x09, 0xD1, 0x10, 0x11,
            0x5F, 0x10, 0x0F, 0x54, 0x65, 0x73, 0x74, 0x4E,
            0x65, 0x73, 0x74, 0x65, 0x64, 0x44, 0x69, 0x63,
            0x74, 0x32, 0xD1, 0x12, 0x13, 0x5C, 0x4E, 0x65,
            0x73, 0x74, 0x65, 0x64, 0x53, 0x74, 0x72, 0x69,
            0x6E, 0x67, 0x5F, 0x10, 0x15, 0x41, 0x20, 0x6E,
            0x65, 0x73, 0x74, 0x65, 0x64, 0x20, 0x73, 0x74,
            0x72, 0x69, 0x6E, 0x67, 0x20, 0x76, 0x61, 0x6C,
            0x75, 0x65, 0x5E, 0x41, 0x20, 0x73, 0x74, 0x72,
            0x69, 0x6E, 0x67, 0x20, 0x76, 0x61, 0x6C, 0x75,
            0x65, 0x10, 0xEA, 0x42, 0x00, 0xFF, 0x33, 0x41,
            0xC0, 0x61, 0x17, 0x5B, 0x00, 0x00, 0x00, 0xD2,
            0x19, 0x1A, 0x1B, 0x1C, 0x57, 0x44, 0x69, 0x63,
            0x74, 0x49, 0x6E, 0x74, 0x5A, 0x44, 0x69, 0x63,
            0x74, 0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x11,
            0x03, 0x15, 0x5F, 0x10, 0x13, 0x41, 0x20, 0x64,
            0x69, 0x63, 0x74, 0x20, 0x73, 0x74, 0x72, 0x69,
            0x6E, 0x67, 0x20, 0x76, 0x61, 0x6C, 0x75, 0x65,
            0x00, 0x08, 0x00, 0x1B, 0x00, 0x25, 0x00, 0x30,
            0x00, 0x39, 0x00, 0x4B, 0x00, 0x56, 0x00, 0x5E,
            0x00, 0x67, 0x00, 0x70, 0x00, 0x79, 0x00, 0x7C,
            0x00, 0x98, 0x00, 0x9B, 0x00, 0xA4, 0x00, 0xA5,
            0x00, 0xA8, 0x00, 0xBA, 0x00, 0xBD, 0x00, 0xCA,
            0x00, 0xE2, 0x00, 0xF1, 0x00, 0xF3, 0x00, 0xF6,
            0x00, 0xFF, 0x01, 0x04, 0x01, 0x0C, 0x01, 0x17,
            0x01, 0x1A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x1D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x01, 0x30
        ]
        
        static func binaryDictionaryPList() throws -> DictionaryPList {
            let data = Data(rawBinary)
            return try DictionaryPList(data: data)
        }
        
        static func verify(matches pl: DictionaryPList) {
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
                pl.storage[
                    dict: "TestNestedDict1"
                ]?[
                    dict: "TestNestedDict2"
                ]?[
                    string: "NestedString"
                ],
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
    }
}

#endif
