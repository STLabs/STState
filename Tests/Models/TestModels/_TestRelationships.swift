/************************************************

        WARNING: MACHINE GENERATED FILE

 ************************************************/
import Foundation
import State

public struct TestRelationships : Model {
    public var myChildren: [TestChild]?
    public var myGrandChildren: [Grandchild]?
    public var myOneChild: TestChild?

}

extension TestRelationships : Decodable {

    public init?(var decoder: Decoder) {
        decoder = TestRelationships.performMigrationIfNeeded(decoder)

        guard
            let myChildren: [TestChild]? = decoder.decodeModelArray("myChildren"),
            let myGrandChildren: [Grandchild]? = decoder.decodeModelArray("myGrandChildren"),
            let myOneChild: TestChild? = decoder.decodeModel("myOneChild")
        else { return  nil }

        self.myChildren = myChildren
        self.myGrandChildren = myGrandChildren
        self.myOneChild = myOneChild
        didFinishDecodingWithDecoder(decoder)
    }
}

extension TestRelationships : Encodable {

    public func encode(encoder: Encoder) {
        encoder.encode(myChildren, "myChildren")
        encoder.encode(myGrandChildren, "myGrandChildren")
        encoder.encode(myOneChild, "myOneChild")

        TestRelationships.encodeVersionIfNeeded(encoder)

        self.willFinishEncodingWithEncoder(encoder)
    }
}

extension TestRelationships {

    /// These are provided from the data model designer
    /// and can be used to determine if the model is
    /// a different version.
    public static func modelVersionHash() -> String {
        return "<4086c709 08537ea3 c28164b3 9e9cbdbf e9d83f02 72d9cd8f cd10f5c7 101fbcbb>"
    }

    public static func modelVersionHashModifier() -> String? {
        return nil
    }
}

