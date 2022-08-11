//
//  PListDictionary.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

extension PList {
    #if swift(>=5.7)
    public typealias PListDictionary = [String: any PListValue]
    #else
    /// Translated Dictionary type used by PList
    public typealias PListDictionary = [String: PListValue]
    #endif
}

extension PList.RawDictionary {
    public func convertedToPListDictionary() -> PList.PListDictionary? {
        // translate to Swift-friendly types
        
        var newDict: PList.PListDictionary = [:]
        
        for (keyRaw, value) in self {
            // key must be translatable to String
            guard let key = keyRaw as? String else { return nil }
            
            // if key == "SidebarWidthTenElevenOrLater" {
            //    print("SidebarWidthTenElevenOrLater - type: ", String(describing: type(of: value)), "value:", value)
            //    print("NSNumber doubleValue:", (value as? NSNumber)?.doubleValue as Any)
            //    print("NSNumber intValue:", (value as? NSNumber)?.intValue as Any)
            //    (value as? NSNumber)?.boolValue
            //    (value as? NSNumber)?.decimalValue
            //    (value as? NSNumber)?.doubleValue
            //    (value as? NSNumber)?.floatValue
            //    (value as? NSNumber)?.attributeKeys
            //    (value as? NSNumber)?.className
            // }
            
            // ***** type(of:) is a workaround to test for a boolean type, since testing for NSNumber's boolValue constants is tricky in Swift
            // this may be a computationally expensive operation, so ideally it should be replaced with a better method in future
            
            if String(describing: type(of: value)) == "__NSCFBoolean" {
                // ensure conversion to Bool actually succeeds; if not, add as its original type as a silent failsafe
                if let val = value as? Bool {
                    newDict[key] = val
                } else {
                    return nil
                }
                
            } else {
                switch value {
                case let val as String:
                    newDict[key] = val
                    
                case let val as Int:
                    // ***** values stored as <real> will import as Int if they have a decimal of .0
                    newDict[key] = val
                    
                case let val as Double:
                    newDict[key] = val
                    
                case let val as Date:
                    newDict[key] = val
                    
                case let val as Data:
                    newDict[key] = val
                    
                case let val as PList.RawDictionary:
                    guard let translated = val.convertedToPListDictionary() else { return nil }
                    newDict[key] = translated
                    
                case let val as PList.RawArray:
                    guard let translated = val.convertedToPListArray() else { return nil }
                    newDict[key] = translated
                    
                default:
                    return nil // this should never happen
                }
            }
        }
        
        return newDict
    }
}
