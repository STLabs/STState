
//
// AUTO GENERATED FILE
// _TestProtocolConformer.swift
//

import Foundation
import State

public struct TestProtocolConformer : TestProtocol {
    public var age: Int?
    public var ss_number: String
    public var isReady: Bool?
    public var employee: Employee

    public var children: [TestChild]

}

extension TestProtocolConformer  {

    public static func read(from store: Store) -> TestProtocolConformer? {
      return self.init(with: store)
   }

    public init?(with inStore: Store) {
        let store = TestProtocolConformer.migrate(source: inStore)

         guard
            let ss_number: String = store.value(forKey: "ss_number"),
            let employee: Employee = store.value(forKey: "employee"),
            let children: [TestChild] = store.value(forKey: "children")
         else { return  nil }

        let age: Int? = store.value(forKey: "age")

        let isReady: Bool? = store.value(forKey: "isReady")

        self.age = age
        self.ss_number = ss_number
        self.isReady = isReady
        self.employee = employee
        self.children = children
        finishReading(from: store)
    }

    public func write(to store: inout Store) {
        store.set(age, forKey: "age")
        store.set(ss_number, forKey: "ss_number")
        store.set(isReady, forKey: "isReady")
        store.set(employee, forKey: "employee")
        store.set(children, forKey: "children")

        store.set("TestProtocolConformer", forKey: "TestParentProtocol")
        TestProtocolConformer.writeVersion(to: &store)
        finishWriting(to: &store)
    }
}
