//
//  Utilities.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension FileManager {
    /// Backwards compatible method for retrieving a temporary folder from the system.
    ///
    /// - copyright: Borrowed from [OTCore 1.1.8](https://github.com/orchetect/OTCore) under MIT license.
    static var temporaryDirectoryCompat: URL {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            return FileManager.default.temporaryDirectory
        } else {
            return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
    }
}

extension URL {
    /// Returns whether the file/folder exists.
    /// Convenience proxy for Foundation `.fileExists` method.
    ///
    /// - Will return `false` if used on a symlink and the symlink's original file does not exist.
    /// - Will still return `true` if used on an alias and the alias' original file does not exist.
    ///
    /// - copyright: Borrowed from [OTCore 1.1.8](https://github.com/orchetect/OTCore) under MIT license.
    var fileExists: Bool {
        FileManager.default.fileExists(atPath: path)
    }
}

extension URL {
    /// Attempts to first move a file to the Trash if possible, otherwise attempts to delete the file.
    ///
    /// If the file was moved to the trash, the new resulting `URL` is returned.
    ///
    /// If the file was deleted, `nil` is returned.
    ///
    /// If both operations were unsuccessful, an error is thrown.
    ///
    /// - copyright: Borrowed from [OTCore 1.1.8](https://github.com/orchetect/OTCore) under MIT license.
    @discardableResult
    func trashOrDelete() throws -> URL? {
        // funcs
        
        func __delFile(url: URL) throws {
            try FileManager.default.removeItem(at: url)
        }
        
        // platform-specific logic
        
        #if os(macOS) || targetEnvironment(macCatalyst) || os(iOS)
        
        if #available(macOS 10.8, iOS 11.0, *) {
            // move file to trash
            
            var resultingURL: NSURL?
            
            do {
                try FileManager.default.trashItem(at: self, resultingItemURL: &resultingURL)
            } catch {
                #if os(macOS)
                throw error
                #else
                // .trashItem has permissions issues on iOS; ignore and return without throwing
                return nil
                #endif
            }
            
            return resultingURL?.absoluteURL
            
        } else {
            // OS version requirements not met - delete file as a fallback
            
            try __delFile(url: self)
            return nil
        }
        
        #elseif os(tvOS)
        
        // tvOS has no Trash - just delete the file
        
        try __delFile(url: self)
        return nil
        
        #elseif os(watchOS)
        
        // watchOS has no Trash - just delete the file
        
        try __delFile(url: self)
        return nil
        
        #endif
    }
}
