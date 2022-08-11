//
//  PListArray Subscripts.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

/// aka extension PListArray
extension Array where Element == PListValue {
    // Internal type: NSString
    public subscript(string index: Index) -> String? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index] as? String
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[string: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value {
                self[index] = _value
            }
        }
    }
    
    // Internal type: NSNumber
    public subscript(int index: Index) -> Int? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index] as? Int
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[int: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value {
                self[index] = _value
            }
        }
    }
    
    // Internal type: NSNumber
    public subscript(double index: Index) -> Double? {
        get {
            guard indices.contains(index) else { return nil }
            
            // try Double first
            if let tryDouble = self[index] as? Double {
                return tryDouble
            }
            
            // otherwise see if there is an Int that can be read as a Double
            if let tryInt = self[index] as? Int {
                return Double(exactly: tryInt)
            }
            
            return nil
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[double: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value {
                self[index] = _value
            }
        }
    }
    
    // Internal type: NSCFBoolean / NSNumber boolValue
    public subscript(bool index: Index) -> Bool? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index] as? Bool
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[bool: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value {
                self[index] = _value
            }
        }
    }
    
    // Internal type: NSDate
    public subscript(date index: Index) -> Date? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index] as? Date
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[date: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value {
                self[index] = _value
            }
        }
    }
    
    // Internal type: NSData
    public subscript(data index: Index) -> Data? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index] as? Data
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[data: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value {
                self[index] = _value
            }
        }
    }
    
    /// Get: Access any index's value without prior knowledge of its type. You must then test for its type afterwards to determine what type it is. Returns nil if index does not exist (out-of-bounds).
    /// Set: Set a an index's value, as long as the index exists. Fails silently if index does not exist (out-of-bounds). Setting nil does nothing and will fail silently.
    public subscript(any index: Index) -> PListValue? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index]
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[any: index]
            yield &value
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value {
                self[index] = _value
            }
        }
    }
    
    // Internal type: Array<AnyObject> (ordered)
    public subscript(array index: Index) -> PList.PListArray?
        where Element: Hashable
    {
        get {
            guard indices.contains(index) else { return nil }
            return self[index] as? PList.PListArray
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue as? Element {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[array: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value as? Element {
                self[index] = _value
            }
        }
    }
    
    // Internal type: Dictionary<NSObject, AnyObject>
    public subscript(dict index: Index) -> PList.PListDictionary?
        where Element: Hashable
    {
        get {
            guard indices.contains(index) else { return nil }
            return self[index] as? PList.PListDictionary
        }
        set {
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _newValue = newValue as? Element {
                self[index] = _newValue
            }
        }
        _modify {
            var value = self[dict: index]
            yield &value
            
            guard indices.contains(index) else { return }
            
            // setting nil fails silently
            if let _value = value as? Element {
                self[index] = _value
            }
        }
    }
}
