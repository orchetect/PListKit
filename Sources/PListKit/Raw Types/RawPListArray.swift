//
//  RawPListArray.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Raw `NSArray` used by `PropertyListSerialization`.
public typealias RawPListArray = [AnyObject]

// MARK: - Conversion

extension RawPListArray {
    /// Function to recursively translate a raw plist array to a Swift-friendly typed array.
    public func convertedToPListArray() -> PListArray? {
        // translate to Swift-friendly types
        
        var newArray: PListArray = []
        
        for element in self {
            guard let typedValue = convertToPListValue(from: element)
            else { return nil }
            
            newArray.append(typedValue)
        }
        
        return newArray
    }
}

// MARK: - API Changes in 2.0.0

extension PList {
    /// This type has been renamed to ``RawPListArray``.
    @available(*, deprecated, renamed: "RawPListArray")
    public typealias RawArray = RawPListArray
}
