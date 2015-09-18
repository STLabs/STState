
public protocol Decodable {
    init?(decoder: Decoder)
}

public extension Decodable {
    public static func decode(data: [String : AnyObject]) -> Self? {
        let decoder = Decoder(data: data)
        return Self.init(decoder: decoder)
    }
    
    public static func decode(data: AnyObject?) -> Self? {
        if let data = data as? [String : AnyObject] {
            return Self.decode(data)
        }
        return nil
    }
    
    public static func decodeFromFile(converter: KeyedConverter.Type, path: String) -> Self? {
        return decode(converter.read(path))
    }
}

public final class Decoder {
    private var data = [String : AnyObject]()
    
    /// initialize a new decoder with data
    /// - parameter data: a dictionary to use for decoding
    /// - returns: returns a decoder
    public init(data: [String : AnyObject]) {
        self.data = data
    }

    /// decode a decodable element
    /// - parameter key: a dictionary to use for decoding
    /// - returns: return element of type T or nil if decoding failed
    public func decodeModel<T:Decodable>(key: String) -> T? {
        let d = data[key] as? [String : AnyObject]
        return d.flatMap(_decodeDecodable)
    }
    
    /// decode a decodable array of element T
    /// - parameter key: a dictionary to use for decoding
    /// - returns: return an optional array of T or nil if decoding failed
    public func decodeModelArray<T:Decodable>(key: String) -> [T]? {
        let d = data[key] as? [[String : AnyObject]]
        var e = d.flatMap { sequence($0.map( _decodeDecodable)) }
        return e
    }
    
    /// decode a dictionary of string,decodable element T
    /// - parameter key: a dictionary to use for decoding
    /// - returns: return a dictionary of string, element T or nil if decoding failed
    public func decodeModelDictionary<T: Decodable>(key: String) -> [String : T]? {
        let d = data[key] as? [String : [String : AnyObject]]
        return d.flatMap { sequence($0.map(_decodeDecodable)) }
    }
    
    /// decode a value element V
    /// - parameter key: a dictionary to use for decoding
    /// - returns: return an element V or nil if decoding failed
    public func decode<V>(key: String) -> V? {
        return data[key] as? V
    }
    
    public func extractData() -> [String : AnyObject] {
        return self.data
    }
    
    private func _decodeDecodable<T: Decodable>(data: [String : AnyObject]) -> T? {
        return T(decoder: Decoder(data: data))
    }
}