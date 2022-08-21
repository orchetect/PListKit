//
//  DictionaryPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist) with a `Dictionary` root.
/// This is the most common plist root layout and provides the most amount of useful abstractions of all plist classes in PListKit.
///
/// - To initialize an empty plist, use `PList()`.
/// - To load a plist file on disk, use the `init(file:)`, `init(url:)` constructors.
/// - To load a raw plist file content, use the `init(data:)`, `init(string:)`, `init(dictionary:)` constructors.
/// - To save a loaded file, use `save()`.
/// - To save to a new file, use `save(toFile:)`, or `save(toURL:)`.
///
public final class DictionaryPList: PListProtocol {
    // MARK: - PListProtocol
    
    public var format: PListFormat
    public typealias Root = PListDictionary
    public var storage: Root = [:]
    
    // MARK: - Class-Specific Properties
    
    /// When setting a value using `.root`, determines whether any non-existing dictionaries in the path get created.
    public var createIntermediateDictionaries: Bool = true
    
    /// Functional nesting dictionary tree classes for clean syntax.
    public var root: PListNode.Root {
        // Create and return a new class every time this property is accessed, to avoid storing an instance of it
        PListNode.Root(delegate: self)
    }
    
    // MARK: - init
    
    public init() {
        self.format = .xml
    }
    
    public init(format: PListFormat) {
        self.format = format
    }
    
    // MARK: - NSCopying
    
    public func copy(with zone: NSZone? = nil) -> Any {
        // copy the class including data and properties
        // and omit transient information such as `filePath` and `fileURL`
        
        let copy = Self(root: storage, format: format)
        
        copy.format = format
        copy.createIntermediateDictionaries = createIntermediateDictionaries
        
        return copy
    }
}

extension DictionaryPList {
    /// Instantiate a `DictionaryPList` object by loading a plist file from disk.
    ///
    /// - parameter file: An absolute file path.
    ///
    /// - throws: `PList.LoadError`
    public convenience init(file path: String) throws {
        let fileContents = try Self.readFile(path: path)
        try self.init(data: fileContents)
    }
    
    /// Instantiate a `DictionaryPList` object by loading a plist file from a local file URL or network resource URL.
    ///
    /// - parameter url: A full URL.
    ///
    /// - throws: `PList.LoadError`
    public convenience init(url: URL) throws {
        let fileContents = try Self.readFile(url: url)
        try self.init(data: fileContents)
    }
    
    /// Instantiate a `DictionaryPList` object by populating its contents from a raw XML plist string.
    ///
    /// - parameter data: Source binary Data to read from.
    ///
    /// - throws: `PList.LoadError`
    public convenience init(xml string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw PListLoadError.formatNotExpected
        }
        
        try self.init(data: data)
    }
    
    /// Instantiate a `DictionaryPList` object by populating its contents using an existing dictionary.
    ///
    /// - parameter root: Source raw dictionary to read from.
    ///
    /// - throws: `PListLoadError`
    public convenience init(
        root: RawPListDictionary,
        format: PropertyListSerialization.PropertyListFormat = .xml
    ) throws {
        guard let converted = root.convertedToPListDictionary() else {
            throw PListLoadError.formatNotExpected
        }
        
        self.init(root: converted, format: format)
    }
}
