
//
// Format.swift
// Copyright © 2016 SIMPLETOUCH LLC. All rights reserved.
//

import Foundation

/// Used internally by a stores to read and write it's
/// content to files, strings, data. etc.
public class Format {
    static var binary: Format {
        return Format()
    }
    static var json: Format {
        return JSONFormat()
    }
    static var plist: Format {
        return PlistFormat()
    }
    /// write data to a file
    /// - returns: true if succeeded, false if failed
    func write(_ object: AnyObject, to url: URL) -> Bool  {
        if let data = makeData(from: object, prettyPrint: true) {
            return ((try? data.write(to: url, options: [.atomic] )) != nil)
        }
        else { return false }
    }
    
    /// write data to  NSData
    /// - returns: NSData or nil if failed
    func makeData(from object: AnyObject,
                  prettyPrint: Bool) -> Data?  {
        return NSKeyedArchiver.archivedData(withRootObject: object)
    }
    
    /// write data to String
    /// - returns: a string or nil if failed
    func makeString(from object: AnyObject) -> String? {
        if let data = makeData(from: object, prettyPrint: true) {
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
        } else { return nil }
    }
    
    /// Read data from NSData
    /// - returns: a data object or nil
    func read(_ data: Data) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : AnyObject]
    }
    
    /// Read file from a URL
    /// - returns: a data object or nil
    func read(_ url: URL) -> AnyObject? {
        if let data = try? Data(contentsOf: url) {
            return read(data)
        }
        return nil
    }
    
    /// Read data from a string
    /// - returns: a data object or nil
    func read(_ content: String) -> AnyObject? {
        guard let data = makeData(from: content)
            else { return nil }
        return read(data)
    }
    
    func makeData(from string : String) -> Data? {
        return string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    }
}

final class JSONFormat: Format {
    override func read(_ data: Data) -> AnyObject? {
        do {
            let o: AnyObject =  try JSONSerialization.jsonObject(
                with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return o
        } catch let error as NSError {
            Swift.print(error)
            return nil
        }
    }
    
    override func makeData(from object: AnyObject, prettyPrint: Bool) -> Data?  {
        
        guard JSONSerialization.isValidJSONObject(object)
            else { return nil }
        let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []
        let data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: object, options: options)
        }
        catch let error as NSError {
            Swift.print(error)
            data = nil
        }
        return data
    }
}

final class PlistFormat: Format {
    override func read(_ data: Data) -> AnyObject? {
        do {
            let o: AnyObject =
                try PropertyListSerialization.propertyList(from: data, options:[.mutableContainersAndLeaves], format:nil)
            return o
        } catch let error as NSError {
            Swift.print(error)
            return nil
        }
    }
    
    override func read(_ content: String) -> AnyObject? {
        let s = content as NSString
        return s.propertyList()
    }
    
    
    override func makeData(from object: AnyObject,
                           prettyPrint: Bool) -> Data?  {
        guard PropertyListSerialization.propertyList(
            object, isValidFor: PropertyListSerialization.PropertyListFormat.xml)
            else { return nil }
        do {
            let data: Data? = try PropertyListSerialization.data(
                fromPropertyList: object, format: PropertyListSerialization.PropertyListFormat.xml, options: .allZeros )
            return data
        } catch let error as NSError {
            Swift.print(error)
        }
        return nil
    }
}
