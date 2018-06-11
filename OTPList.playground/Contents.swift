import Foundation
/*:

# OTPList

OTPList is a struct, so don't pass it around as an object. Instead, instance it in a variable and access that variable.

All key-value types are strongly typed with native Swift types, so it is safe and easy to use.

(option+Click "OTPList" here to see detailed help documentation)
*/
OTPList()
/*:
## Instancing and reading .plist files
*/
/*:
### Method #1
*/
// a new empty PList can be created in memory. you can then save it to a file on disk later

var plNew = OTPList()	// since it's a struct, it must be var to be mutable
plNew.content[string: "A key name"] = "A new string value"	// set a new value
plNew.content[string: "A key name"]							// get the value we just set
/*:
### Method #2
*/
// can also be initiated by loading a local file URL's contents
// no link to the file is maintained by OTPList, it simply loads the contents of the file;
// changes can be made to the contents in memory, then the file can be saved back to disk later

if let url = URL(string: "file:///Applications/Safari.app/Contents/Info.plist") {
	let pl = OTPList(fromURL: url)
	
	pl?.content.count
	pl?.content[string: "CFBundleIdentifier"]	// "com.apple.Safari"
}
/*:
### Method #3
*/
// you can load the contents of a plist file from a web server directly, as well

if let url = URL(string: "https://raw.githubusercontent.com/apple/swift/master/tools/SourceKit/tools/sourcekitd/bin/XPC/Client/Info.plist") {
	let pl = OTPList(fromURL: url)
	
	pl?.content.count
	pl?.content[string: "CFBundleIdentifier"]	// "sourcekitd"
}
/*:
### Dealing with load(...) return result
*/
// additionally, you can load any arbitrary .plist file into an existing OTPList

var plist = OTPList()	// new empty PList

// load file contents, discarding the result (fails silently)
plist.load(fromFile: "/Applications/Safari.app/Contents/Info.plist")

// or, you can deal with the result, which is returned as an enum of type OTPListLoadResult
switch plist.load(fromFile: "/Applications/Safari.app/Contents/Info.plist") {
case .success:
	print("Safari info.plist load success")
case .fileNotFound:
	print("Safari info.plist load failed: file not found")
case .formatNotExpected:
	print("Safari info.plist load failed: file format not as expected")
case .unexpectedKeyTypeEncountered:
	print("Safari info.plist load failed: unexpected key type encountered")
case .unexpectedKeyValueEncountered:
	print("Safari info.plist load failed: unexpected value type encountered")
case .unhandledType:
	print("Safari info.plist load failed: unknown error")
}
/*:
### Playground use: load test.plist
*/
// now let's load test.plist from Playground's Resources folder

guard let testPlistPath = Bundle.main.path(forResource: "test", ofType: "plist") else { fatalError() }
var pl = OTPList(fromFile: testPlistPath)

// these read-only properties get populated once a file is loaded
// if loading from a web URL, filePath will be nil (obviously)
pl?.filePath
pl?.fileURL
/*:
## Reading values
*/
// the main dictionary and all its contents is accessed through this property:
pl?.content

// these 7 value types are accepable
// since these getters can all fail if the key doesn't exist, they all return optionals
pl?.content[string: "TestString"]	// String?
pl?.content[int: "TestInt"]			// Int?
pl?.content[float: "TestFloat"]		// Double?
pl?.content[bool: "TestBool"]		// Bool?
pl?.content[date: "TestDate"]		// Date?
pl?.content[data: "TestData"]		// Data?
pl?.content[array: "TestArray"]		// OTPListArray?, aka: Array<OTPListValue>
pl?.content[dict: "TestDict"]		// OTPListDictionary?, aka: Dictionary<String, OTPListValue>

// also, you can access a value without knowing its type beforehand:
pl?.content[any: "TestString"]				// Any?
pl?.content[any: "TestString"] as? String	// String
pl?.content[any: "TestString"] as? Int		// nil

// if using [any:], one wany to determine the value's type is to use a switch case, which also lets your access the value simultaneously as its actual type
switch pl?.content[any: "TestString"] {
case let val as String:				print("TestString is of type String: \"\(val)\"")
case let val as Int:				print("TestString is of type Int: \(val)")
case let val as Double:				print("TestString is of type Double: \(val)")
case let val as Bool:				print("TestString is of type Bool: \(val)")
case let val as Date:				print("TestString is of type Date: \(val)")
case let val as Data:				print("TestString is of type Data: \(val.count) bytes")
case let val as OTPListArray:		print("TestString is of type Array: \(val.count) children")
case let val as OTPListDictionary:	print("TestString is of type Dict: \(val.count) children")
default: print("TestString is of unexpected type.") // technically, this should never happen
}

// accessing array contents:
pl?.content[array: "TestArray"]?[0]
pl?.content[array: "TestArray"]?[1]

// acessing dictionary contents:
pl?.content[dict: "TestDict"]?[string: "DictString"]
pl?.content[dict: "TestDict"]?[int: "DictInt"]

// accessing nested dictionary values
pl?.content[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "NestedString"]

/*:
## Writing values
*/

// all levels, root or nested dictionaries, work the same to set or get values

pl?.content[string: "TestString"] = "New value"
pl?.content[int: "TestInt"] = 234
pl?.content[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "NestedString"] = "New value"


// to create a new nested dictionary or array, you can assign them like any other value

pl?.content[dict: "NewDict"] = [:]		// creates empty dictionary called NewDict at the root level
pl?.content[array: "NewArray"] = []		// creates empty dictionary called NewArray at the root level
pl?.content[array: "NewArray"]?.append("New string inside the array")
pl?.content[array: "NewArray"]?.append(135)
pl?.content[array: "NewArray"]?.count		// contains the two values we just added

/*:
## Nested dictionaries
*/

// you can attempt to access a value deep inside a nested dictionary path, and if that path does not exist, you will get a nil

pl?.content[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "NestedString"] // succeeds
pl?.content[dict: "TestNestedDict1"]?[dict: "TestNestedDict2"]?[string: "DoesNotExist"] // nil - key doesn't exist


// by default, if you attempt to set a value deep inside a nested dictionary path, and that path does not exist, the key creation will fail
// (none of these dictionaries exist in the test.plist file data that is loaded)

pl?.content[dict: "DoesNotExist1"]?[dict: "DoesNotExist2"]?[string: "NestedString"] = "This will fail"
pl?.content[dict: "DoesNotExist1"]?[dict: "DoesNotExist2"]?[string: "NestedString"]	// nil


// however, if you use the [dictCreate:] subscript, the entire nested dictionary path will be auto-created for you if it does not exist, and the new key value will be set
// in this example, a dictionary with the name 'DoesNotExist1' gets created at the root level, then a dictionary within it called 'DoesNotExist2' gets created, then the String value for a new key called 'NestedString' within it gets created

pl?.content[dictCreate: "DoesNotExist1"]?[dictCreate: "DoesNotExist2"]?[string: "NestedString"] = "This will now succeed"
pl?.content[dict: "DoesNotExist1"]?[dict: "DoesNotExist2"]?[string: "NestedString"]			 // "This will now succeed"


// entire dictionaries and their nested contents can be copied

let getDict1 = pl?.content[dict: "TestNestedDict1"]
pl?.content[dict: "DuplicatedDict"] = getDict1
pl?.content[dict: "DuplicatedDict"]?[dict: "TestNestedDict2"]?[string: "NestedString"]	// "New value"

/*:
## Deleting keys
*/

// Deleting keys (values, dictionaries, or arrays) is simple - just set their value to nil

pl?.content[string: "ThisWillBeDeleted"] = "string"
pl?.content[string: "ThisWillBeDeleted"]	// "string"
pl?.content[string: "ThisWillBeDeleted"] = nil
pl?.content[string: "ThisWillBeDeleted"]	// nil

pl?.content[dict: "ThisDictWillBeDeleted"] = ["NewInt" : 500]	// add new dictionary with an int inside
pl?.content[dict: "ThisDictWillBeDeleted"]						// ["NewInt" : 500]
pl?.content[dict: "ThisDictWillBeDeleted"]?[int: "NewInt"]		// 500
pl?.content[dict: "ThisDictWillBeDeleted"] = nil				// delete the dictionary
pl?.content[dict: "ThisDictWillBeDeleted"]						// nil
pl?.content[dict: "ThisDictWillBeDeleted"]?[int: "NewInt"]		// nil

/*:
## Convenience methods / properties

Access these variables to return a filtered set of keys or key-pairs, based on their type.

Note that these return copies (value-type), so you cannot use these to set values in the PList; values must still be set via the main `content` property.

```
pl?.content.getStringKeys
pl?.content.getStringKeyPairs

pl?.content.getIntKeys
pl?.content.getIntKeyPairs

pl?.content.getFloatKeys
pl?.content.getFloatKeyPairs

pl?.content.getBoolKeys
pl?.content.getBoolKeyPairs

pl?.content.getDateKeys
pl?.content.getDateKeyPairs

pl?.content.getDataKeys
pl?.content.getDataKeyPairs

pl?.content.getDictionaryKeys
pl?.content.getDictionaryKeyPairs

pl?.content.getArrayKeys
pl?.content.getArrayKeyPairs
```
*/
/*:
## Saving dictionary contents to .plist file on disk
*/
// set the encoding format of the plist file

pl?.format = .xml		// .xml by default
//pl?.format = .binary	// or, can be set to .binary so the file is saved as a binary-format PList (more compact but not editable in a standalone text-editor)
/*:
### Method #1
*/
// save the loaded file back to disk, if it was first loaded using load(...)
// WARNING: if you call this in the playground, it will overwrite the playground's test.plist file with all new values we set above

//pl?.save()
/*:
### Method #2
*/
// save to a new file using a full path string, ie: "/Users/user/desktop/new2.plist"
// (if the file exists, it will be overwritten)

let desktopFolderURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!

let newFilePath = desktopFolderURL.appendingPathComponent("new1.plist").path
if pl?.save(toFile: newFilePath) == .success {
	// the filePath and fileURL properties will now get updated to reflect the new file path
	pl?.filePath
	pl?.fileURL
	
	print("Save to file path succeeded!")
} else {
	print("Save to file path failed!")
}
/*:
### Method #3
*/
// save to a new file using a local URL path, ie: "file:///Users/user/desktop/new2.plist"
// (if the file exists, it will be overwritten)

let newFileURL = desktopFolderURL.appendingPathComponent("new2.plist")
if pl?.save(toURL: newFileURL) == .success {
	// the filePath and fileURL properties will now get updated to reflect the new file path
	pl?.filePath
	pl?.fileURL
	
	print("Save to file URL succeeded!")
} else {
	print("Save to file URL failed!")
}
/*:
### Method #2B / #3B:
*/
// These method is identical to the ones above, but
// the addition of the "format:" parameter allows you to specify the file's encoding format at the time you save the file

//pl?.save(format: .xml)
//pl?.format == .xml  	// true
//pl?.save(format: .binary)
//pl?.format == .binary	// true

pl?.save(toFile: newFilePath, format: .xml)
pl?.format == .xml		// true
pl?.save(toFile: newFilePath, format: .binary)
pl?.format == .binary	// true

pl?.save(toURL: newFileURL, format: .xml)
pl?.format == .xml		// true
pl?.save(toURL: newFileURL, format: .binary)
pl?.format == .binary	// true
/*:
### Dealing with save(...) return result
*/
// all save(...) methods return a result

// or, you can deal with the result, which is returned as an enum of type OTPListLoadResult
if plist.save(toFile: newFilePath) != .success {
	print("error saving plist file")
}

switch plist.save(toFile: newFilePath) {
case .success:
	print("new1.plist saved successfully")
case .error(let code, let description):
	if code != nil {
		print("new1.plist could not be saved: error code \(code!) - \(description)")
	} else {
		print("new1.plist could not be saved: \(description)")
	}
}
