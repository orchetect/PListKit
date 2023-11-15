//
//  StringRoot.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// swiftformat:options --wrapcollections preserve

#if shouldTestCurrentPlatform

import PListKit
import XCTest

extension kSamplePList {
    enum StringRoot {
        typealias ConcretePList = PList<String>
    }
}

// MARK: - XML plist format

extension kSamplePList.StringRoot {
    enum XML {
        static let raw = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <string>Just a string</string>
            </plist>
            """
        
        static func plist() throws -> ConcretePList {
            let data = try XCTUnwrap(raw.data(using: .utf8))
            return try ConcretePList(data: data)
        }
    }
}

// MARK: - Binary plist format

extension kSamplePList.StringRoot {
    enum Binary {
        static let raw: [UInt8] = [
            0x62, 0x70, 0x6C, 0x69, 0x73, 0x74, 0x30, 0x30,
            0x5D, 0x4A, 0x75, 0x73, 0x74, 0x20, 0x61, 0x20,
            0x73, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x08, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16
        ]

        static func plist() throws -> ConcretePList {
            let data = Data(raw)
            return try ConcretePList(data: data)
        }
    }
}

// MARK: - Data integrity verify

extension kSamplePList.StringRoot {
    static func verify(matches pl: ConcretePList) {
        // sample plist root is itself a String
        XCTAssertEqual(pl.storage, "Just a string")
    }
}

#endif
