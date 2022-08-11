//
//  PList rawData.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

extension PList {
    /// Returns the raw plist content.
    /// If there is an error, an exception will be thrown.
    public func rawData(
        format: PropertyListSerialization.PropertyListFormat? = nil
    ) throws -> Data {
        // if passed as nil, use `format` property
        let fileFormat = format != nil ? format! : self.format
        
        // Apple Docs: "Currently unused. Set to 0."
        let opts = PropertyListSerialization.WriteOptions()
        
        let result =
            try PropertyListSerialization.data(
                fromPropertyList: storage,
                format: fileFormat,
                options: opts
            )
        
        return result
    }
}
