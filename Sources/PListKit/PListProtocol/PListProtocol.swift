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
    
    // MARK: - Init
    
    /// Create an empty plist, using default format.
    init()
    
    /// Create an empty plist, optionally specifying format.
    init(format: PListFormat)
    
    /// Create a plist from a root element, optionally specifying format.
    init(root: Root, format: PListFormat)
    
    // MARK: - Init From File
    
    /// Instantiate a plist object by loading a plist file from disk.
    ///
    /// - parameter file: An absolute file path.
    ///
    /// - throws: `PListLoadError`
    init(file path: String) throws
    
    /// Instantiate a plist object by loading a plist file from a local file URL or network resource URL.
    ///
    /// - parameter url: A local file URL or network resource URL.
    ///
    /// - throws: `PListLoadError`
    init(url: URL) throws
    
    // MARK: - Raw Data
    
    /// Instantiate a plist object from raw plist XML.
    ///
    /// - parameter xml: Source plist raw XML as `String`.
    ///
    /// - throws: `PListLoadError`
    init(xml string: String) throws
    
    /// Instantiate a plist object by populating its contents from parsing raw plist data.
    ///
    /// - parameter data: Source plist raw data, either XML or binary.
    ///
    /// - throws: `PListLoadError`
    init(data: Data) throws
    
    /// Returns the raw plist content.
    /// If there is an error, an exception will be thrown.
    func rawData(
        format: PListFormat?
    ) throws -> Data
}
