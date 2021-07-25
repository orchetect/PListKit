//
//  PList Types.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

// MARK: - Types

extension PList {
    
    /// Raw NSDictionary used by PropertyListSerialization
    public typealias RawDictionary = Dictionary<NSObject, AnyObject>
    
    /// Raw NSArray array used by PropertyListSerialization
    public typealias RawArray = Array<AnyObject>
    
}

// PList native types

extension PList {
    
    /// Translated Dictionary type used by PList
    public typealias PListDictionary = Dictionary<String, PListValue>
    
    /// Translated Array type used by PList
    public typealias PListArray = Array<PListValue>
    
}
