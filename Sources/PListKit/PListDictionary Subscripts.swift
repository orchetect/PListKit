//
//  PListDictionary Subscripts.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

// MARK: - PListDictionary subscripts
// Essentially, an extension on PListDictionary to provide subscript chaining for keys and nested dictionaries

public extension Dictionary where Key == String, Value == PListValue {
    
    // Internal type: NSString
    subscript(string key: String) -> String? {
        get {
            return self[key] as? String
        }
        set {
            self[key] = newValue
        }
    }
    
    // Internal type: NSNumber
    subscript(int key: String) -> Int? {
        get {
            return self[key] as? Int
        }
        set {
            self[key] = newValue
        }
    }
    
    // Internal type: NSNumber
    subscript(double key: String) -> Double? {
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
    }
    
    // Internal type: NSCFBoolean / NSNumber boolValue
    subscript(bool key: String) -> Bool? {
        get {
            return self[key] as? Bool
        }
        set {
            self[key] = newValue
        }
    }
    
    // Internal type: NSDate
    subscript(date key: String) -> Date? {
        get {
            return self[key] as? Date
        }
        set {
            self[key] = newValue
        }
    }
    
    // Internal type: NSData
    subscript(data key: String) -> Data? {
        get {
            return self[key] as? Data
        }
        set {
            self[key] = newValue
        }
    }
    
    // Get: Access any key's value without prior knowledge of its type. You must then test for its type afterwards to determine what type it is.
    // Set: Set a key's value, as long as the value passed is a compatible type acceptable as a PList key's value.
    subscript(any key: String) -> PListValue? {
        get {
            return self[key]
        }
        set {
            self[key] = newValue
        }
    }
    
    // Internal type: Array<AnyObject> (ordered)
    subscript(array key: String) -> PList.PListArray? {
        get {
            return self[key] as? PList.PListArray
        }
        set {
            self[key] = newValue
        }
    }
    
    // if key exists and it's an array, return it. if key does not exist, create new array and return it. if key exists but it's not an array, return nil.
    // Internal type: Array<AnyObject> (ordered)
    subscript(arrayCreate key: String) -> PList.PListArray? {
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
    }
    
    // if key exists and it's a dictionary, return it. otherwise return nil.
    // Internal type: Dictionary<NSObject, AnyObject>
    subscript(dict key: String) -> PList.PListDictionary? {
        get {
            return self[key] as? PList.PListDictionary
        }
        set {
            if newValue == nil {
                self[key] = nil
            } else {
                self[key] = newValue
            }
        }
    }
    
    // if key exists and it's a dictionary, return it. if key does not exist, create new dictionary and return it. if key exists but it's not a dictionary, return nil.
    // Internal type: Dictionary<NSObject, AnyObject>
    subscript(dictCreate key: String) -> PList.PListDictionary? {
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
    }
    
}
