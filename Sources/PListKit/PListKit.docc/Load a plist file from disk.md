# Load a plist File From Disk

Methods to load a .plist file from disk or from raw .plist file data.

## Overview

The following initializers are available to load external data into the ``PList`` object.

- ``PList/init(file:)`` - using a file path on disk
- ``PList/init(url:)`` - using a local file URL or network resource URL
- ``PList/init(data:)`` - using raw plist data (either XML or binary plist data)
- ``PList/init(xml:)`` - using raw plist XML string

When you know the root element type ahead of time, you can use the constructors directly on the specialized `PList<>` class of its kind. The vast majority of plist files use a dictionary as the root element.

```swift
// when the file is known to have a dictionary root element
let plist = try DictionaryPList(file: "/Users/user/Desktop/file.plist")
```

When you do not know the root element type ahead of time and cannot be sure it is a dictionary, use ``AnyPList`` to load the plist and then unwrap it to get the ``PList`` class specialized to its root element type.

```swift
let anyPL = try AnyPList(file: "/Users/user/Desktop/file.plist")

switch anyPL.plist {
case .dictionaryRoot(let plist):
    // plist is DictionaryPList
case .arrayRoot(let plist):
    // plist is ArrayPList
case .stringRoot(let plist):
    // plist is PList<String> - its root is a single String value
    
    // ... etc. ...
}
```

## Topics

### Load File

- ``PList/init(file:)``
- ``PList/init(url:)``

### Load Raw File Data

- ``PList/init(data:)``
- ``PList/init(xml:)``

### Initialize With Value

- ``PList/init(root:format:)``

### Load Error

- ``PListLoadError``
