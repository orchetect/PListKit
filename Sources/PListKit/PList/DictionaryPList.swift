//
//  DictionaryPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist) with a `Dictionary` root.
/// This is the most common plist root layout and provides the most amount of useful abstractions of all plist classes in PListKit.
///
/// - To initialize an empty plist, use ``init()``.
/// - To load a plist file from file path or URL, use the ``init(file:)`` or ``init(url:)`` constructor.
/// - To load a raw plist file content, use the ``init(data:)`` or ``init(xml:)`` constructor.
/// - To save to a file, use ``save(toFileAtPath:format:)``, or ``save(toFileAtURL:format:)``.
public final class DictionaryPList: PListProtocol, NSCopying {
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
        
        let copy = Self(root: storage, format: format)
        
        copy.format = format
        copy.createIntermediateDictionaries = createIntermediateDictionaries
        
        return copy
    }
}

extension DictionaryPList {
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
