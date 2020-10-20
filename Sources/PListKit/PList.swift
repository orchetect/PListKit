//
//  PList.swift
//  PListKit
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

// MARK: - PList

/// Class representing a Property List (plist).
///
/// - To initialize an empty plist, use `PList()`
/// - To load a plist file's contents, use the `init(fromFile:)` / `init(fromURL:)` constructors, or the `load(fromFile:)` or /// `load(fromURL:)` methods after initializing.
/// - To save a loaded file, use `save()`.
/// - To save to a new file, use `save(toFile:)`, or `save(toURL:)`.
///
public class PList {
	
	// MARK: - Globals
	
	internal let fileManager = FileManager.default
	
	// MARK: - Instance properties
	
	/// Get-only property that returns the path and filename of the currently loaded PList file.
	internal(set) public var filePath: String? = nil
	
	/// Get-only property that returns the URL of the currently loaded PList file.
	internal(set) public var fileURL: URL? = nil
	
	/** Root dictionary storage backing for the PList file, containing all keys and nested dictionaries.
	
	Valid value types, all conforming to `PListValue` protocol:
	
	- `String`
	- `Int`
	- `Double`
	- `Bool`
	- `Date`
	- `Data`
	- `PListDictionary`, aka `[String : PListValue]`
	- `PListArray`, aka `[PListValue]`
	*/
	public var storage: PListDictionary = [:]
	
	/// Functional nesting tree classes for clean syntax.
	public var root: PListNode.Root {
		// Create and return a new class every time this property is accessed, to avoid storing an instance of it
		PListNode.Root(delegate: self)
	}
	
	/// Data format of PList when saved to disk.
	public var format: PropertyListSerialization.PropertyListFormat
	
	/// When setting a value using `.root`, determines whether any non-existing dictionaries in the path get created.
	public var createIntermediateDictionaries: Bool = true
	
	/// Create an empty PList object, optionally specifying format.
	///
	/// Format defaults to `xml`.
	///
	public
	init(format: PropertyListSerialization.PropertyListFormat = .xml) {
		self.format = format
	}
	
	/// Instantiate a PList object by loading a plist file from disk.
	///
	/// Because this is a failable initializer, the specific error type is not returned if there is an error while attempting to load a file. Instead, the intializer simply fails and a `nil` object is returned.
	///
	/// - parameter fromFile: A full or relative pathname.
	///
	public convenience
	init?(fromFile: String) {
		
		self.init()
		
		guard case .success(_) = load(fromFile: fromFile)
		else { return nil }
		
	}
	
	/// Instantiate a PList object by loading a plist file from a local file URL or network resource URL.
	///
	/// Because this is a failable initializer, the specific error type is not returned if there is an error while attempting to load a file. Instead, the intializer simply fails and a `nil` object is returned.
	///
	/// - parameter fromURL: A full URL.
	///
	public convenience
	init?(fromURL: URL) {
		
		self.init()
		
		guard case .success(_) = load(fromURL: fromURL)
		else { return nil }
		
	}
	
	/// Instantiate a PList object and populate its contents using an existing dictionary.
	///
	/// - parameter fromDictionary: Source dictionary to read from.
	///
	public convenience
	init(fromDictionary: PListDictionary,
		 format: PropertyListSerialization.PropertyListFormat = .xml) {
		
		self.init()
		
		storage = fromDictionary
		
		self.format = format
		
	}
	
	/// Instantiate a PList object and populate its contents by reading the raw data.
	///
	/// - parameter data: Source binary Data to read from.
	///
	public convenience
	init?(data: Data) {
		
		self.init()
		
		guard case .success(_) = load(data: data)
		else { return nil }
		
	}
	
}


// MARK: - NSCopying

extension PList: NSCopying {
	
	public func copy(with zone: NSZone? = nil) -> Any {
		
		// copy the class including data and properties
		// and omit transient information such as `filePath` and `fileURL`
		
		let copy = PList(fromDictionary: storage)
		
		copy.format = format
		copy.createIntermediateDictionaries = createIntermediateDictionaries
		
		return copy
		
	}
	
}
