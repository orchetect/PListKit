//
//  PList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist).
///
/// The `PList` class is specialized by providing the root element type.
///
/// The most common is a dictionary-rooted plist (``DictionaryPList``)
///
/// ```swift
/// PList<PListDictionary> // typealias: DictionaryPList
/// ```
///
/// For special use cases, a plist can be rooted with any valid ``PListValue`` type, such as an array or single value like String or Int.
///
/// ```swift
/// PList<PListArray> // typealias: ArrayPList
/// PList<String>
/// PList<Int>
/// // etc.
/// ```
///
/// - To initialize an empty plist, use ``init()``.
/// - To load a plist file from file path or URL, use the ``init(file:)`` or ``init(url:)`` constructor.
/// - To load a raw plist file content, use the ``init(data:)`` or ``init(xml:)`` constructor.
/// - To save to a file, use ``save(toFileAtPath:format:)``, or ``save(toFileAtURL:format:)``.
///
/// - Note: ``DictionaryPList`` is the most common plist root type and is recommended.
public final class PList<Root: PListValue>: PListProtocol, NSCopying {
    // MARK: - PListProtocol
    
    public var format: PListFormat
    public var storage: Root = .defaultPListValue()
    
    // (this is exposed only on PList<PListDictionary> by way of computed property)
    internal var _createIntermediateDictionaries: Bool = false
    
    // MARK: - init
    
    public init() {
        format = .xml
    }
    
    public init(format: PListFormat) {
        self.format = format
    }
    
    // MARK: - NSCopying
    
    public func copy(with zone: NSZone? = nil) -> Any {
        // copy the class including data and properties
        
        let copy = Self(root: storage, format: format)
        
        copy.format = format
        
        return copy
    }
}
