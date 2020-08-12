import SceneKit
import SceneKit.ModelIO

import SwiftUI

typealias _Never = ()
func nope() -> _Never {
    return ()
}
//func nope() -> Never {
//    fatalError("This isn't supposed to be called")
//}

protocol XScene {

    associatedtype Body

    @XSceneBuilder var body: Self.Body { get }
}

struct XSphere : XScene {
    typealias Body = _Never
    
    let radius: Float

    var body: _Never = nope()
}

struct XGroup<Content: XScene> : XScene {
    let content: Content

    var body: some XScene {
        return content
    }
}

struct XTupleScene<T> : XScene {
    public var value: T

    init(_ value: T) {
        self.value = value
    }

    public typealias Body = _Never

    var body: _Never
}


struct XEmptyScene : XScene {
    typealias Body = _Never

    init() { }

    var body: _Never = nope()
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
