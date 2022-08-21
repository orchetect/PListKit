//
//  PListDictionary.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if swift(>=5.7)
/// Strongly-typed Dictionary type used by `PList`.
public typealias PListDictionary = [String: any PListValue]
#else
/// Strongly-typed Dictionary type used by `PList`.
public typealias PListDictionary = [String: PListValue]
#endif
