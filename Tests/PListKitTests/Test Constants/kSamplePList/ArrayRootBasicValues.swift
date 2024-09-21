//
//  ArrayRootBasicValues.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// swiftformat:options --wrapcollections preserve

import PListKit
import XCTest

extension kSamplePList {
    enum ArrayRootBasicValues {
        typealias ConcretePList = ArrayPList
    }
}

// MARK: - XML plist format

extension kSamplePList.ArrayRootBasicValues {
    enum XML {
        static let raw = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <array>
                <string>A string</string>
                <integer>123</integer>
            </array>
            </plist>
            """
        
        static func plist() throws -> ConcretePList {
            let data = try XCTUnwrap(raw.data(using: .utf8))
            return try ConcretePList(data: data)
        }
    }
}

// MARK: - Binary plist format

extension kSamplePList.ArrayRootBasicValues {
    enum Binary {
        static let raw: [UInt8] = [
            0x62, 0x70, 0x6C, 0x69, 0x73, 0x74, 0x30, 0x30,
            0xA2, 0x01, 0x02, 0x58, 0x41, 0x20, 0x73, 0x74,
            0x72, 0x69, 0x6E, 0x67, 0x10, 0x7B, 0x08, 0x0B,
            0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
            0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x16
        ]

        static func plist() throws -> ConcretePList {
            let data = Data(raw)
            return try ConcretePList(data: data)
        }
    }
}

// MARK: - Data integrity verify

extension kSamplePList.ArrayRootBasicValues {
    static func verify(matches pl: ConcretePList) {
        // sample plist root array has 9 values
        XCTAssertEqual(pl.storage.count, 2)
        
        XCTAssertEqual(pl.storage[0] as? String, "A string")
        XCTAssertEqual(pl.storage[1] as? Int, 123)
    }
}
