//
//  PListArray.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if swift(>=5.7)
/// Strongly-typed Array type used by ``PList``.
///
/// When building with Swift 5.7, this type is `[any PListValue]`.
///
/// When building with Swift 5.6 or earlier, this type is `[PListValue]`.
public typealias PListArray = [any PListValue]
#else
/// Strongly-typed Array type used by ``PList``.
///
/// When building with Swift 5.7, this type is `[any PListValue]`.
/// 
/// When building with Swift 5.6 or earlier, this type is `[PListValue]`.
public typealias PListArray = [PListValue]
#endif
