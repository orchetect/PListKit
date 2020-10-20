//
//  Utilities.swift
//  PListKit
//
//  Created by Steffan Andrews on 2020-10-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

/// Convenience method to form an NSError.
internal func nsError(_ failureReason: String, recoverySuggestion: String? = nil) -> NSError {
	var userInfo: [String : Any] = [:]
	
	userInfo[NSLocalizedDescriptionKey] =
	NSLocalizedString(failureReason, comment: "")
	
	userInfo[NSLocalizedFailureReasonErrorKey] =
		NSLocalizedString(failureReason, comment: "")
	
	if recoverySuggestion != nil {
		userInfo[NSLocalizedRecoverySuggestionErrorKey] =
			NSLocalizedString(recoverySuggestion!, comment: "")
	}
	
	return NSError(domain: "PListKit", code: -1, userInfo: userInfo)
}
