//
//  PListDictionary Keys.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Extra methods

extension PListDictionary {
    // MARK: - Key-Pairs by type
    
    /// Returns all key-pairs containing String values.
    public var getStringKeyPairs: [String: String] {
        filter { $0.value is String } as? [String: String]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Int (non-float, non-boolean) values.
    public var getIntKeyPairs: [String: Int] {
        filter { $0.value is Int } as? [String: Int]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Double (non-int, non-boolean) values.
    public var getDoubleKeyPairs: [String: Double] {
        // ensure value cannot be represented as a non-float (ie: Int or Bool)
        filter { $0.value is Double } as? [String: Double]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Bool (non-int) values.
    public var getBoolKeyPairs: [String: Bool] {
        filter { $0.value is Bool } as? [String: Bool]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Data values.
    public var getDataKeyPairs: [String: Data] {
        filter { $0.value is Data } as? [String: Data]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Date values.
    public var getDateKeyPairs: [String: Date] {
        filter { $0.value is Date } as? [String: Date]
            ?? [:]
    }
    
    /// Returns all key-pairs that are Dictionaries.
    public var getDictionaryKeyPairs: [String: PListDictionary] {
        filter { $0.value is PListDictionary } as? [String: PListDictionary]
            ?? [:]
    }
    
    /// Returns all key-pairs that are ordered Arrays.
    public var getArrayKeyPairs: [String: PListArray] {
        filter { $0.value is PListArray } as? [String: PListArray]
            ?? [:]
    }
    
    // MARK: - Key Names by type
    
    /// Returns all keys containing String values.
    public var getStringKeys: Dictionary<String, String>.Keys {
        getStringKeyPairs.keys
    }
    
    /// Returns all keys containing Int (non-float, non-boolean) values.
    public var getIntKeys: Dictionary<String, Int>.Keys {
        getIntKeyPairs.keys
    }
    
    /// Returns all keys containing Double (non-int, non-boolean) values.
    public var getDoubleKeys: Dictionary<String, Double>.Keys {
        getDoubleKeyPairs.keys
    }
    
    /// Returns all keys containing Bool (non-int) values.
    public var getBoolKeys: Dictionary<String, Bool>.Keys {
        getBoolKeyPairs.keys
    }
    
    /// Returns all keys containing Data values.
    public var getDataKeys: Dictionary<String, Data>.Keys {
        getDataKeyPairs.keys
    }
    
    /// Returns all keys containing Date values.
    public var getDateKeys: Dictionary<String, Date>.Keys {
        getDateKeyPairs.keys
    }
    
    /// Returns all keys that are Dictionaries.
    public var getDictionaryKeys: Dictionary<String, PListDictionary>.Keys {
        getDictionaryKeyPairs.keys
    }
    
    /// Returns all keys that are ordered Arrays.
    public var getArrayKeys: Dictionary<String, PListArray>.Keys {
        getArrayKeyPairs.keys
    }
}
