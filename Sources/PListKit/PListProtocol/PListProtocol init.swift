//
//  PListProtocol init.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PListProtocol {
    public init(file path: String) throws {
        let fileContents = try readFile(path: path)
        try self.init(data: fileContents)
    }
    
    public init(url: URL) throws {
        let fileContents = try readFile(url: url)
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
        storage = root
    }
}

extension PListProtocol {
    /// Instantiate a plist object by converting a raw root value.
    ///
    /// - parameters:
    ///   - root: Source raw plist value (`NSDictionary`, `NSString`, `NSNumber`, etc.)
    ///   - format: plist format
    ///
    /// - throws: ``PListLoadError``
    public init(
        converting root: AnyObject,
        format: PropertyListSerialization.PropertyListFormat = .xml
    ) throws {
        guard let converted = convertToPListValue(from: root) else {
            throw PListLoadError.unhandledType
        }
        
        try self.init(pListValue: converted, format: format)
    }
    
    /// Internal helper
    init(
        pListValue root: PListValue,
        format: PropertyListSerialization.PropertyListFormat = .xml
    ) throws {
        guard let typed = root as? Root else {
            throw PListLoadError.unhandledType
        }
        self.init(root: typed, format: format)
    }
}
