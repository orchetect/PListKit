//
//  PListProtocol.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PListProtocol: AnyObject {
    /// Root type for the plist.
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
    associatedtype Root: PListValue
    
    /// Root strongly-typed storage backing for the plist.
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
    var storage: Root { get set }
    
    /// Data format of PList when saved to disk.
    var format: PListFormat { get set }
    
    /// Create an empty plist, using default format.
    init()
    
    /// Create an empty plist, optionally specifying format.
    init(format: PListFormat)
    
    /// Create a plist from a root element, optionally specifying format.
    init(root: Root, format: PListFormat)
    
    /// Create a plist by populating its contents from parsing raw plist data.
    ///
    /// - parameter data: Source data to read from.
    ///
    /// - throws: `PListLoadError`
    init(data: Data) throws
        
    /// Returns the raw plist content.
    /// If there is an error, an exception will be thrown.
    func rawData(
        format: PListFormat?
    ) throws -> Data
}
