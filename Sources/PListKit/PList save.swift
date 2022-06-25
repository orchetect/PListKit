//
//  PList save.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

extension PList {
    
    /// Save the PList file to disk in-place, overwriting without confirmation.
    ///
    /// Only applicable if the `load()` initializers or methods were already used on this class instance which would have obtained a file's location on disk while loading the file.
    ///
    /// The `filePath` property is read and then saves to that location. If it is empty, the `fileURL` property is read and then saves to that location instead. If both are empty, an error is thrown.
    ///
    /// - parameter format: Data format on disk when saving.
    ///
    public func save(format: PropertyListSerialization.PropertyListFormat? = nil) throws
    {
        
        // if passed as nil, use `format` property
        let fileFormat = format ?? self.format
        
        if let fp = filePath { try save(toFile: fp, format: fileFormat) }
        
        if let fu = fileURL { try save(toURL: fu, format: fileFormat) }
        
        throw nsError("No file path or URL supplied.")
        
    }
    
    /// Save the PList file to disk, overwriting without confirmation.
    ///
    /// - parameter toFile: An absolute or relative file path.
    /// - parameter format: Data format on disk when saving.
    ///
    public func save(toFile: String,
                     format: PropertyListSerialization.PropertyListFormat? = nil) throws
    {
        
        // if passed as nil, use `format` property
        let fileFormat = format ?? self.format
        
        guard let out = OutputStream(toFileAtPath: toFile, append: false)
        else {
            throw nsError("OutputStream could not be created.")
        }
        
        out.open()
        
        // Apple Docs: "Currently unused. Set to 0."
        let opts = PropertyListSerialization.WriteOptions()
        
        var err: NSError?
        let result = PropertyListSerialization
            .writePropertyList(storage as Any,
                               to: out,
                               format: fileFormat,
                               options: opts,
                               error: &err)
        
        out.close()
        
        // number of bytes written; 0 indicates an error occurred
        if result == 0 {
            throw err ?? nsError("Unknown error.")
        }
        
        // update paths & format property after successful file save
        updatePaths(withFilePath: toFile)
        self.format = fileFormat
        
        if err != nil {
            throw err!
        }
        
    }
    
    /// Save the PList file to disk, overwriting without confirmation.
    ///
    /// - parameter toURL: A full file URL.
    /// - parameter format: Data format on disk when saving.
    ///
    public func save(toURL: URL,
                     format: PropertyListSerialization.PropertyListFormat? = nil) throws
    {
        
        // if passed as nil, use `format` property
        let fileFormat = format ?? self.format
        
        guard let out = OutputStream(url: toURL, append: false)
        else {
            throw nsError("OutputStream could not be created.")
        }
        
        out.open()
        
        // Apple Docs: "Currently unused. Set to 0."
        let opts = PropertyListSerialization.WriteOptions()
        
        var err: NSError?
        let result = PropertyListSerialization
            .writePropertyList(storage as Any,
                               to: out,
                               format: fileFormat,
                               options: opts,
                               error: &err)
        
        out.close()
        
        // number of bytes written; 0 indicates an error occurred
        if result == 0 {
            throw err ?? nsError("Unknown error.")
        }
        
        // update paths & format property after successful file save
        updatePaths(withURL: toURL)
        self.format = fileFormat
        
        if err != nil {
            throw err!
        }
        
    }
    
}
