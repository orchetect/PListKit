//
//  PListProtocol init.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PListProtocol {
    public init(file path: String) throws {
        let fileContents = try Self.readFile(path: path)
        try self.init(data: fileContents)
    }
    
    public init(url: URL) throws {
        let fileContents = try Self.readFile(url: url)
        try self.init(data: fileContents)
    }
    
    public init(xml string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw PListLoadError.formatNotExpected
        }
        
        try self.init(data: data)
    }
    
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
