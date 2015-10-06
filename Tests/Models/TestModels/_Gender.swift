/************************************************

        WARNING: MACHINE GENERATED FILE

 ************************************************/
import Foundation
import STState

public enum Gender  : String, Model {

    case Female  = "Female"
    case Male  = "Male"

}

extension Gender: Decodable {

    public init?(var decoder: Decoder) {
        decoder = Gender.performMigrationIfNeeded(decoder)
        guard let value: String = decoder.decode("value") else { return nil }
        self.init(rawValue: value)
    }
}

extension Gender: Encodable {

    public func encode(encoder: Encoder) {
        encoder.encode(self.rawValue, "value")
        Gender.encodeVersionIfNeeded(encoder)
        self.willFinishEncodingWithEncoder(encoder)
    }
}

extension Gender {

    /// These are provided from the data model designer
    /// and can be used to determine if the model is
    /// a different version.
    public static func modelVersionHash() -> String {
        return "<ffba7348 838d3758 c6b41d57 ad7ea1b5 7c0a7ae4 0a9ead14 a727496b e503f5c2>"
    }

    public static func modelVersionHashModifier() -> String? {
        return nil
    }
}
