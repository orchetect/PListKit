# PListKit

[![CI Build Status](https://github.com/orchetect/PListKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/PListKit/actions/workflows/build.yml) [![Platforms - macOS | iOS | tvOS | watchOS](https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/PListKit/blob/main/LICENSE)

A multiplatform Swift library bringing functional methods and type safety to .plist (Property List) files.

## Summary

The challenges that Apple's standard ` PropertyListSerialization` presents:

1. **Lack of type safety**: it allows the inadvertent injection of incompatible value types, which can lead to unexpected errors when saving a plist file later on, and are difficult to diagnose
2. **Root-level dictionary access only**, making traversal of nested dictionaries very cumbersome
3. **Exposes NS value types** which can be a pain to work with

PListKit solves these issues by:

1. Acting as a **safe and convenient** wrapper for  `PropertyListSerialization`
2. Providing **clean functional syntax** for
   - easily manipulating nested keys and values
   - loading and saving plist files
3. Dealing in **native Swift value types** for keys and values
4. **Preventing the inadvertent use of incompatible value types** to ensure unexpected errors do not arise

## Installation

The library is available as a Swift Package Manager (SPM) package.

To add PListKit to your Xcode project:

1. Select File → Swift Packages → Add Package Dependency
2. Add package using  `https://github.com/orchetect/PListKit` as the URL.

## Documentation

### Construction

```swift
import PListKit

// new empty plist object
let pl = PList()
```

### Loading plist contents

The following initializers are available to load external data into the `PList` object.

- `PList(file:)` - using a file path on disk
- `PList(url:)` - using a local file URL or network resource URL
- `PList(data:)` - using raw plist file data
- `PList(string:)` - using raw plist file string
- `PList(dictionary:)` - using raw dictionary

```swift
let pl = try PList(file: "/Users/user/Desktop/file.plist")
```

### Read/Write Keys

```swift
// can create intermediate dictionaries if nonexistent
pl.createIntermediateDictionaries = true // (note: defaults to true)

// create a new Int key within nested dictionaries
pl.root
  .dict(key: "Dict")
  .dict(key: "Nested Dict")
  .int(key: "Int")
  .value = 123

// read the value back
let val = pl.root
  .dict(key: "Dict")
  .dict(key: "Nested Dict")
  .int(key: "Int")
  .value  // == Optional(123)
```

All valid property list value types map transparently to native Swift value types.

```swift
pl.root.string(key: "String").value = "a new string"

pl.root.int(key: "Int").value = 123

pl.root.double(key: "Double").value = 123.45

pl.root.bool(key: "Bool").value = true

pl.root.date(key: "Date").value = Date()

pl.root.data(key: "Data").value = Data([0x01, 0x02])

pl.root.array(key: "Array").value = [
  "a string",
  123, 
  123.45,
  true, 
  Date(), 
  Data([0x01, 0x02])
]

// dictonaries can be modified directly if necessary,
// perhaps if you need to populate a large data set or copy a nested structure
// but otherwise it's much nicer to use the discretely typed methods above
pl.root.dict(key: "Dictionary").value = 
  ["Key 1" : "a string",
   "Key 2" : 123]
```

### Manipulating Array Elements Directly

Arrays can, of course, be modified in-place using native Swift subscripts.

```bash
pl.root.array(key: "Array").value?[0] = "replaced string value"
pl.root.array(key: "Array").value?.append("new string value")
```

### Reading Arrays

Since property list arrays can contain any valid plist value type simultaneously, when reading arrays you need to conditionally cast values to test their type.

```swift
let arr = pl.root.array(key: "Array").value ?? [] // PListArray, aka [PListValue]

for element in arr {
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

### Deleting Keys

```swift
// delete a key
pl.root.string(key: "String").value = nil

// delete a dictionary or array and all of its contents
pl.root.array(key: "Array").value = nil
pl.root.dict(key: "Dict").value = nil
```

### Subscripts

A full set of chainable subscripts are also available if you choose to use them, mirroring the functional methods. To use them, reference the `storage` property directly instead of `root`.

```swift
pl.storage[any: "Keyname"] // reads key value as PListValue

pl.storage[string: "Keyname"]
pl.storage[int: "Keyname"]
pl.storage[double: "Keyname"]
pl.storage[bool: "Keyname"]
pl.storage[date: "Keyname"]
pl.storage[data: "Keyname"]
pl.storage[array: "Keyname"]
pl.storage[dict: "Keyname"]
```

The subscripts are usable to both get and set.

```swift
pl.storage[string: "Keyname"] = "string value"
let str = pl.storage[string: "Keyname"] ?? "" // "string value"
```

Nested dictionaries can easily be accessed through chaining subscripts.

```swift
// sets nested string key if the intermediate dictionaries already exist
pl.storage[dict: "Dict"]?[dict: "Nested Dict"]?[string: "Keyname"] = "string value"

// alternative subscript creates nested dictionaries if they don't exist
pl.storage[dictCreate: "Dict"]?[dictCreate: "Nested Dict"]?[string: "Keyname"] = "string value"
```

Arrays can be read by index, conditionally casting to a strong type in process:

```swift
// safely attempt to read indexes
// if index does not exist, returns nil
// if index exists but is of wrong type, returns nil
pl.storage[array: "Array"]?[any: 0] // read index 0 as PListValue; you must cast it yourself
pl.storage[array: "Array"]?[string: 0] // read index 0 and cast it as? String
pl.storage[array: "Array"]?[int: 0] // read index 0 and cast it as? Int
pl.storage[array: "Array"]?[double: 0] // read index 0 and cast it as? Double
pl.storage[array: "Array"]?[bool: 0] // read index 0 and cast it as? Bool
pl.storage[array: "Array"]?[date: 0] // read index 0 and cast it as? Date
pl.storage[array: "Array"]?[data: 0] // read index 0 and cast it as? PList.PListArray
pl.storage[array: "Array"]?[dict: 0] // read index 0 and cast it as? PList.PListDictionary
```

### Save File to Disk

```swift
// save to disk in-place, if the file was previously loaded
// from PList(fromURL:) / PList(fromFile:) or .load(fromURL:) / .load(fromFile:)
try? pl.save()

// save to a new file on disk using file URL
guard let url = URL(string: "file:///Users/user/Desktop/file.plist") else { return }
try? pl.save(toURL: url, format: .xml)

// save to a new file on disk using path
try? pl.save(toFile: "/Users/user/Desktop/file.plist", format: .xml)
```

### Copy PList Object

The `PList` class conforms to `NSCopying` if you need to copy the entire plist object in memory.

```swift
let pl = PList(file: "/Users/user/Desktop/file.plist")

let pl2 = pl.copy() as! PList
```

### Additional Methods

More methods are available in addition to what is outlined here in the documentation. Use code completion in the Xcode IDE code editor to discover them.

## Resources

- [Apple Docs: About Property Lists](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html)

## Roadmap

### Future Improvements

- [ ] Add cocapods / carthage support
- [ ] Test result of creating or saving over a protected plist file. Does it fail silently, or trigger an exception? (ie: in macOS root or user preferences folder).
- [ ] Test for memory leaks now that PList is a class, especially with `.root` objects
- [ ] Consider supporting PList files that have a root node other than `Dictionary` (can be any supported PList value type)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/PListKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.

This library was formerly known as OTPList.
