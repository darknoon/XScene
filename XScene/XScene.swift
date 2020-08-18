import SceneKit
import SceneKit.ModelIO

import SwiftUI

extension Never : XScene {
    typealias Body = Never
    var body: Never {
        fatalError()
    }
}

protocol XScene {
    associatedtype Body : XScene

    @XSceneBuilder var body: Self.Body { get }
}

internal protocol PlatformXScene {

    func doUpdate(_ node: SCNNode)

}

extension PlatformXScene {
    func doUpdate() {}
}

struct XSphere : XScene {
    let radius: Float

    var body: Never { fatalError() }
}

struct XGroup<Content: XScene> : XScene {
    internal let content: Content

    @inlinable public init(@XSceneBuilder content: () -> Content) {
        self.content = content()
    }

    var body: Never { fatalError() }
}

struct XTupleScene<T> : XScene {
    public var value: T

    init(_ value: T) {
        self.value = value
    }

    var body: Never { fatalError() }
}


struct XEmptyScene : XScene {

    init() { }

    var body: Never { fatalError() }
}

@_functionBuilder
struct XSceneBuilder {

    static func buildBlock<Content : XScene>(c: () -> Content) -> some XScene {
        return c()
    }

    static func buildBlock() -> XEmptyScene {
        return XEmptyScene()
    }

    static func buildBlock<Content: XScene>(_ s: Content) -> Content {
        return s
    }

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> XTupleScene<(C0, C1)> {
        return XTupleScene((c0, c1))
    }

    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> XTupleScene<(C0, C1, C2)> {
        return XTupleScene((c0, c1, c2))
    }

}
