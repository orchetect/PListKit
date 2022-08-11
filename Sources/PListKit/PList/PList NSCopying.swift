//
//  PList NSCopying.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

extension PList: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        // copy the class including data and properties
        // and omit transient information such as `filePath` and `fileURL`
        
        let copy = PList(dictionary: storage)
        
        copy.format = format
        copy.createIntermediateDictionaries = createIntermediateDictionaries
        
        return copy
    }
}
