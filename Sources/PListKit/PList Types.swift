//
//  PList Types.swift
//  PListKit 
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

// MARK: - Types

extension PList {
	
	/// Raw NSDictionary used by PropertyListSerialization
	public typealias RawDictionary = Dictionary<NSObject, AnyObject>
	
	/// Raw NSArray array used by PropertyListSerialization
	public typealias RawArray = Array<AnyObject>
	
}

// PList native types

extension PList {
	
	/// Translated Dictionary type used by PList
	public typealias PListDictionary = Dictionary<String, PListValue>
	
	/// Translated Array type used by PList
	public typealias PListArray = Array<PListValue>
	
}
