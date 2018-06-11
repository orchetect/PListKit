//
//  PList.swift
//  OTPList
//
//  Created by Steffan Andrews
//  Last updated 2018-Jun-10
//  Copyright © 2018 Steffan Andrews. All rights reserved. | MIT License
//  https://github.com/orchetect/OTPList

import Foundation

// MARK: - Apple Docs Link
// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html

// MARK: - Notes and To-Dos
//   - [ ] does creating or saving over a protected plist file work? (ie: in root or user preferences folder). may need an authenticated read/save method.
//   - [ ] update .format property after loading a plist file, based on what the source plist file's format is

// MARK: - Types

fileprivate typealias OTPListRawDictionary = Dictionary<NSObject, AnyObject>	// format that NSDictionary operates in, needed for PList import
fileprivate typealias OTPListRawArray = Array<AnyObject>						// format that NSDictionary operates in, needed for PList import
public typealias OTPListDictionary = Dictionary<String, OTPListValue>
public typealias OTPListArray = Array<OTPListValue>

/// An umbrella protocol that is adopted by all common Swift types that PList files allow as value types, to enforce compatibility and prevent file save failure due to incompatible value types.
public protocol OTPListValue { }
// Add this protocol conformance to all supported PLIst value types
extension String    : OTPListValue { }
extension Int       : OTPListValue { }
extension Double    : OTPListValue { }
extension Bool      : OTPListValue { }
extension Date      : OTPListValue { }
extension Data      : OTPListValue { }
extension Dictionary: OTPListValue where Key == String, Value == OTPListValue { }
extension Array     : OTPListValue where Element == OTPListValue { }

/// Result descriptor that is returned while or after loading a `OTPList` PList file.
public enum OTPListLoadResult {
	case success
	case fileNotFound
	case formatNotExpected
	case unexpectedKeyTypeEncountered
	case unexpectedKeyValueEncountered
	case unhandledType
}

/// Result descriptor that is returned while or after saving a `OTPList` PList file.
public enum OTPListSaveResult: Equatable {
	case success
	case error(code: Int?, description: String)
}
// Make OTPListSaveResult equatable so we can easily check the result
// ie: if plist.save() == .success { print("success") }
public func ==(lhs: OTPListSaveResult, rhs: OTPListSaveResult) -> Bool {
	switch (lhs, rhs) {
	case (.success, .success):
		return true
		
	case (let .error(codeA, descriptionA), let .error(codeB, descriptionB)):
		return codeA == codeB && descriptionA == descriptionB
		
	default: return false
	}
}

// MARK: - Main PList class

/** Class representing a PList file.

**Files**

- To load a file, use `load(fromFile:)` or `load(fromURL:)`, or use the `init(fromFile:)`/`init(fromURL:)` constructors.
- To save a loaded file, use `save()`.
- To save to a new file, use `save(toFile:)`, or `save(toURL:)`.

**Keys and Values**

- To create, update, or read a key's value, use the subscripts.
```
let plist = PTList()
plist.content[any: "KeyName"]		// return as type OTPListValue; you can test for type after

plist.content[string: "KeyName"]
plist.content[int: "KeyName"]
plist.content[float: "KeyName"]
plist.content[bool: "KeyName"]
plist.content[date: "KeyName"]
plist.content[data: "KeyName"]
plist.content[array: "KeyName"]

plist.content[dict: "KeyName"]		// top-level dictionaries
plist.content[dict: "KeyName"]?[dict: "KeyName"]	// nested dictionaries
plist.content[dict: "KeyName"]?[dict: "KeyName"]?[dict: "KeyName"] // etc.
```
- To create a dictionary, use the subscripts to add a dictionary of type `OTPListDictionary` or use the `createDisctionary(...)` method to create an empty dictionary.

```
plist.content.createDictionary(name: "Dict")
//   OR
plist.content[dict: "Dict"] = [:]
```
- To create an array, use the subscripts to add an array of any arbitrary type. Note: when reading an array, it will be returned as `OTPListArray` (`Array<OTPListValue>`).

```
// empty:
plist.content[array: "Array 1"] = []

// populated:
plist.content[array: "Array 2"] = ["string1", "string2"]
plist.content[array: "Array 3"] = [1, 2]
plist.content[array: "Array 4"] = ["string", 1, 2]
```
- To delete a key or dictionary, use the subscripts and set it to nil.
- Nested keys within dictionaries can be conveniently read or set using subscript chaining:

```
// ie: <root>\<Dict 1>\<Dict 2>\<string>
let x = plist.content[dict: "Dict 1"]?[dict: "Dict 2"]?[string: "KeyName"]
plist.content[dict: "Dict 1"]?[dict: "Dict 2"]?[string: "KeyName"] = "new value"
```

When reading from an Array, elements are of type `OTPListValue`. You need to test each element to determine its actual type. This can also be done with an iterator to both determine the type and cast it to that type at the same time:

```
for (key, value) in plist.content {
switch value {
case let val as String: print("key: \"\(key)\", string: \(val)")
case let val as Int: print("key: \"\(key)\", int: \(val)")
case let val as Double: print("key: \"\(key)\", float: \(val)")
case let val as Bool: print("key: \"\(key)\", bool: \(val)")
case let val as Data: print("key: \"\(key)\", data: \(val.count) bytes")
case let val as Date: print("key: \"\(key)\", date: \(val)")
case let val as OTPListDictionary: print("key: \"\(key)\", dictionary: \(val.count) children")
case let val as OTPListArray: print("key: \"\(key)\", array: \(val.count) children")
default: fatalError("Unexpected value type for key \(key). This should never happen.")
}
}
```

When you want to read a key's value and don't know what the key's type is expected to be, you can use the `[any: ""]` subscript to get the value, then test the value's type as demonstrated above.

**Conveniences**

Access these variables to return a filtered set of keys or key-pairs, based on their type. Note that these return copies, so you cannot use these to set values in the PList. Values must still be set via the main `content` property.

```
let x = plist.content.getStringKeys
let x = plist.content.getStringKeyPairs
let x = plist.content.getIntKeys
let x = plist.content.getIntKeyPairs
let x = plist.content.getFloatKeys
let x = plist.content.getFloatKeyPairs
let x = plist.content.getBoolKeys
let x = plist.content.getBoolKeyPairs
let x = plist.content.getDateKeys
let x = plist.content.getDateKeyPairs
let x = plist.content.getDataKeys
let x = plist.content.getDataKeyPairs
let x = plist.content.getDictionaryKeys
let x = plist.content.getDictionaryKeyPairs
let x = plist.content.getArrayKeys
let x = plist.content.getArrayKeyPairs
```

*/
public struct OTPList {
	
	// globals
	
	private let fileManager = FileManager.default
	
	// instance variables
	
	/// Get-only property that returns the path and filename of the currently loaded PList file.
	private(set) public var filePath: String? = nil
	
	/// Get-only property that returns the URL of the currently loaded PList file.
	private(set) public var fileURL: URL? = nil
	
	/** Main root dictionary of the PList file, containing all keys and nested dictionaries. (See the main `OTPList` class help block for examples of how to get or set keys and nested dictionaries via this property.)
	
	Valid value types:
	
	- `String`
	- `Int`
	- `Double`
	- `Bool`
	- `Date`
	- `Data`
	- `OTPListDictionary`
	- `OTPListArray`
	*/
	public var content: OTPListDictionary = [:]
	
	/// Data format of PList when saved to disk.
	public var format: PropertyListSerialization.PropertyListFormat = .xml
	
	/// Create an empty PList object.
	public init() {}
	
	/// Instantiate a PList object by loading a plist file from disk.
	///
	/// Because this is a failable initializer, the specific error type is not returned if there is an error while attempting to load a file. Instead, the intializer simply fails and a `nil` object is returned.
	/// - parameter fromFile: A full or relative pathname.
	public init?(fromFile: String) {
		if load(fromFile: fromFile) != .success { return nil }
	}
	
	/// Instantiate a PList object by loading a plist file from disk.
	///
	/// Because this is a failable initializer, the specific error type is not returned if there is an error while attempting to load a file. Instead, the intializer simply fails and a `nil` object is returned.
	/// - parameter fromURL: A full URL.
	public init?(fromURL: URL) {
		if load(fromURL: fromURL) != .success { return nil }
	}
	
	/// Instantiate a PList object and populate its contents using an existing dictionary.
	/// - parameter fromDictionary: Source dictionary to read from.
	public init(fromDictionary: OTPListDictionary) {
		content = fromDictionary
	}
	
	/// Load a PList file's contents from disk. If successful, the current contents stored in `content` are discarded and replaced with the newly loaded PList's contents. If unsuccessful, returns an error case of `OTPListLoadResult`.
	/// - parameter fromFile: A full or relative pathname.
	/// - returns: Success or error type as `OTPListLoadResult`
	@discardableResult
	public mutating func load(fromFile: String) -> OTPListLoadResult {
		guard fileManager.fileExists(atPath: fromFile) else { return .fileNotFound }
		
		// load as raw NS objects
		guard let getDict = NSMutableDictionary(contentsOfFile: fromFile) as OTPListRawDictionary? else { return .formatNotExpected }
		
		// translate to friendly Swift types
		guard let translatedDict = parseRawDictionary(sourceDictionary: getDict) else { return .formatNotExpected }
		
		content = translatedDict
		updatePaths(withFilePath: fromFile)
		
		return .success
	}
	
	/// Load a PList file's contents from disk. If successful, the current contents stored in `content` are discarded and replaced with the newly loaded PList's contents. If unsuccessful, returns an error case of `OTPListLoadResult`.
	/// - parameter fromURL: A full URL.
	/// - returns: Success or error type as `OTPListLoadResult`
	@discardableResult
	public mutating func load(fromURL: URL) -> OTPListLoadResult {
		if fromURL.isFileURL {
			guard fileManager.fileExists(atPath: fromURL.path) else { return .fileNotFound }
		}
		
		// load as raw NS objects
		guard let getDict = NSMutableDictionary(contentsOf: fromURL) as OTPListRawDictionary? else { return .formatNotExpected }
		
		// translate to friendly Swift types
		guard let translatedDict = parseRawDictionary(sourceDictionary: getDict) else { return .formatNotExpected }
		
		content = translatedDict
		updatePaths(withURL: fromURL)
		
		return .success
	}
	
	/** Save a PList file to disk.
	Save the PList file to disk, overwriting without confirmation. First checks `filePath` and saves to that location. If empty, checks `fileURL` and saves to that location instead. If both are empty, returns `false` and fails to save the file.
	- parameter format: Data format on disk when saving.
	- returns: `OTPListSaveResult`
	*/
	@discardableResult
	public mutating func save(format: PropertyListSerialization.PropertyListFormat? = nil) -> OTPListSaveResult {
		let fileFormat = format != nil ? format! : self.format // if passed as nil, use `format` property
		
		if let fp = filePath { return save(toFile: fp, format: fileFormat) }
		if let fu = fileURL { return save(toURL: fu, format: fileFormat) }
		return .error(code: nil, description: "No file path or URL supplied. Aborting save.")
	}
	
	/** Save the PList file to disk, overwriting without confirmation. To save an already-loaded PList, simply use `save()`. Or, optionally supply a `toFile` file path to save to a different location on disk or as a new file.
	- parameter toFile: A full or relative pathname.
	- parameter format: Data format on disk when saving.
	- parameter atomically: A flag that specifies whether the file should be written atomically.
	
	If flag is true, the dictionary is written to an auxiliary file, and then the auxiliary file is renamed to path. If flag is false, the dictionary is written directly to path. The true option guarantees that path, if it exists at all, won’t be corrupted even if the system should crash during writing.
	- returns: `OTPListSaveResult`
	*/
	@discardableResult
	public mutating func save(toFile: String, format: PropertyListSerialization.PropertyListFormat? = nil) -> OTPListSaveResult {
		let fileFormat = format != nil ? format! : self.format // if passed as nil, use `format` property
		
		var err: NSError?
		guard let out = OutputStream(toFileAtPath: toFile, append: false) else {
			return .error(code: nil, description: "OutputStream could not be created.") }
		out.open()
		let opts = PropertyListSerialization.WriteOptions() // Apple Docs: "Currently unused. Set to 0."
		let result = PropertyListSerialization.writePropertyList(content as Any, to: out, format: fileFormat, options: opts, error: &err)
		out.close()
		if result == 0 { return .error(code: err?.code, description: err?.description ?? "") } // number of bytes written; 0 indicates an error occurred
		
		// update paths & format property after successful file save
		updatePaths(withFilePath: toFile)
		self.format = fileFormat
		
		return err == nil ? .success : .error(code: err?.code, description: err?.description ?? "") // no error if nil
		
		// ... this works, but only writes as XML format ...
		//		if (content as NSDictionary).write(toFile: toFile, atomically: atomically) {
		//			filePath = toFile
		//			return true
		//		} else {
		//			return false
		//		}
	}
	
	/** Save the PList file to disk, overwriting without confirmation. To save an already-loaded PList, simply use `save()`. Or, optionally supply a `toURL` URL to save to a different location.
	- parameter toURL: A full URL.
	- parameter format: Data format on disk when saving.
	- parameter atomically: A flag that specifies whether the file should be written atomically.
	
	If flag is true, the dictionary is written to an auxiliary file, and then the auxiliary file is renamed to path. If flag is false, the dictionary is written directly to path. The true option guarantees that path, if it exists at all, won’t be corrupted even if the system should crash during writing.
	- returns: `OTPListSaveResult`
	*/
	@discardableResult
	public mutating func save(toURL: URL, format: PropertyListSerialization.PropertyListFormat? = nil) -> OTPListSaveResult {
		let fileFormat = format != nil ? format! : self.format // if passed as nil, use `format` property
		
		var err: NSError?
		guard let out = OutputStream(url: toURL, append: false) else {
			return .error(code: nil, description: "OutputStream could not be created.") }
		out.open()
		let opts = PropertyListSerialization.WriteOptions() // Apple Docs: "Currently unused. Set to 0."
		let result = PropertyListSerialization.writePropertyList(content as Any, to: out, format: fileFormat, options: opts, error: &err)
		out.close()
		if result == 0 { return .error(code: err?.code, description: err?.description ?? "") } // number of bytes written; 0 indicates an error occurred
		
		// update paths & format property after successful file save
		updatePaths(withURL: toURL)
		self.format = fileFormat
		
		return err == nil ? .success : .error(code: err?.code, description: err?.description ?? "") // no error if nil
		
		// ... this works, but only writes as XML format ...
		//		if (content as NSDictionary).write(to: toURL, atomically: atomically) {
		//			fileURL = toURL
		//			return true
		//		} else {
		//			return false
		//		}
	}
	
	/// Internal function to update `filePath` and `fileURL` properties.
	private mutating func updatePaths(withFilePath: String) {
		filePath = withFilePath
		fileURL = URL(fileURLWithPath: withFilePath)
	}
	/// Internal function to update `filePath` and `fileURL` properties.
	private mutating func updatePaths(withURL: URL) {
		filePath = withURL.isFileURL ? withURL.path : nil
		fileURL = withURL
	}
	
	
	/// Internal function to recursively translate a raw dictionary imported via NSDictionary to a Swift-friendly typed tree.
	private func parseRawDictionary(sourceDictionary: OTPListRawDictionary) -> OTPListDictionary? {
		// translate to Swift-friendly types
		
		var newDict: OTPListDictionary = [:]
		
		for (keyRaw, value) in sourceDictionary {
			guard let key = keyRaw as? String else { return nil } // key must be translatable to String
			//			if key == "SidebarWidthTenElevenOrLater" {
			//				print("SidebarWidthTenElevenOrLater - type: ", String(describing: type(of: value)), "value:", value)
			//				print("NSNumber doubleValue:", (value as? NSNumber)?.doubleValue as Any)
			//				print("NSNumber intValue:", (value as? NSNumber)?.intValue as Any)
			//				(value as? NSNumber)?.boolValue
			//				(value as? NSNumber)?.decimalValue
			//				(value as? NSNumber)?.doubleValue
			//				(value as? NSNumber)?.floatValue
			//				(value as? NSNumber)?.attributeKeys
			//				(value as? NSNumber)?.className
			//			}
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
				case let val as String: newDict[key] = val
				case let val as Int: newDict[key] = val		// ***** values stored as <real> will import as Int if they have a decimal of .0
				case let val as Double: newDict[key] = val
				case let val as Date: newDict[key] = val
				case let val as Data: newDict[key] = val
				case let val as OTPListRawDictionary:
					guard let translated = parseRawDictionary(sourceDictionary: val) else { return nil }
					newDict[key] = translated
				case let val as OTPListRawArray:
					guard let translated = parseRawArray(sourceArray: val) else { return nil }
					newDict[key] = translated
				default: return nil // this should never happen
				}
			}
			
		}
		
		return newDict
	}
	/// Internal function to recursively translate a raw dictionary imported via NSDictionary to a Swift-friendly typed tree.
	private func parseRawArray(sourceArray: OTPListRawArray) -> OTPListArray? {
		// translate to Swift-friendly types
		
		var newArray: OTPListArray = []
		
		for element in sourceArray {
			// ***** type(of:) is a workaround to test for a boolean type, since testing for NSNumber's boolValue constants is tricky in Swift
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
				case let val as String: newArray.append(val)
				case let val as Int: newArray.append(val)	// ***** values stored as <real> will import as Int if they have a decimal of .0
				case let val as Double: newArray.append(val)
				case let val as Date: newArray.append(val)
				case let val as Data: newArray.append(val)
				case let val as OTPListRawDictionary:
					guard let translated = parseRawDictionary(sourceDictionary: val) else { return nil }
					newArray.append(translated)
				case let val as OTPListRawArray:
					guard let translated = parseRawArray(sourceArray: val) else { return nil }
					newArray.append(translated)
				default: return nil // this should never happen
				}
			}
		}
		
		return newArray
	}
}


// MARK: - OTPListDictionary subscripts
// Essentially, an extension on OTPListDictionary to provide subscript chaining for keys and nested dictionaries

public extension Dictionary where Key == String, Value == OTPListValue {
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
	subscript(float key: String) -> Double? {
		get {
			// try Double first
			if let tryDouble = self[key] as? Double {
				return tryDouble
			}
			// otherwise see if there is an Int that can be read as a Double
			if let tryInt = self[key] as? Int {
				guard let toDouble = Double(exactly: tryInt) else { return nil }
				return toDouble
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
	subscript(any key: String) -> OTPListValue? {
		get {
			return self[key]
		}
		set {
			self[key] = newValue
		}
	}
	
	// Internal type: Array<AnyObject> (ordered)
	subscript(array key: String) -> OTPListArray? {
		get {
			return self[key] as? OTPListArray
		}
		set {
			self[key] = newValue
		}
	}
	
	subscript(arrayCreate key: String) -> OTPListArray? {
		mutating get {
			if self[key] != nil { // key exists, but we're not sure it's a dictionary yet
				return self[array: key] // if it's a dictionary, return it
			}
			
			// key does not exist, so let's create it as a new array and return it
			
			self[key] = OTPListArray()
			
			return self[array: key]
		}
		set {
			self[key] = newValue == nil
		}
	}
	
	// if key exists and it's a dictionary, return it. otherwise return nil.
	// Internal type: Dictionary<NSObject, AnyObject>
	subscript(dict key: String) -> OTPListDictionary? {
		get {
			return self[key] as? OTPListDictionary
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
	subscript(dictCreate key: String) -> OTPListDictionary? {
		mutating get {
			if self[key] != nil { // key exists, but we're not sure it's a dictionary yet
				return self[dict: key] // if it's a dictionary, return it
			}
			
			// key does not exist, so let's create it as a new dictionary and return it
			
			self[key] = OTPListDictionary()
			
			return self[key] as? OTPListDictionary
		}
		set {
			self[key] = newValue
		}
	}
	
	mutating func createDictionary(name: String) {
		self[name] = OTPListDictionary()
	}
}


// MARK: - Extra methods

public extension Dictionary where Key == String, Value == OTPListValue {
	
	// MARK: - Key-Pairs by type
	
	/// Returns all key-pairs containing String values.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getStringKeyPairs: [String : String] {
		guard let vals = self.filter({ $0.value is String }) as? [String : String] else { return [:] }
		return vals
	}
	
	/// Returns all key-pairs containing Int (non-float, non-boolean) values.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getIntKeyPairs: [String : Int] {
		guard let vals = self.filter({ $0.value is Int }) as? [String : Int] else { return [:] }
		return vals
	}
	
	/// Returns all key-pairs containing Double (non-int, non-boolean) values.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getFloatKeyPairs: [String : Double] {
		// ensure value cannot be represented as a non-float (ie: Int or Bool)
		guard let vals = self.filter({ $0.value is Double }) as? [String : Double] else { return [:] }
		return vals
	}
	
	/// Returns all key-pairs containing Bool (non-int) values.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getBoolKeyPairs: [String : Bool] {
		guard let vals = self.filter({ $0.value is Bool }) as? [String : Bool] else { return [:] }
		return vals
	}
	
	/// Returns all key-pairs containing Data values.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getDataKeyPairs: [String : Data] {
		guard let vals = self.filter({ $0.value is Data }) as? [String : Data] else { return [:] }
		return vals
	}
	
	/// Returns all key-pairs containing Date values.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getDateKeyPairs: [String : Date] {
		guard let vals = self.filter({ $0.value is Date }) as? [String : Date] else { return [:] }
		return vals
	}
	
	/// Returns all key-pairs that are Dictionaries.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getDictionaryKeyPairs: [String : OTPListDictionary] {
		guard let vals = self.filter({ $0.value is OTPListDictionary }) as? [String : OTPListDictionary] else { return [:] }
		return vals
	}
	
	/// Returns all key-pairs that are ordered Arrays.
	/// (This returns a copy of the keys, so you cannot set values in the PList via this property.)
	public var getArrayKeyPairs: [String : OTPListArray] {
		guard let vals = self.filter({ $0.value is OTPListArray }) as? [String : OTPListArray] else { return [:] }
		return vals
	}
	
	
	// MARK: - Key Names by type
	
	/// Returns all keys containing String values.
	public var getStringKeys: Dictionary<String, String>.Keys {
		return self.getStringKeyPairs.keys
	}
	
	/// Returns all keys containing Int (non-float, non-boolean) values.
	public var getIntKeys: Dictionary<String, Int>.Keys {
		return self.getIntKeyPairs.keys
	}
	
	/// Returns all keys containing Double (non-int, non-boolean) values.
	public var getFloatKeys: Dictionary<String, Double>.Keys {
		return self.getFloatKeyPairs.keys
	}
	
	/// Returns all keys containing Bool (non-int) values.
	public var getBoolKeys: Dictionary<String, Bool>.Keys {
		return self.getBoolKeyPairs.keys
	}
	
	/// Returns all keys containing Data values.
	public var getDataKeys: Dictionary<String, Data>.Keys {
		return self.getDataKeyPairs.keys
	}
	
	/// Returns all keys containing Date values.
	public var getDateKeys: Dictionary<String, Date>.Keys {
		return self.getDateKeyPairs.keys
	}
	
	/// Returns all keys that are Dictionaries.
	public var getDictionaryKeys: Dictionary<String, OTPListDictionary>.Keys {
		return self.getDictionaryKeyPairs.keys
	}
	
	/// Returns all keys that are ordered Arrays.
	public var getArrayKeys: Dictionary<String, OTPListArray>.Keys {
		return self.getArrayKeyPairs.keys
	}
}
