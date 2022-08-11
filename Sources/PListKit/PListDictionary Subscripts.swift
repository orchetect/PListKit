//
//  PListDictionary Subscripts.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

/// aka extension PListDictionary
extension Dictionary where Key == String, Value == PListValue {
    // Internal type: NSString
    public subscript(string key: String) -> String? {
        get {
            self[key] as? String
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[string: key]
            yield &value
            self[key] = value
        }
    }
    
    // Internal type: NSNumber
    public subscript(int key: String) -> Int? {
        get {
            self[key] as? Int
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[int: key]
            yield &value
            self[key] = value
        }
    }
    
    // Internal type: NSNumber
    public subscript(double key: String) -> Double? {
        get {
            // try Double first
            if let tryDouble = self[key] as? Double {
                return tryDouble
            }
            
            // otherwise see if there is an Int that can be read as a Double
            if let tryInt = self[key] as? Int {
                return Double(exactly: tryInt)
            }
            
            return nil
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[double: key]
            yield &value
            self[key] = value
        }
    }
    
    // Internal type: NSCFBoolean / NSNumber boolValue
    public subscript(bool key: String) -> Bool? {
        get {
            self[key] as? Bool
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[bool: key]
            yield &value
            self[key] = value
        }
    }
    
    // Internal type: NSDate
    public subscript(date key: String) -> Date? {
        get {
            self[key] as? Date
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[date: key]
            yield &value
            self[key] = value
        }
    }
    
    // Internal type: NSData
    public subscript(data key: String) -> Data? {
        get {
            self[key] as? Data
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[data: key]
            yield &value
            self[key] = value
        }
    }
    
    /// Get: Access any key's value without prior knowledge of its type. You must then test for its type afterwards to determine what type it is.
    /// Set: Set a key's value, identical to setting the standard subscript `self[] =`.
    public subscript(any key: String) -> PListValue? {
        get {
            self[key]
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[any: key]
            yield &value
            self[key] = value
        }
    }
    
    // Internal type: Array<AnyObject> (ordered)
    public subscript(array key: String) -> PList.PListArray? {
        get {
            self[key] as? PList.PListArray
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[array: key]
            yield &value
            self[key] = value
        }
    }
    
    // if key exists and it's an array, return it. if key does not exist, create new array and return it. if key exists but it's not an array, return nil.
    // Internal type: Array<AnyObject> (ordered)
    public subscript(arrayCreate key: String) -> PList.PListArray? {
        mutating get {
            if self[key] != nil { // key exists, but we're not sure it's an array yet
                return self[array: key] // if it's an array, return it
            }
            
            // key does not exist, so let's create it as a new array and return it
            
            self[key] = PList.PListArray()
            
            return self[array: key]
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[arrayCreate: key]
            yield &value
            self[key] = value
        }
    }
    
    // if key exists and it's a dictionary, return it. otherwise return nil.
    // Internal type: Dictionary<NSObject, AnyObject>
    public subscript(dict key: String) -> PList.PListDictionary? {
        get {
            self[key] as? PList.PListDictionary
        }
        set {
            if newValue == nil {
                self[key] = nil
            } else {
                self[key] = newValue
            }
        }
        _modify {
            var value = self[dict: key]
            yield &value
            self[key] = value
        }
    }
    
    // if key exists and it's a dictionary, return it. if key does not exist, create new dictionary and return it. if key exists but it's not a dictionary, return nil.
    // Internal type: Dictionary<NSObject, AnyObject>
    public subscript(dictCreate key: String) -> PList.PListDictionary? {
        mutating get {
            if self[key] != nil { // key exists, but we're not sure it's a dictionary yet
                return self[dict: key] // if it's a dictionary, return it
            }
            
            // key does not exist, so let's create it as a new dictionary and return it
            
            self[key] = PList.PListDictionary()
            
            return self[dict: key]
        }
        set {
            self[key] = newValue
        }
        _modify {
            var value = self[dictCreate: key]
            yield &value
            self[key] = value
        }
    }
}
