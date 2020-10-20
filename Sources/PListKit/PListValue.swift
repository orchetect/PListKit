//
//  PListValue.swift
//  PListKit 
//
//  Created by Steffan Andrews on 2020-06-19.
//  Copyright © 2020 Steffan Andrews. MIT License.
//

import Foundation

/// Protocol representing all native Swift value types that property lists support, to facilitate type safety and help prevent PList file save failure due to inadvertent use of incompatible value types.
public protocol PListValue { }

// Add this protocol conformance to all supported PLIst value types

extension String    	: PListValue { }
extension Int       	: PListValue { }
extension Double    	: PListValue { }
extension Bool      	: PListValue { }
extension Date      	: PListValue { }
extension Data      	: PListValue { }
extension Dictionary	: PListValue where Key == String, Value == PListValue { }
extension Array     	: PListValue where Element == PListValue { }
