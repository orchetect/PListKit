//
//  PList Errors.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

extension PList {
    
    /// Result descriptor that is returned while or after loading a `PList` file.
    public enum LoadError: Error {
        
        case fileNotFound
        case formatNotExpected
        case unexpectedKeyTypeEncountered
        case unexpectedKeyValueEncountered
        case unhandledType
        
    }
    
}
