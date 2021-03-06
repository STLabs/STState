
//
// AUTO GENERATED FILE
// _TestRawEnum.swift
//

import Foundation
import State

public enum TestRawEnum  : String, Model {

    case aim  = "Aim"
    case fire  = "Fire"
    case ready  = "Ready"

}

extension TestRawEnum {

    public init?(with source: Store) {
        let store = TestRawEnum.migrate(source: source)

        guard let value: String = store.value(forKey: "value") else { return nil }
        self.init(rawValue: value)
    }

// MARK: - Storeable

    public static func restore(from store: Store) -> TestRawEnum? {
        return self.init(with: store)
    }

    public func store(to store: inout Store) {
        store.set(self.rawValue, forKey: "value")
            TestRawEnum.writeVersion(to: &store)
            finishWriting(to: &store)
    }
}

