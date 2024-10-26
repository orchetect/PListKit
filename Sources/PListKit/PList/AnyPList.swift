//
//  AnyPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box wrapping a specialized Property List (``PList``) class.
///
/// Using a file or data initializer on this class can be a generic entry-point for reading
/// anonymous plist files. When you have no foreknowledge about a plist's root element this allows
/// you to unwrap the ``PList`` instance specialized to the plist's root type.
///
/// See <doc:Load-a-plist-file-from-disk> and <doc:Working-with-Non-Dictionary-plists> for details
/// on using `AnyPList`.
public struct AnyPList {
    /// Contains a specialized ``PList`` instance.
    public let plist: WrappedPList
    
    init(wrapped: WrappedPList) {
        plist = wrapped
    }
    
    /// Instantiate a plist object by loading a plist file from disk.
    ///
    /// - parameter file: An absolute file path.
    ///
    /// - throws: ``PListLoadError``
    public init(file path: String) throws {
        let fileContents = try readFile(path: path)
        try self.init(data: fileContents)
    }
    
    /// Instantiate a plist object by loading a plist file from a local file URL or network resource
    /// URL.
    ///
    /// - parameter url: A local file URL or network resource URL.
    ///
    /// - throws: ``PListLoadError``
    public init(url: URL) throws {
        let fileContents = try readFile(url: url)
        try self.init(data: fileContents)
    }
    
    /// Instantiate a plist object from raw plist XML.
    ///
    /// - parameter xml: Source plist raw XML as `String`.
    ///
    /// - throws: ``PListLoadError``
    public init(xml string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw PListLoadError.formatNotExpected
        }
        
        try self.init(data: data)
    }
    
    /// Instantiate a plist object from raw plist data.
    ///
    /// - parameter data: Source plist raw data, either XML or binary.
    ///
    /// - throws: ``PListLoadError``
    public init(data: Data) throws {
        let deserialized = try data.deserializeToWrappedPList()
        plist = deserialized.wrappedPlist
    }
    
    // MARK: - Proxy methods
    
    #if swift(>=5.7)
    /// Data format of the plist when saved to disk.
    /* public */ var format: PListFormat {
        plist.unwrapped().format
    }
    
    /// Returns the raw plist content.
    /// If there is an error, an exception will be thrown.
    /* public */ func rawData(
        format: PListFormat?
    ) throws -> Data {
        try plist.unwrapped().rawData(format: format)
    }
    #endif
}

/// Cases containing a strongly-typed specialized ``PList`` instance.
/// Unwrap the strongly-typed plist root object using a switch case.
public enum WrappedPList {
    case dictionaryRoot(DictionaryPList)
    case arrayRoot(ArrayPList)
    case boolRoot(PList<Bool>)
    case stringRoot(PList<String>)
    case intRoot(PList<Int>)
    case doubleRoot(PList<Double>)
    case dateRoot(PList<Date>)
    case dataRoot(PList<Data>)
    
    // MARK: Internal helper methods
    
    #if swift(>=5.7)
    func unwrapped() -> any PListProtocol {
        switch self {
        case let .dictionaryRoot(pl): return pl
        case let .arrayRoot(pl): return pl
        case let .boolRoot(pl): return pl
        case let .stringRoot(pl): return pl
        case let .intRoot(pl): return pl
        case let .doubleRoot(pl): return pl
        case let .dateRoot(pl): return pl
        case let .dataRoot(pl): return pl
        }
    }
    #endif
}
