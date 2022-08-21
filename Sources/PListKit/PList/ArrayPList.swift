//
//  ArrayPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist) with an array root.
///
/// This plist root layout is less common than `Dictionary`.
public final class ArrayPList: PListProtocol {
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
        // and omit transient information such as `filePath` and `fileURL`
        
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
    /// - throws: `PList.LoadError`
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
