# Working with DictionaryPList

An overview of working with Dictionary-rooted plists.

Dictionary-rooted plists are the most common structure for plist files. This guide will give an overview of methods offered specifically on ``DictionaryPList`` which give useful functional API to read and write from nested dictionaries.

## Read/Write Keys

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

// dictionaries can be modified directly if necessary,
// perhaps if you need to populate a large data set or copy a nested structure.
// but otherwise it's much nicer to use the discretely typed methods above
plist.root.dict(key: "Dictionary").value = [
    "Key 1" : "a string",
    "Key 2" : 123
]
```

## Manipulating Array Elements Directly

Arrays can, of course, be modified in-place using native Swift subscripts.

```swift
plist.root.array(key: "Array").value?[0] = "replaced string value"
plist.root.array(key: "Array").value?.append("new string value")
```

## Reading Arrays

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

## Deleting Keys

```swift
// delete a key
plist.root.string(key: "String").value = nil

// delete a dictionary or array and all of its contents
plist.root.array(key: "Array").value = nil
plist.root.dict(key: "Dict").value = nil
```

## Subscripts

A full set of chainable subscripts are also available if you choose to use them, mirroring the functional methods. To use them, reference the ``PListProtocol/storage`` property directly instead of `root`.

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
plist.storage[array: "Array"]?[any: 0]    // read index 0 as PListValue; must cast it yourself
plist.storage[array: "Array"]?[string: 0] // read index 0 as? String
plist.storage[array: "Array"]?[int: 0]    // read index 0 as? Int
plist.storage[array: "Array"]?[double: 0] // read index 0 as? Double
plist.storage[array: "Array"]?[bool: 0]   // read index 0 as? Bool
plist.storage[array: "Array"]?[date: 0]   // read index 0 as? Date
plist.storage[array: "Array"]?[data: 0]   // read index 0 as? PList.PListArray
plist.storage[array: "Array"]?[dict: 0]   // read index 0 as? PList.PListDictionary
```

## Topics

### Type Alias

- ``DictionaryPList``
