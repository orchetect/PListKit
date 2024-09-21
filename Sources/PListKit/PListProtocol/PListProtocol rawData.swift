//
//  PListProtocol rawData.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PListProtocol {
    public func rawData(
        format: PListFormat? = nil
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
