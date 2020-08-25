import SceneKit
import SceneKit.ModelIO

import SwiftUI

/// This is the fundamental protocol in XScene.
/// Create your scene hierarchy by providing a body
public protocol XScene {
    associatedtype Body : XScene

    @XSceneBuilder var body: Self.Body { get }
}

struct XEmptyScene : XScene {

    init() {}

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

struct XScene_Previews: PreviewProvider {
    static var previews: some View {
        XSceneView{
            XGroup{
                XSphere(radius: 10.0)
            }
        }.background(Color.blue)
    }
}
