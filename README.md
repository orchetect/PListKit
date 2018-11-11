# OTPList
<p>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift4-compatible-orange.svg?style=flat" alt="Swift 4 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/Bitter/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

Read, modify, and write PList files with ease using native Swift types and convenient syntax. Supports nested dictionaries and arrays, as well as binary PList file formats.

## Summary

OTPList is a struct, so don't pass it around as an object. Instead, instance it in a variable and access that variable.

All key-value types are strongly typed with native Swift types, so it is safe and easy to use.



- Create an empty PList object, or initialize it from a file on disk or a `.plist` file directly from a web URL.

```swift
var pl = PList()

var pl = PList(fromFile: "/Users/user/Desktop/file.plist")

guard let url = URL(string: "http://www.domain.com/file.plist") else { return }
var pl = OTPList(fromURL: url)
```

- Read values, including accessing nested dictionaries using safe Optional chaining.

```swift
pl?.content[string: "KeyName"] = "A string value"
let getString = pl?.content[string: "KeyName"]      // Optional("A string value")

// these 7 value types are acceptable
// since these getters can all fail if the key doesn't exist, they all return optionals
pl?.content[string: "TestString"]	// String?
pl?.content[int: "TestInt"]		// Int?
pl?.content[float: "TestFloat"]		// Double?
pl?.content[bool: "TestBool"]		// Bool?
pl?.content[date: "TestDate"]		// Date?
pl?.content[data: "TestData"]		// Data?
pl?.content[array: "TestArray"]		// OTPListArray?, aka: Array<OTPListValue>
pl?.content[dict: "TestDict"]		// OTPListDictionary?, aka: Dictionary<String, OTPListValue>

// also, you can access a value without knowing its type beforehand:
pl?.content[any: "TestString"]			// Any?
pl?.content[any: "TestString"] as? String	// String
pl?.content[any: "TestString"] as? Int		// nil

// accessing array contents:
pl?.content[array: "TestArray"]?[0]
pl?.content[array: "TestArray"]?[1]

// acessing dictionary contents:
pl?.content[dict: "TestDict"]?[string: "DictString"]
pl?.content[dict: "TestDict"]?[int: "DictInt"]

// accessing nested dictionary values
pl?.content[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "NestedString"]
```

- Modify values using the same syntax.

```swift
// add or modify key values
pl?.content[string: "TestString"] = "New value"
pl?.content[int: "TestInt"] = 234
pl?.content[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "NestedString"] = "New value"

// delete a key
pl?.content[string: "ThisWillBeDeleted"] = nil

// add a key and create all nested dictionaries at the same time, if they don't exist
pl?.content[dictCreate: "DoesNotExist1"]?[dictCreate: "DoesNotExist2"]?[string: "NestedString"] = "A string value"
```

- Save the `.plist` file back to disk in XML or Binary format.

```swift
pl?.format = .xml

// Method 1:
// save back to disk if the file was previously loaded from disk
pl?.save()

// Method 2:
// save to a new/different file on disk using local file path
pl?.save(toFile: "/Users/user/Desktop/file.plist")

// Method 3:
// save to 
a new/different file on disk using local URL path
if let url = URL(string: "file:///Users/user/Desktop/file.plist") {
    pl?.save(toURL: url)
}
```

## Installation

Grab the `OTPList.swift` file from within the playground file and use it in your project.

## Documentation

There are more methods and use cases - for an exhaustive walk-through, open the `OTPList.playground` file.