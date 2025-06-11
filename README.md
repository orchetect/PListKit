# PListKit

[![CI Build Status](https://github.com/orchetect/PListKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/PListKit/actions/workflows/build.yml) [![Platforms - macOS 10.10+ | iOS 9+ | tvOS 9+ | watchOS 2+ | visionOS 1+](https://img.shields.io/badge/platforms-macOS%2010.10+%20|%20iOS%209+%20|%20tvOS%209+%20|%20watchOS%202+%20|%20visionOS%201+-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.3-6](https://img.shields.io/badge/Swift-5.5–6-orange.svg?style=flat) [![Xcode 13-16](https://img.shields.io/badge/Xcode-13–16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/PListKit/blob/main/LICENSE)

A multiplatform Swift library bringing functional methods and type safety to .plist (Property List) files.

## Summary

The challenges that Apple's standard `PropertyListSerialization` presents:

1. **Lack of type safety** which allows the inadvertent injection of incompatible value types, which can lead to unexpected errors when saving a plist file later on, and are difficult to diagnose
2. **Root-level dictionary access only**, making traversal of nested dictionaries very cumbersome
3. **Deals in NS value types** which is not very Swifty and requires extra boilerplate at every interaction

PListKit solves these issues by:

1. Acting as a **safe and convenient** wrapper for `PropertyListSerialization`
2. Providing **clean functional syntax** for
   - easily manipulating nested keys and values in dictionary trees
   - loading and saving plist files
3. Dealing in **native Swift value types** for keys and values
4. **Preventing the inadvertent use of incompatible value types** to avoid unexpected errors due to lack of type safety

## Installation

The library is available as a Swift Package Manager (SPM) package.

To add PListKit to your Xcode project:

1. Select **File → Swift Packages → Add Package Dependency**
2. Add package using  `https://github.com/orchetect/PListKit` as the URL.

## Documentation

See the [online documentation](https://orchetect.github.io/PListKit/) or view it in Xcode's documentation browser by selecting the **Product → Build Documentation** menu.

## Resources

- [Apple Docs: About Property Lists](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/PListKit/blob/master/LICENSE) for details.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/PListKit/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/PListKit/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/PListKit/discussions) first prior to new submitting PRs for features or modifications is encouraged.
