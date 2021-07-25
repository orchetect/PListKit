//
//  PList Helpers.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

extension PList {
    
    /// Internal function to update `filePath` and `fileURL` properties.
    internal func updatePaths(withFilePath: String) {
        
        filePath = withFilePath
        fileURL = URL(fileURLWithPath: withFilePath)
        
    }
    
    /// Internal function to update `filePath` and `fileURL` properties.
    internal func updatePaths(withURL: URL) {
        
        filePath = withURL.isFileURL ? withURL.path : nil
        fileURL = withURL
        
    }
    
}
