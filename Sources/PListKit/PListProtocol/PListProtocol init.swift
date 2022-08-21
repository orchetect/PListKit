//
//  PListProtocol init.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PListProtocol {
    public init(data: Data) throws {
        self.init()
        
        let deserialized = try deserialize(plist: data)
        self.init(
            root: deserialized.plistRoot,
            format: deserialized.format
        )
    }
    
    /// Instantiate a PList object by providing its root element, optionally specifying format.
    public init(root: Root, format: PListFormat = .xml) {
        self.init(format: format)
        self.storage = root
    }
}
