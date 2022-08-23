//
//  PListLoadError.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Error returned by ``PList`` methods which read file contents.
public enum PListLoadError: Error {
    case fileNotFound
    case formatNotExpected
    case unexpectedKeyTypeEncountered
    case unexpectedKeyValueEncountered
    case unhandledType
}
