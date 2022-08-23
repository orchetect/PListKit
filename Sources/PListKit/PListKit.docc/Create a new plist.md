# Create a New plist

How to create a new empty plist object.

## Overview

The most common plist layout uses a dictionary as its root (top-level) element.

```swift
// new empty plist object with dictionary root
let plist = DictionaryPList()
```

However it is possible for the root element to be any valid plist value type (array, string, number, etc.).

```swift
PList<PListDictionary> // typealias: as DictionaryPList
PList<PListArray> // typealias: ArrayPList
PList<String>
PList<Int>
PList<Double>
PList<Bool>
PList<Date>
PList<Data>
```

## Topics

### Classes and Type Aliases

- ``PList``
- ``DictionaryPList``
- ``ArrayPList``
