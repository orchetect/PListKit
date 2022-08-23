# Working with Non-Dictionary plists

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Creating a plist with a non-dictionary root

Property list files may use any valid plist value type as its root. (See <doc:Property-List-Value-Types>).

The ``PList`` class can be specialized to use a root of any ``PListValue`` type.

For example, an array would use ``PListArray``:

```swift
let pl = ArrayPList() // typealias of PList<PListArray>
```

or a single value such as `String` or `Int` is possible:

```swift
let pl = PList<String>()
let pl = PList<Int>()
// etc.
```

## Loading a plist with a non-dictionary root

There are two ways to load a plist with a non-dictionary root.

- When the root type is known ahead of time:
  
  The specialized ``PList`` can be initialized directly. If the plist file is not rooted with the given type, it will fail.

  ```swift
  let pl = ArrayPList(file: "/Users/user/Desktop/file.plist")
  let pl = PList<String>(file: "/Users/user/Desktop/file.plist")
  // etc.
  ```

- When the root type is unknown ahead of time:

  The type-erased ``AnyPList`` can be used to load a plist. You are then able to determine what the root type is by unwrapping its ``AnyPList/plist`` property.

  ```swift
  let pl = AnyPList(file: "/Users/user/Desktop/file.plist")
  
  switch pl.plist {
  case .dictionaryRoot(let dictPList):
      // dictPList == DictionaryPList instance
  case .arrayRoot(let arrayPList):
      // arrayPList == ArrayPList instance
  case .stringRoot(let stringPList):
      // stringPList == PList<String> instance

  // ... additional cases for other possible root value types ...
  }

## Topics

### Root Type Erasure

- ``AnyPList``
- ``WrappedPList``
