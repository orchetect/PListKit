//
//  PListArray.swift
//  PListKit 
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

// MARK: - Create Array/Dict

extension PList {
	
	/// Function to recursively translate a raw dictionary imported via NSDictionary to a Swift-friendly typed tree.
	public static func ConvertToPListArray(_ sourceArray: RawArray) -> PListArray? {
		
		// translate to Swift-friendly types
		
		var newArray: PListArray = []
		
		for element in sourceArray {
			
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
					
				case let val as RawDictionary:
					guard let translated = ConvertToPListDictionary(val) else { return nil }
					newArray.append(translated)
					
				case let val as RawArray:
					guard let translated = ConvertToPListArray(val) else { return nil }
					newArray.append(translated)
					
				default:
					return nil // this should never happen
				}
				
			}
			
		}
		
		return newArray
		
	}
	
}

// aka, extension [AnyObject]
extension Array where Element: AnyObject {
	
	/// Conveience property: same as calling `PList.ConvertToPListArray(self)`
	public var PListArrayRepresentation: PList.PListArray? {
		
		PList.ConvertToPListArray(self)
		
	}
	
}
