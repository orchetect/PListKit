//
//  PList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - PList

/// Class representing a Property List (plist).
///
/// - To initialize an empty plist, use `PList()`.
/// - To load a plist file on disk, use the `init(file:)`, `init(url:)` constructors.
/// - To load a raw plist file content, use the `init(data:)`, `init(string:)`, `init(dictionary:)` constructors.
/// - To save a loaded file, use `save()`.
/// - To save to a new file, use `save(toFile:)`, or `save(toURL:)`.
///
public class PList {
    // MARK: - Globals
    
    internal let fileManager = FileManager.default
    
    // MARK: - Instance properties
    
    /// Get-only property that returns the path and filename of the currently loaded PList file.
    public internal(set) var filePath: String?
    
    /// Get-only property that returns the URL of the currently loaded PList file.
    public internal(set) var fileURL: URL?
    
    /// Root dictionary storage backing for the PList file, containing all keys and nested dictionaries.
    ///
    /// Valid value types, all conforming to `PListValue` protocol:
    ///
    /// - `String`
    /// - `Int`
    /// - `Double`
    /// - `Bool`
    /// - `Date`
    /// - `Data`
    /// - `PListDictionary`, aka `[String : PListValue]`
    /// - `PListArray`, aka `[PListValue]`
    public var storage: PListDictionary = [:]
    
    /// Functional nesting tree classes for clean syntax.
    public var root: PListNode.Root {
        // Create and return a new class every time this property is accessed, to avoid storing an instance of it
        PListNode.Root(delegate: self)
    }
    
    /// Data format of PList when saved to disk.
    public var format: PropertyListSerialization.PropertyListFormat
    
    /// When setting a value using `.root`, determines whether any non-existing dictionaries in the path get created.
    public var createIntermediateDictionaries: Bool = true
    
    // MARK: - Required init
    
    /// Create an empty PList object, optionally specifying format.
    ///
    /// Format defaults to `xml`.
    ///
    public required init(
        format: PropertyListSerialization.PropertyListFormat = .xml
    ) {
        self.format = format
    }
}
