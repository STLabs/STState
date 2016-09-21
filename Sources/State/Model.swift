
//
// Model.swift
// Copyright © 2016 Amber Star. All rights reserved.
//

import UIKit

///  A type that can be encoded and decoded to various
///  data types.
/// 
///  Models and collections of them can be
///  written and read to json and plist files,`Strings`,
///  or `Data`. They have methods to support migration
///  and versioning.
/// 
///  Migration
///  ==========
///  To support migration:
/// 
///  * implement `static func writeVersion(with: Store)`
/// 
///    this method should be called in the `write(to:)` method
///    before writing to a store is finished to give the model an
///    opertunity to write version information to the store.
/// 
///  * implement `static func migrate(from: Store) -> Store`
/// 
///    this method should be called in the `read(from:)` method
///    before reading any values from the store to give the model
///    an opertunity to migrate the store. Here the model should:
/// 
///    -  read the version information from the store
///    -  compare the version information with the "current version"
///    -  add, remove, and update keys, and values to the store
///    -  return the updated store.
/// 
///    In the `read(from:)` method use the migrated store to read
///    and instantiate the model instance.
public protocol Model {
    /// creates a `Model` instance from
    /// a store.
    static func read(from: Store) -> Self?
    /// called after reading is finished
    /// to give a model an opertunity
    /// to prepare or to read extra values
    /// from the store before instantiation
    func finishReading(from: Store)
    /// Writes the`Model` to a `Store`
    func write(to: inout Store)
    /// called before writing is finished
    /// to give the model an opertunity
    /// to write extra values to the store
    func finishWriting(to: inout Store)
    /// writes the model version to the store.
    /// 
    /// This is called before writing a model to
    /// a store is complete to give the model
    /// an opertunity to write version information
    /// to the store for migration purporses.
    static func writeVersion(to: inout Store)
    /// migrates a store to the current version if needed.
    /// 
    /// the default implementation returns the origional store
    /// models can update the store to the current version
    /// by adding, removing, and changing keys ans values in the
    /// store, and return the updated store.
    static func migrate(source: Store) -> Store
}

extension Model {

    /// Create a model from a file in the specified format.
    public init?(file: URL, format: Format) {
        guard let data = format.read(file)
            else { return nil }
        guard let instance = Self.read(from: Store(data: data as! [String: AnyObject]))
            else { return nil }
        self = instance
    }

    /// Create a model from a string in the specified format.
    public init?(content: String, format: Format) {

        guard let data = format.read(content)
            else { return nil }
        guard let instance = Self.read(from: Store(data: data as! [String: AnyObject]))
            else { return nil }
        self = instance
    }

    /// Create a model from data in the specified format.
    public init?(content: Data, format: Format) {
        guard let data = format.read(content)
            else { return nil }
        guard let instance = Self.read(from: Store(data: data as! [String: AnyObject]))
            else { return nil }
        self = instance
    }

    /// Create a model from a dictionary representation
    public init?(content: [String: Any]) {
        guard let instance = Self.read(from: Store(data: content))
            else { return nil }
        self = instance
    }

    /// Write the store content to a file in the specified format.
    /// 
    /// - Returns: `true` if succeeded otherwise `false`
    public func write(to location: URL, format: Format) -> Bool {
        var vstore = Store()
        self.write(to: &vstore)
        return format.write(vstore.data as NSDictionary, to: location)
    }

    /// Convert and return the content as a string in the specified format.
    public func makeString(format: Format) -> String? {
        var vstore = Store()
        self.write(to: &vstore)
        return format.makeString(from: vstore.data as NSDictionary)
    }

    /// Convert and return the content as data in the specified format.
    public func makeData(format: Format) -> Data? {
        var vstore = Store()
        self.write(to: &vstore)
        return format.makeData(from: vstore.data as NSDictionary, prettyPrint: true)
    }

    /// Convert and return a dictionary representation
    public func makeDictionary() -> [String: Any] {
        var vstore = Store()
        self.write(to: &vstore)
        return vstore.data
    }

    // note: these default implementations do nothing

    public static func migrate(source: Store) -> Store {
        return source
    }

    // default implementation does nothing
    public static func writeVersion(to: inout Store) {}

    // default implementation does nothing
    public func finishReading(from: Store) {}

    // default implementation does nothing
    public func finishWriting(to: inout Store) {}
}

// TODO: Refactor these collections to reduce repeat code
extension Array where Element: Model {

    /// Create an array of models from an array of dictionaries
    public init?(data: [[String: Any]]) {
        guard let instance = sequence(data.map { Element.read(from: Store(data: $0)) })
            else { return nil }
        self = instance
    }

    /// Create an array of models from a file in the specified format.
    public init?(file: URL, format: Format) {
        guard let data = format.read(file) as? [[String: AnyObject]]
            else { return nil }
        guard let instance = sequence(data.map { Element.read(from: Store(data: $0)) })
            else { return nil }
        self = instance
    }

    /// Create an array of models from a string in the specified format.
    public init?(content: String, format: Format) {
        guard let data = format.read(content) as? [[String: AnyObject]]
            else { return nil }
        guard let instance = sequence(data.map { Element.read(from: Store(data: $0)) })
            else { return nil }
        self = instance
    }

    /// Create an array of models from data in the specified format.
    public init?(content: Data, format: Format) {
        guard let data = format.read(content) as? [[String: AnyObject]]
            else { return nil }
        guard let instance = sequence(data.map { Element.read(from: Store(data: $0)) })
            else { return nil }
        self = instance
    }

    /// Writes the model array to a file in the specified format.
    /// 
    /// - Returns: `true` if succeeded otherwise `false`
    public func write(to location: URL, format: Format) -> Bool {
        return format.write(encodeToData() as AnyObject, to: location)
    }

    /// Return the model array content as a string in the specified format.
    public func makeString(format: Format) -> String? {
        return format.makeString(from: encodeToData() as AnyObject)
    }

    /// Return the model array content as data in the specified format.
    public func makeData(format: Format) -> Data? {
        return format.makeData(from: encodeToData() as AnyObject, prettyPrint: true)
    }

    /// Return the model array content as a dictionary array
    public func makeDictionaryArray() -> [[String: Any]] {
        return self.encodeToData() as! [[String: Any]]
    }

    func encodeToData() -> Any {
        return self.reduce([[String: Any]]()) { (accum, elem) -> [[String: Any]] in
            var vaccum = accum
            var vstore = Store()
            elem.write(to: &vstore)
            vaccum.append(vstore.data)
            return vaccum
        }
    }
}

extension Store {

    /// Return a value at key or nil if not found.
    public func value<Value: Model>(forKey key: String) -> Value? {
        guard let data = data[key] as? [String: AnyObject]
            else { return nil }
        return Value.read(from: Store(data: data))
    }

    /// Return a value at key or nil if not found.
    public func value<Value: Model>(forKey key: String) -> [Value]? {
        guard let data = data[key] as? [[String: AnyObject]]
            else { return nil }
        return sequence(data.map { Value.read(from: Store(data: $0)) })
    }

    /// Return a value at key or nil if not found.
    public func value<Value: Model>(forKey key: String) -> [String: Value]? {
        guard let data = data[key] as? [String: [String: AnyObject]]
            else { return nil }
        return sequence(data.map { Value.read(from: Store(data: $0)) })
    }

    /// Add or update the value at key.
    public mutating func set<Value: Model>(_ value: Value?, forKey key: String) {
        guard let value = value
            else { return }
        var vstore = Store()
        value.write(to: &vstore)
        data[key] = vstore.data
    }

    /// Add or update the value at key.
    public mutating func set<Value: Model>(_ value: [Value]?, forKey key: String) {
        guard let value = value
            else { return }
        let data = value.reduce([[String: Any]](), { (data, value) -> [[String: Any]] in
            var vstore = Store()
            var vdata = data
            value.write(to: &vstore)
            vdata.append(vstore.data)
            return vdata
        })
        self.data[key] = data
    }

    /// Add or update the value at key.
    public mutating func set<Value: Model>(_ value: [String: Value]?, forKey key: String) {
        guard let value = value
            else { return }
        let data = value.reduce([String: [String: Any]](), { (data, element) -> [String: [String: Any]] in
            var vstore = Store()
            var vdata = data
            element.value.write(to: &vstore)
            vdata[element.key] = vstore.data
            return vdata
        })
        self.data[key] = data
    }
}