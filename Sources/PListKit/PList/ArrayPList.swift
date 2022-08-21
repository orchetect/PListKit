//
//  ArrayPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist) with an `Array` root.
///
/// - To initialize an empty plist, use ``init()``.
/// - To load a plist file from file path or URL, use the ``init(file:)`` or ``init(url:)`` constructor.
/// - To load a raw plist file content, use the ``init(data:)`` or ``init(xml:)`` constructor.
/// - To save to a file, use ``save(toFileAtPath:format:)``, or ``save(toFileAtURL:format:)``.
///
/// - Note: This plist root type is less common than `Dictionary`.
public final class ArrayPList: PListProtocol, NSCopying {
    // MARK: - PListProtocol
    
    public var format: PListFormat
    public typealias Root = PListArray
    public var storage: Root = []
    
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
        
        return copy
    }
}

extension ArrayPList {
    /// Instantiate an `ArrayPList` object by populating its contents using an existing dictionary.
    ///
    /// - parameter root: Source raw array to read from.
    ///
    /// - throws: `PListLoadError`
    public convenience init(
        root: RawPListArray,
        format: PropertyListSerialization.PropertyListFormat = .xml
    ) throws {
        guard let converted = root.convertedToPListArray() else {
            throw PListLoadError.formatNotExpected
        }
        
        self.init(root: converted, format: format)
    }
}
