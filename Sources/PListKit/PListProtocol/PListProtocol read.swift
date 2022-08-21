//
//  PListProtocol read.swift
//  PListKit • https://github.com/orchetect/PListKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PListProtocol {
    static func readFile(path: String) throws -> Data {
        guard fileManager.fileExists(atPath: path)
        else { throw PListLoadError.fileNotFound }
        
        let url = URL(fileURLWithPath: path)
        
        let fileContents = try readFile(url: url)
        
        return fileContents
    }
    
    static func readFile(url: URL) throws -> Data {
        if url.isFileURL {
            guard fileManager.fileExists(atPath: url.path)
            else { throw PListLoadError.fileNotFound }
        }
        
        return try Data(contentsOf: url)
    }
    
    func deserialize(
        plist data: Data
    ) throws -> (
        format: PListFormat,
        plistRoot: Root
    ) {
        // this is not determining the format, it just needs to be initialized to *some*
        // value so that `PropertyListSerialization.propertyList` can mutate it.
        var getFormat: PListFormat = .xml
        
        // if this succeeds, it will update getFormat with the file's actual format
        let plistRoot = try PropertyListSerialization.propertyList(
            from: data,
            format: &getFormat
        )
        
        guard let converted = convertToPListValue(from: plistRoot) else {
            throw PListLoadError.formatNotExpected
        }
        
        guard let plistRoot = converted as? Root else {
            throw PListLoadError.formatNotExpected
        }
        
        return (
            format: getFormat,
            plistRoot: plistRoot
        )
    }
}
