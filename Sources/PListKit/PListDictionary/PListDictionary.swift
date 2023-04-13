//
//  PListDictionary.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if swift(>=5.7)
/// Strongly-typed Dictionary type used by ``PList``.
///
/// When building with Swift 5.7, this type is `[String: any PListValue]`.
///
/// When building with Swift 5.6 or earlier, this type is `[String: PListValue]`.
public typealias PListDictionary = [String: any PListValue]
#else
/// Strongly-typed Dictionary type used by ``PList``.
///
/// When building with Swift 5.7, this type is `[String: any PListValue]`.
///
/// When building with Swift 5.6 or earlier, this type is `[String: PListValue]`.
public typealias PListDictionary = [String: PListValue]
#endif
