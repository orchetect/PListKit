//
//  PList Result.swift
//  PListKit
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

extension PList {
	
	/// Result descriptor that is returned while or after loading a `PList` file.
	public enum LoadError: Error {
		
		case fileNotFound
		case formatNotExpected
		case unexpectedKeyTypeEncountered
		case unexpectedKeyValueEncountered
		case unhandledType
		
	}
	
}
