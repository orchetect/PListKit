# ``PListKit``

A multiplatform Swift library bringing functional methods and type safety to .plist (Property List) files.

## Overview

The challenges that Apple's standard `PropertyListSerialization` presents:

1. **Lack of type safety** which allows the inadvertent injection of incompatible value types, which can lead to unexpected errors when saving a plist file later on, and are difficult to diagnose
2. **Root-level dictionary access only**, making traversal of nested dictionaries very cumbersome
3. **Deals in NS value types** which is not very Swifty and requires extra boilerplate at every interaction

PListKit solves these issues by:

1. Acting as a **safe and convenient** wrapper for  `PropertyListSerialization`
2. Providing **clean functional syntax** for
   - easily manipulating nested keys and values in dictionary trees
   - loading and saving plist files
3. Dealing in **native Swift value types** for keys and values
4. **Preventing the inadvertent use of incompatible value types** to avoid unexpected errors due to lack of type safety

## Topics

### Guides

- <doc:Property-List-Value-Types>
- <doc:Create-a-new-plist>
- <doc:Load-a-plist-file-from-disk>
- <doc:Working-with-DictionaryPList>
- <doc:Working-with-Non-Dictionary-plists>
- <doc:Property-List-Formats>

### Internals

- <doc:Internals>
