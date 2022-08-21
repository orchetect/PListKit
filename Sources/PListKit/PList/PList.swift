//
//  PList.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Cases containing a PList instance with strongly-typed root.
public enum PList {
    case dictionaryRoot(DictionaryPList)
    case arrayRoot(ArrayPList)
    case boolRoot(SingleValuePList<Bool>)
    case stringRoot(SingleValuePList<String>)
    case intRoot(SingleValuePList<Int>)
    case doubleRoot(SingleValuePList<Double>)
    case dateRoot(SingleValuePList<Date>)
    case dataRoot(SingleValuePList<Data>)
}
