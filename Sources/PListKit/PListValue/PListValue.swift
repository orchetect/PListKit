//
//  PListValue.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol representing all native Swift value types that property lists support, to facilitate type safety and help prevent PList file save failure due to inadvertent use of incompatible value types.
public protocol PListValue { }

// MARK: - Concrete Type Conformances

extension String: PListValue { }

extension Int: PListValue { }

extension Double: PListValue { }

extension Bool: PListValue { }

extension Date: PListValue { }

extension Data: PListValue { }

#if swift(>=5.7)
extension Dictionary: PListValue where Key == String, Value == any PListValue { }
#else
extension Dictionary: PListValue where Key == String, Value == PListValue { }
#endif

#if swift(>=5.7)
extension Array: PListValue where Element == any PListValue { }
#else
extension Array: PListValue where Element == PListValue { }
#endif
