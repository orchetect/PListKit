//
//  AnyPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Generic class wrapping a specialized Property List (``PList``) class.
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

// TODO: - experimental code, can delete later

///// Generic class wrapping a specialized concrete Property List (plist) class.
/////
///// - To initialize an empty plist, use ``init()``.
///// - To load a plist file from file path or URL, use the ``init(file:)`` or ``init(url:)``
/// constructor.
///// - To load a raw plist file content, use the ``init(data:)`` or ``init(xml:)`` constructor.
///// - To save to a file, use ``save(toFileAtPath:format:)``, or ``save(toFileAtURL:format:)``.
// public final class PList<Wrapped: PListProtocol>: PListProtocol, NSCopying {
//    /// Specialized plist class instance being wrapped.
//    public var base: Wrapped
//
//    // MARK: - PListProtocol
//
//    public typealias Root = Wrapped.Root
//
//    public var storage: Root {
//        get {
//            base.storage
//        }
//        set {
//            base.storage = newValue
//        }
//        _modify {
//            yield &base.storage
//        }
//    }
//
//    public var format: PListFormat {
//        get { base.format }
//        set { base.format = newValue }
//    }
//
//    // MARK: - init
//
//    public init() {
//        base = Wrapped()
//    }
//
//    public init(format: PListFormat) {
//        base = Wrapped(format: format)
//    }
//
//    // MARK: - NSCopying
//
//    public func copy(with zone: NSZone? = nil) -> Any {
//        // copy the class including data and properties
//
//        // don't want to force PListProtocol itself to adopt NSCopying
//        // so conditionally cast it here. all plist classes in PListKit will work.
//        guard let copiedPList = (base as? NSCopying)?
//            .copy() as? Wrapped
//        else {
//            // return empty plist in event of failure
//            return Self(wrapping: Wrapped())
//        }
//
//        let copy = Self(wrapping: copiedPList)
//
//        return copy
//    }
//
//    /// Wraps a specialized plist class.
//    public init(wrapping plist: Wrapped) {
//        self.base = plist
//    }
// }
