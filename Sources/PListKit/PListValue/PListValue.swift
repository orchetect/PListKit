//
//  PListValue.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol representing all native Swift value types that property lists support, to facilitate type safety and help prevent PList file save failure due to inadvertent use of incompatible value types.
public protocol PListValue {
    static func defaultPListValue() -> Self
}

// MARK: - Concrete Type Conformances

extension String: PListValue {
    public static func defaultPListValue() -> Self { "" }
}

extension Int: PListValue {
    public static func defaultPListValue() -> Self { 0 }
}

extension Double: PListValue {
    public static func defaultPListValue() -> Self { 0.0 }
}

extension Bool: PListValue {
    public static func defaultPListValue() -> Self { false }
}

extension Date: PListValue {
    public static func defaultPListValue() -> Self { Date() }
}

extension Data: PListValue {
    public static func defaultPListValue() -> Self { Data() }
}

#if swift(>=5.7)
extension Dictionary: PListValue where Key == String, Value == any PListValue {
    public static func defaultPListValue() -> Self { [:] }
}
#else
extension Dictionary: PListValue where Key == String, Value == PListValue {
    public static func defaultPListValue() -> Self { [:] }
}
#endif

#if swift(>=5.7)
extension Array: PListValue where Element == any PListValue {
    public static func defaultPListValue() -> Self { [] }
}
#else
extension Array: PListValue where Element == PListValue {
    public static func defaultPListValue() -> Self { [] }
}
#endif

// MARK: - Strong-Typer

/// Helper method that returns `self` as a `PListValue` if it is a valid plist element type.
public func convertToPListValue(from object: Any) -> PListValue? {
    // ***** type(of:) is a workaround to test for a boolean type,
    // since testing for NSNumber's boolValue constants is tricky in Swift
    // this may be a computationally expensive operation, so ideally it should be replaced with a better method in future
    
    if String(describing: type(of: object)) == "__NSCFBoolean" {
        // ensure conversion to Bool actually succeeds; if not, add as its original type as a silent failsafe
        if let val = object as? Bool {
            return val
        } else {
            return nil
        }
        
    } else {
        switch object {
        case let obj as String:
            return obj
            
        case let obj as Int:
            // Note: values stored as <real> will import as Int if they have a decimal of .0
            return obj
            
        case let obj as Double:
            return obj
            
        case let obj as Date:
            return obj
            
        case let obj as Data:
            return obj
            
        case let obj as RawPListDictionary:
            guard let translated = obj.convertedToPListDictionary() else { return nil }
            return translated
            
        case let obj as RawPListArray:
            guard let translated = obj.convertedToPListArray() else { return nil }
            return translated
            
        default:
            // this should never happen unless the user conforms a type to `PlistValue`
            return nil
        }
    }
}
