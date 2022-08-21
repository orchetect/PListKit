//
//  PListArray.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if swift(>=5.7)
/// Strongly-typed Array type used by `PList`.
public typealias PListArray = [any PListValue]
#else
/// Strongly-typed Array type used by `PList`.
public typealias PListArray = [PListValue]
#endif
