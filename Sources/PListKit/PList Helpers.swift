//
//  PList Helpers.swift
//  PListKit 
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

extension PList {
	
	/// Internal function to update `filePath` and `fileURL` properties.
	internal func updatePaths(withFilePath: String) {
		
		filePath = withFilePath
		fileURL = URL(fileURLWithPath: withFilePath)
		
	}
	
	/// Internal function to update `filePath` and `fileURL` properties.
	internal func updatePaths(withURL: URL) {
		
		filePath = withURL.isFileURL ? withURL.path : nil
		fileURL = withURL
		
	}
	
}
