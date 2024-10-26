//
//  PListProtocol read.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

func readFile(path: String) throws -> Data {
    guard FileManager.default.fileExists(atPath: path)
    else { throw PListLoadError.fileNotFound }
    
    let url = URL(fileURLWithPath: path)
    
    let fileContents = try readFile(url: url)
    
    return fileContents
}

func readFile(url: URL) throws -> Data {
    if url.isFileURL {
        guard FileManager.default.fileExists(atPath: url.path)
        else { throw PListLoadError.fileNotFound }
    }
    
    return try Data(contentsOf: url)
}

extension PListProtocol {
    func deserialize(
        plist data: Data
    ) throws -> (
        format: PListFormat,
        plistRoot: Root
    ) {
        let converted = try data.deserializeToPListValue()
        
        guard let plistRoot = converted.plistRoot as? Root else {
            throw PListLoadError.formatNotExpected
        }
        
        return (
            format: converted.format,
            plistRoot: plistRoot
        )
    }
}

extension Data {
    func deserializeToPListValue() throws -> (
        format: PListFormat,
        plistRoot: PListValue
    ) {
        // this is not determining the format, it just needs to be initialized to *some*
        // value so that `PropertyListSerialization.propertyList` can mutate it.
        var getFormat: PListFormat = .xml
        
        // if this succeeds, it will update getFormat with the file's actual format
        let plistRoot = try PropertyListSerialization.propertyList(
            from: self,
            format: &getFormat
        )
        
        guard let converted = convertToPListValue(from: plistRoot) else {
            throw PListLoadError.formatNotExpected
        }
        
        return (
            format: getFormat,
            plistRoot: converted
        )
    }
    
    func deserializeToWrappedPList() throws -> (
        format: PListFormat,
        wrappedPlist: WrappedPList
    ) {
        // this is not determining the format, it just needs to be initialized to *some*
        // value so that `PropertyListSerialization.propertyList` can mutate it.
        var getFormat: PListFormat = .xml
        
        // if this succeeds, it will update getFormat with the file's actual format
        let plistRoot = try PropertyListSerialization.propertyList(
            from: self,
            format: &getFormat
        )
        
        guard let converted = convertToWrappedPList(root: plistRoot, format: getFormat) else {
            throw PListLoadError.formatNotExpected
        }
        
        return (
            format: getFormat,
            wrappedPlist: converted
        )
    }
}
