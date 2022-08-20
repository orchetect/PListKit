//
//  PList init.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PList {
    /// Instantiate a PList object by loading a plist file from disk.
    ///
    /// - parameter file: A full or relative pathname.
    ///
    /// - throws: `PList.LoadError`
    public convenience
    init(file path: String) throws {
        self.init()
        
        guard fileManager.fileExists(atPath: path)
        else { throw LoadError.fileNotFound }
        
        // load as raw NS objects
        guard let getDict = NSMutableDictionary(contentsOfFile: path) as RawDictionary?
        else { throw LoadError.formatNotExpected }
        
        // translate to friendly Swift types
        guard let translatedDict = getDict.convertedToPListDictionary()
        else { throw LoadError.formatNotExpected }
        
        storage = translatedDict
        updatePaths(withFilePath: path)
    }
    
    /// Create a PList object by loading a plist file from a local file URL or network resource URL.
    ///
    /// - parameter url: A full URL.
    ///
    /// - throws: `PList.LoadError`
    public convenience
    init(url: URL) throws {
        self.init()
        
        if url.isFileURL {
            guard fileManager.fileExists(atPath: url.path)
            else { throw LoadError.fileNotFound }
        }
        
        // load as raw NS objects
        guard let getDict = NSMutableDictionary(contentsOf: url) as RawDictionary?
        else { throw LoadError.formatNotExpected }
        
        // translate to friendly Swift types
        guard let translatedDict = getDict.convertedToPListDictionary()
        else { throw LoadError.formatNotExpected }
        
        storage = translatedDict
        updatePaths(withURL: url)
    }
    
    /// Create a PList object by populating its contents using an existing dictionary.
    ///
    /// - parameter dictionary: Source dictionary to read from.
    ///
    public convenience
    init(
        dictionary: PListDictionary,
        format: PropertyListSerialization.PropertyListFormat = .xml
    ) {
        self.init()
        
        storage = dictionary
        
        self.format = format
    }
    
    /// Create a PList object by populating its contents using an existing dictionary.
    ///
    /// - parameter dictionary: Source dictionary to read from.
    ///
    public convenience
    init(
        dictionary: RawDictionary,
        format: PropertyListSerialization.PropertyListFormat = .xml
    ) throws {
        self.init()
        
        guard let converted = dictionary.convertedToPListDictionary() else {
            throw LoadError.formatNotExpected
        }
        
        storage = converted
        self.format = format
    }
    
    /// Create a PList object by populating its contents from parsing raw plist data.
    ///
    /// - parameter data: Source binary Data to read from.
    ///
    /// - throws: `PList.LoadError`
    public convenience
    init(data: Data) throws {
        self.init()
        
        // load as raw NS objects
        
        // this is not determining the format, it just needs to be initialized to *some*
        // value so that `PropertyListSerialization.propertyList` can mutate it.
        var getFormat: PropertyListSerialization.PropertyListFormat = .xml
        
        // if this succeeds, it will update getFormat with the file's actual format
        let getDict = (
            try PropertyListSerialization.propertyList(
                from: data,
                options: .init(rawValue: 0),
                format: &getFormat
            )
        ) as? RawDictionary
        
        guard let _getDict = getDict
        else { throw LoadError.formatNotExpected }
        
        // translate to friendly Swift types
        guard let translatedDict = _getDict.convertedToPListDictionary()
        else { throw LoadError.formatNotExpected }
        
        storage = translatedDict
        format = getFormat
    }
    
    /// Create a PList object by populating its contents from parsing raw plist file contents as a string.
    ///
    /// - parameter data: Source binary Data to read from.
    ///
    /// - throws: `PList.LoadError`
    public convenience
    init(string: String) throws {
        self.init()
        
        guard let data = string.data(using: .utf8) else {
            throw LoadError.formatNotExpected
        }
        
        try self.init(data: data)
    }
}
