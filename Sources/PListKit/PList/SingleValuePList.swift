//
//  SingleValuePList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist) with a single value (non-dictionary, non-array) root.
///
/// This plist root layout is less common than `Dictionary`.
public final class SingleValuePList<Root: PListValue>: PListProtocol {
    // MARK: - PListProtocol
    
    public var format: PListFormat
    public var storage: Root = .defaultPListValue()
    
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
