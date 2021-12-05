//
//  PListArray.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

extension PList {
    
    /// Translated Array type used by PList
    public typealias PListArray = Array<PListValue>
    
}

extension PList.RawArray {
    
    /// Function to recursively translate a raw dictionary imported via NSDictionary to a Swift-friendly typed tree.
    public func convertedToPListArray() -> PList.PListArray? {
        
        // translate to Swift-friendly types
        
        var newArray: PList.PListArray = []
        
        for element in self {
            
            // ***** type(of:) is a workaround to test for a boolean type,
            // since testing for NSNumber's boolValue constants is tricky in Swift
            // this may be a computationally expensive operation, so ideally it should be replaced with a better method in future
            
            if String(describing: type(of: element)) == "__NSCFBoolean" {
                
                // ensure conversion to Bool actually succeeds; if not, add as its original type as a silent failsafe
                if let val = element as? Bool {
                    newArray.append(val)
                } else {
                    return nil
                }
                
            } else {
                
                switch element {
                case let val as String:
                    newArray.append(val)
                    
                case let val as Int:
                    // ***** values stored as <real> will import as Int if they have a decimal of .0
                    newArray.append(val)
                    
                case let val as Double:
                    newArray.append(val)
                    
                case let val as Date:
                    newArray.append(val)
                    
                case let val as Data:
                    newArray.append(val)
                    
                case let val as PList.RawDictionary:
                    guard let translated = val.convertedToPListDictionary() else { return nil }
                    newArray.append(translated)
                    
                case let val as PList.RawArray:
                    guard let translated = val.convertedToPListArray() else { return nil }
                    newArray.append(translated)
                    
                default:
                    return nil // this should never happen
                }
                
            }
            
        }
        
        return newArray
        
    }
    
}
