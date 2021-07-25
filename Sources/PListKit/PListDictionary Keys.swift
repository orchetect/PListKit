//
//  PListDictionary Keys.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

// MARK: - Extra methods

extension Dictionary where Key == String, Value == PListValue {
    
    // MARK: - Key-Pairs by type
    
    /// Returns all key-pairs containing String values.
    public var getStringKeyPairs: [String : String] {
        self.filter({ $0.value is String }) as? [String : String]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Int (non-float, non-boolean) values.
    public var getIntKeyPairs: [String : Int] {
        self.filter({ $0.value is Int }) as? [String : Int]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Double (non-int, non-boolean) values.
    public var getDoubleKeyPairs: [String : Double] {
        // ensure value cannot be represented as a non-float (ie: Int or Bool)
        self.filter({ $0.value is Double }) as? [String : Double]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Bool (non-int) values.
    public var getBoolKeyPairs: [String : Bool] {
        self.filter({ $0.value is Bool }) as? [String : Bool]
            ?? [:]
        
    }
    
    /// Returns all key-pairs containing Data values.
    public var getDataKeyPairs: [String : Data] {
        self.filter({ $0.value is Data }) as? [String : Data]
            ?? [:]
    }
    
    /// Returns all key-pairs containing Date values.
    public var getDateKeyPairs: [String : Date] {
        self.filter({ $0.value is Date }) as? [String : Date]
            ?? [:]
    }
    
    /// Returns all key-pairs that are Dictionaries.
    public var getDictionaryKeyPairs: [String : PList.PListDictionary] {
        self.filter({ $0.value is PList.PListDictionary }) as? [String : PList.PListDictionary]
            ?? [:]
    }
    
    /// Returns all key-pairs that are ordered Arrays.
    public var getArrayKeyPairs: [String : PList.PListArray] {
        self.filter({ $0.value is PList.PListArray }) as? [String : PList.PListArray]
            ?? [:]
    }
    
    
    // MARK: - Key Names by type
    
    /// Returns all keys containing String values.
    public var getStringKeys: Dictionary<String, String>.Keys {
        self.getStringKeyPairs.keys
    }
    
    /// Returns all keys containing Int (non-float, non-boolean) values.
    public var getIntKeys: Dictionary<String, Int>.Keys {
        self.getIntKeyPairs.keys
    }
    
    /// Returns all keys containing Double (non-int, non-boolean) values.
    public var getDoubleKeys: Dictionary<String, Double>.Keys {
        self.getDoubleKeyPairs.keys
    }
    
    /// Returns all keys containing Bool (non-int) values.
    public var getBoolKeys: Dictionary<String, Bool>.Keys {
        self.getBoolKeyPairs.keys
    }
    
    /// Returns all keys containing Data values.
    public var getDataKeys: Dictionary<String, Data>.Keys {
        self.getDataKeyPairs.keys
    }
    
    /// Returns all keys containing Date values.
    public var getDateKeys: Dictionary<String, Date>.Keys {
        self.getDateKeyPairs.keys
    }
    
    /// Returns all keys that are Dictionaries.
    public var getDictionaryKeys: Dictionary<String, PList.PListDictionary>.Keys {
        self.getDictionaryKeyPairs.keys
    }
    
    /// Returns all keys that are ordered Arrays.
    public var getArrayKeys: Dictionary<String, PList.PListArray>.Keys {
        self.getArrayKeyPairs.keys
    }
    
}
