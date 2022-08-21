# PListKit

[![CI Build Status](https://github.com/orchetect/PListKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/PListKit/actions/workflows/build.yml) [![Platforms - macOS | iOS | tvOS | watchOS](https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/PListKit/blob/main/LICENSE)

A multiplatform Swift library bringing functional methods and type safety to .plist (Property List) files.

## Summary

The challenges that Apple's standard ` PropertyListSerialization` presents:

1. **Lack of type safety**: it allows the inadvertent injection of incompatible value types, which can lead to unexpected errors when saving a plist file later on, and are difficult to diagnose
2. **Root-level dictionary access only**, making traversal of nested dictionaries very cumbersome
3. **Deals in NS value types** which is not very Swifty and requires extra boilerplate at every interaction

PListKit solves these issues by:

1. Acting as a **safe and convenient** wrapper for  `PropertyListSerialization`
2. Providing **clean functional syntax** for
   - easily manipulating nested keys and values in dictionary trees
   - loading and saving plist files
3. Dealing in **native Swift value types** for keys and values
4. **Preventing the inadvertent use of incompatible value types** to avoid unexpected errors due to lack of type safety

## Installation

The library is available as a Swift Package Manager (SPM) package.

To add PListKit to your Xcode project:

1. Select File → Swift Packages → Add Package Dependency
2. Add package using  `https://github.com/orchetect/PListKit` as the URL.

## Documentation

### Construction

The most common plist layout uses a dictionary as its root (top-level) element.

```swift
import PListKit

// new empty plist object with dictionary root
let plist = DictionaryPList()
```

However it is possible for the root element to be any valid plist value type (array, string, number, etc.).

```swift
PList<PListDictionary> // typealiased as DictionaryPList
PList<PListArray> // typealiased as ArrayPList
PList<String>
PList<Int>
PList<Double>
PList<Bool>
PList<Date>
PList<Data>
```

The remainder of this documentation will demonstrate the use of `DictionaryPList` since it is the most common.

### Loading plist contents

The following initializers are available to load external data into the `PList` object.

- `init(file:)` - using a file path on disk
- `init(url:)` - using a local file URL or network resource URL
- `init(data:)` - using raw plist data (either XML or binary plist data)
- `init(xml:)` - using raw plist XML string

When you know the root element type ahead of time, you can use the constructors directly on the specialized `PList<>` class of its kind. The vast majority of plist files use a dictionary as the root element.

```swift
// file is known to have a dictionary root element
let plist = try DictionaryPList(file: "/Users/user/Desktop/file.plist")
```

When you do not know the root element type ahead of time and cannot be sure it is a dictionary, use `AnyPList` to load the plist and then unwrap it to get the `PList<>` class specialized to its root element type.

```swift
let anyPL = try AnyPList(file: "/Users/user/Desktop/file.plist")

switch anyPL.plist {
  case .dictionaryRoot(let plist):
    // plist is DictionaryPList
  case .arrayRoot(let plist):
    // plist is ArrayPList
  case .stringRoot(let plist):
    // plist is PList<Strimg> - its root is a single String value
  
  // ... etc. ...
}
```

### Values

Valid plist value types, all conforming to `PListValue` protocol:

```swift
String
Int
Double
Bool
Date
Data
typealias PListDictionary = [String : PListValue]
typealias PListArray = [PListValue]
```

### `DictionaryPList`: Read/Write Keys

```swift
// can create intermediate dictionaries if nonexistent
plist.createIntermediateDictionaries = true // (note: defaults to true)

// create a new Int key within nested dictionaries
plist.root
  .dict(key: "Dict")
  .dict(key: "Nested Dict")
  .int(key: "Int")
  .value = 123

// read the value back
let val = plist.root
  .dict(key: "Dict")
  .dict(key: "Nested Dict")
  .int(key: "Int")
  .value  // == Optional(123)
```

All valid property list value types map transparently to native Swift value types.

```swift
plist.root.any(key: "Any").value = "a new string" // value of any valid PListValue type
plist.root.string(key: "String").value = "a new string"
plist.root.int(key: "Int").value = 123
plist.root.double(key: "Double").value = 123.45
plist.root.bool(key: "Bool").value = true
plist.root.date(key: "Date").value = Date()
plist.root.data(key: "Data").value = Data([0x01, 0x02])
plist.root.array(key: "Array").value = [
  "a string",
  123, 
  123.45,
  true, 
  Date(), 
  Data([0x01, 0x02])
]

// dictonaries can be modified directly if necessary,
// perhaps if you need to populate a large data set or copy a nested structure.
// but otherwise it's much nicer to use the discretely typed methods above
plist.root.dict(key: "Dictionary").value = [
 "Key 1" : "a string",
 "Key 2" : 123
]
```

### `DictionaryPList`: Manipulating Array Elements Directly

Arrays can, of course, be modified in-place using native Swift subscripts.

```bash
plist.root.array(key: "Array").value?[0] = "replaced string value"
plist.root.array(key: "Array").value?.append("new string value")
```

### `DictionaryPList`: Reading Arrays

Since property list arrays can contain any valid plist value type simultaneously, when reading arrays you need to conditionally cast values to test their type.

```swift
let array = plist.root.array(key: "Array").value ?? [] // PListArray, aka [PListValue]

for element in array {
  switch element {
    case let val as String:           print("String: \(val)")
    case let val as Int:              print("Int: \(val)")
    case let val as Double:           print("Double: \(val)")
    case let val as Bool:             print("Bool: \(val)")
    case let val as Date:             print("Date: \(val)")
    case let val as Data:             print("Data with \(val.count) bytes")
    case let val as PListArray:       print("Array with \(val.count) elements")
    case let val as PListDictionary:  print("Dictionary with \(val.count) elements")
    default: break
  }
}
```

### `DictionaryPList`: Deleting Keys

```swift
// delete a key
plist.root.string(key: "String").value = nil

// delete a dictionary or array and all of its contents
plist.root.array(key: "Array").value = nil
plist.root.dict(key: "Dict").value = nil
```

### `DictionaryPList`: Subscripts

A full set of chainable subscripts are also available if you choose to use them, mirroring the functional methods. To use them, reference the `storage` property directly instead of `root`.

```swift
plist.storage[any: "Keyname"] // reads key value as any PListValue

plist.storage[string: "Keyname"]
plist.storage[int: "Keyname"]
plist.storage[double: "Keyname"]
plist.storage[bool: "Keyname"]
plist.storage[date: "Keyname"]
plist.storage[data: "Keyname"]
plist.storage[array: "Keyname"]
plist.storage[dict: "Keyname"]
```

The subscripts are usable to both get and set.

```swift
plist.storage[string: "Keyname"] = "string value"
let str = plist.storage[string: "Keyname"] ?? "" // "string value"
```

Nested dictionaries can easily be accessed through chaining subscripts.

```swift
// sets nested string key if the intermediate dictionaries already exist
plist.storage[dict: "Dict"]?[dict: "Nested Dict"]?[string: "Keyname"] = "string value"

// alternative subscript creates nested dictionaries if they don't exist
plist.storage[dictCreate: "Dict"]?[dictCreate: "Nested Dict"]?[string: "Keyname"] = "string value"

// subscript bodies may be on new lines in the event of very long subscript chains
plist.storage[
  dictCreate: "Dict"
]?[
  dictCreate: "Nested Dict"
]?[
  string: "Keyname"
] = "string value"
```

Arrays can be read by index, conditionally casting to a strong type in process:

```swift
// safely attempt to read indexes
// if index does not exist, returns nil
// if index exists but is of wrong type, returns nil
plist.storage[array: "Array"]?[any: 0] // read index 0 as PListValue; must cast it yourself
plist.storage[array: "Array"]?[string: 0] // read index 0 and cast it as? String
plist.storage[array: "Array"]?[int: 0] // read index 0 and cast it as? Int
plist.storage[array: "Array"]?[double: 0] // read index 0 and cast it as? Double
plist.storage[array: "Array"]?[bool: 0] // read index 0 and cast it as? Bool
plist.storage[array: "Array"]?[date: 0] // read index 0 and cast it as? Date
plist.storage[array: "Array"]?[data: 0] // read index 0 and cast it as? PList.PListArray
plist.storage[array: "Array"]?[dict: 0] // read index 0 and cast it as? PList.PListDictionary
```

### Save File to Disk

```swift
// save to file on disk using file URL
guard let url = URL(string: "file:///Users/user/Desktop/file.plist") else { return }
try plist.save(toFileAtURL: url)

// save to file on disk using absolute file path
try plist.save(toFileAtPath: "/Users/user/Desktop/file.plist")
```

### Copy PList Object

The plist classes conform to `NSCopying` if you need to copy the entire plist object.

```swift
let plist = DictionaryPList(file: "/Users/user/Desktop/file.plist")

let plist2 = plist.copy() as? DictionaryPList
```

### Additional Methods

More methods are available in addition to what is outlined here in the documentation. Use code completion in the Xcode IDE code editor to discover them.

## Resources

- [Apple Docs: About Property Lists](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/PListKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.

This library was formerly known as OTPList.
