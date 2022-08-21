//
//  PListLoadError.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Error returned when loading a `PList` file.
public enum PListLoadError: Error {
    case fileNotFound
    case formatNotExpected
    case unexpectedKeyTypeEncountered
    case unexpectedKeyValueEncountered
    case unhandledType
}
