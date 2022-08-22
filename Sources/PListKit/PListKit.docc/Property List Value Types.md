# Property List Value Types

Valid property list value types.

## Overview

[Property lists](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html) have a specific set of allowable value types when dealing directly with `PropertyListSerialization`:

| Abstract Type | XML element | Cocoa class | Core Foundation type |
| --- | --- | --- | --- |
| array | `<array>` | `NSArray` | `CFArray` |
| dictionary | `<dict>` | `NSDictionary` | `CFDictionary` |
| string | `<string>` | `NSString` | `CFString` |
| data | `<data>` | `NSData` | `CFData` |
| date | `<date>` | `NSDate` | `CFDate` |
| integer | `<integer>` | `NSNumber` (`intValue`) | `CFNumber`, integer |
| float | `<real>` | `NSNumber` (`floatValue`) | `CFNumber`, floating-point |
| boolean | `<true/>` or `<false/>` | `NSNumber` `boolValue` | `CFBoolean` |

In PListKit, the ``PList`` class uses Swift-native value types instead and seamlessly translates them to/from the `PropertyListSerialization` types for you when loading or saving the plist to disk.

These all conform to the ``PListValue`` protocol which allows any of them to be nested within dictionaries or arrays while ensuring type safety by preventing invalid types:

| Abstract Type | PListKit Swift Type | Typealias |
| --- | --- | --- |
| array | `[` ``PListValue`` `]` | ``PListArray`` |
| dictionary | `[` `String:` ``PListValue`` `]` | ``PListDictionary`` |
| string | `String` | - |
| data | `Data` | - |
| date | `Date` | - |
| integer | `Int` | - |
| float | `Double` | - |
| boolean | `Bool` | - |

## Topics

### Value Type Protocol

- ``PListValue``

### Type Aliases

- ``PListDictionary``
- ``PListArray``
