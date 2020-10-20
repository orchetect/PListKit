//
//  PList load.swift
//  PListKit 
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

extension PList {
	
	/// Load a plist file's contents from disk.
	///
	/// If successful, the current data is replaced with the newly loaded plist's contents.
	/// If unsuccessful, returns an error case of `LoadResult`.
	///
	/// - parameter fromFile: An absolute or relative path.
	/// - returns: `.success(NSNull())` or `LoadError` error type
	///
	@discardableResult
	public func load(fromFile: String) -> Result<NSNull, LoadError> {
		
		guard fileManager.fileExists(atPath: fromFile)
		else { return .failure(.fileNotFound) }
		
		// load as raw NS objects
		guard let getDict = NSMutableDictionary(contentsOfFile: fromFile) as RawDictionary?
		else { return .failure(.formatNotExpected) }
		
		// translate to friendly Swift types
		guard let translatedDict = Self.ConvertToPListDictionary(getDict)
		else { return .failure(.formatNotExpected) }
		
		storage = translatedDict
		updatePaths(withFilePath: fromFile)
		
		return .success(NSNull())
		
	}
	
	/// Load a plist file's contents from a file URL or network resource URL.
	///
	/// If successful, the current data is replaced with the newly loaded plist's contents.
	/// If unsuccessful, returns an error case of `LoadResult`.
	///
	/// - parameter fromURL: A full URL.
	/// - returns: `.success(NSNull())` or `LoadError` error type
	///
	@discardableResult
	public func load(fromURL: URL) -> Result<NSNull, LoadError> {
		
		if fromURL.isFileURL {
			guard fileManager.fileExists(atPath: fromURL.path)
			else { return .failure(.fileNotFound) }
		}
		
		// load as raw NS objects
		guard let getDict = NSMutableDictionary(contentsOf: fromURL) as RawDictionary?
		else { return .failure(.formatNotExpected) }
		
		// translate to friendly Swift types
		guard let translatedDict = Self.ConvertToPListDictionary(getDict)
		else { return .failure(.formatNotExpected) }
		
		storage = translatedDict
		updatePaths(withURL: fromURL)
		
		return .success(NSNull())
		
	}
	
	/// Load a plist file's contents from raw data.
	///
	/// If successful, the current data is replaced with the newly loaded plist's contents.
	/// If unsuccessful, returns an error case of `LoadError`.
	///
	/// - parameter data: Raw binary content of a PList file to load
	/// - returns: `.success(NSNull())` or `LoadError` error type
	///
	@discardableResult
	public func load(data: Data) -> Result<NSNull, LoadError> {
		
		// load as raw NS objects
		var getFormat: PropertyListSerialization.PropertyListFormat = .xml // just a default, will be replaced...
		var getDict: RawDictionary?
		do {
			// if this succeeds, it will update getFormat with the file's actual format
			getDict = (try PropertyListSerialization
				.propertyList(from: data,
							  options: .init(rawValue: 0),
							  format: &getFormat)) as? RawDictionary
		} catch {
			return .failure(.formatNotExpected)
		}
		
		guard getDict != nil
		else { return .failure(.formatNotExpected) }
		
		// translate to friendly Swift types
		guard let translatedDict = Self.ConvertToPListDictionary(getDict!)
		else { return .failure(.formatNotExpected) }
		
		storage = translatedDict
		format = getFormat
		
		return .success(NSNull())
		
	}
	
}
