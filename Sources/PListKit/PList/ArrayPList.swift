//
//  ArrayPList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Class representing a Property List (plist) with a ``PListArray`` root.
///
/// - To initialize an empty plist, use ``PList/init()``.
/// - To load a plist file from file path or URL, use the ``PList/init(file:)`` or
/// ``PList/init(url:)`` constructor.
/// - To load a raw plist file content, use the ``PList/init(data:)`` or ``PList/init(xml:)``
///   constructor.
/// - To save to a file, use ``PList/save(toFileAtPath:format:)``, or
///   ``PList/save(toFileAtURL:format:)``.
///
/// - Note: This plist root type is less common than ``DictionaryPList``.
public typealias ArrayPList = PList<PListArray>

extension ArrayPList {
    /// Instantiate an `ArrayPList` object by populating its contents using an existing dictionary.
    ///
    /// - parameters:
    ///   - root: Source raw array
    ///   - format: Property list format
    ///
    /// - throws: ``PListLoadError``
    public convenience init(
        converting root: RawPListArray,
        format: PListFormat = .xml
    ) throws {
        guard let converted = root.convertedToPListArray() else {
            throw PListLoadError.formatNotExpected
        }
        
        self.init(root: converted, format: format)
    }
}
