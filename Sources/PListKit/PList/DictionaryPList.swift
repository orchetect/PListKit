//
//  DictionaryPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist) with a ``PListDictionary`` root.
/// This is the most common plist root layout and provides the most amount of useful abstractions of all plist classes in PListKit.
///
/// - To initialize an empty plist, use ``PList/init()``.
/// - To load a plist file from file path or URL, use the ``PList/init(file:)`` or ``PList/init(url:)`` constructor.
/// - To load a raw plist file content, use the ``PList/init(data:)`` or ``PList/init(xml:)`` constructor.
/// - To save to a file, use ``PList/save(toFileAtPath:format:)``, or ``PList/save(toFileAtURL:format:)``.
public typealias DictionaryPList = PList<PListDictionary>

extension DictionaryPList {
    /// Set default behavior when using the `[dict:]` subscript.
    /// When set to `true`, all `[dict:]` subscript usage will take on `[dictCreate:]` functionality.
    public var createIntermediateDictionaries: Bool {
        get { _createIntermediateDictionaries }
        set { _createIntermediateDictionaries = newValue }
    }
    
    /// Functional nesting dictionary tree classes for clean syntax.
    public var root: PListNode.Root {
        // Create and return a new class every time this property is accessed, to avoid storing an instance of it
        PListNode.Root(delegate: self)
    }
}

extension DictionaryPList {
    /// Instantiate a `DictionaryPList` object by populating its contents using an existing dictionary.
    ///
    /// - parameters:
    ///   - root: Source raw dictionary
    ///   - format: Property list format
    ///
    /// - throws: ``PListLoadError``
    public convenience init(
        converting root: RawPListDictionary,
        format: PListFormat = .xml
    ) throws {
        guard let converted = root.convertedToPListDictionary() else {
            throw PListLoadError.formatNotExpected
        }
        
        self.init(root: converted, format: format)
    }
}
