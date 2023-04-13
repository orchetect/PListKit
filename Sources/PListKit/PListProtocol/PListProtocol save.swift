//
//  PListProtocol save.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PListProtocol {
    /// Save the PList file to disk, overwriting without confirmation.
    ///
    /// - parameter toFile: An absolute or relative file path.
    /// - parameter format: Data format on disk when saving.
    ///
    public func save(
        toFileAtPath path: String,
        format: PListFormat? = nil
    ) throws {
        guard let outputStream = OutputStream(toFileAtPath: path, append: false)
        else {
            throw nsError("OutputStream could not be created.")
        }
        
        try save(to: outputStream, format: format)
    }
    
    /// Save the PList file to disk, overwriting without confirmation.
    ///
    /// - parameter toURL: A full file URL.
    /// - parameter format: Data format on disk when saving.
    ///
    public func save(
        toFileAtURL url: URL,
        format: PListFormat? = nil
    ) throws {
        guard let outputStream = OutputStream(url: url, append: false)
        else {
            throw nsError("OutputStream could not be created.")
        }
        
        try save(to: outputStream, format: format)
    }
    
    func save(
        to outputStream: OutputStream,
        format: PListFormat? = nil
    ) throws {
        let fileFormat = format ?? self.format
        
        outputStream.open()
        
        // Apple Docs: "Currently unused. Set to 0."
        let opts = PropertyListSerialization.WriteOptions()
        
        var err: NSError?
        let result = PropertyListSerialization.writePropertyList(
            storage as Any,
            to: outputStream,
            format: fileFormat,
            options: opts,
            error: &err
        )
        
        outputStream.close()
        
        // number of bytes written; 0 indicates an error occurred
        if result == 0 {
            throw err ?? nsError("Unknown error.")
        }
        
        if err != nil {
            throw err!
        }
    }
}
