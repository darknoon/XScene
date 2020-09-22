/// Copyright Andrew Pouliot. All rights reserved.

import SceneKit

import Runtime

// If the body
protocol IsBodied {
}


internal protocol XSceneUpdater {
    init()
    func doUpdate(_ node: SCNNode)
}


internal protocol PlatformXScene {
    associatedtype Updater : XSceneUpdater
}

extension XScene {
    static func doUpdate(_ content: Self, _ node: SCNNode) {
        Body.doUpdate(content.body, node)
    }
}

extension XScene where Body == Never{
    static func doUpdate(_ content: Body, _ node: SCNNode) {
    }
}

import Swift

extension XTupleScene : PlatformXScene {
    
    struct XTupleSceneUpdater {
        func doUpdate(_ node: SCNNode) {
            XTupleScene<Content>._doUpdate
        }
    }
    
    typealias Updater = XTupleSceneUpdater
    
    
    static func _doUpdate(t: Any, node: SCNNode) {
        // Blagh!
    }
    
    static func _doUpdate<A, B>(t: (A, B), node: SCNNode) where A: XScene, B: XScene {
        let a = t.0
        let b = t.1
        updateScene(content: a, node: node)
        updateScene(content: b, node: node)
    }
    
    static func doUpdate<T>(_ content: XTupleScene<T>, _ node: SCNNode) {
        Self._doUpdate(t: content.value, node: node)
    }
    
    static func doUpdate<T>(_ content: T, _ node: SCNNode) {
        if T.Type.self == Self.self {
//            Swift.
//            Self.doUpdate(content: content as XTupleScene, node: node)
        }
    }

}

func updateScene<Content : XScene>(content: Content, node: SCNNode) {
    if let b = content as? PlatformXScene {
        b.doUpdate(current)
    } else {
        // TODO: this only works because Body is already an XScene
        let body = content.body
        updateScene(content: body, current: current)
    }
}

extension XTupleScene {
    
    func doUpdate<A: XScene, B: XScene>(content: XTupleScene<(A, B)>, node: SCNNode) {
        let (a, b) = content.value
        if node.childNodes.count == 2 {
            A.doUpdate(content: a, node: node.childNodes[0])
            B.doUpdate(content: b, node: node.childNodes[1])
        } else if (node.childNodes.count == 0) {
            node.addChildNode(SCNNode())
            node.addChildNode(SCNNode())
            A.doUpdate(content: a, node: node.childNodes[0])
            B.doUpdate(content: b, node: node.childNodes[1])
        } else {
            fatalError("Unexpected node configuration")
        }
    }

}


//extension Updating where Content : PlatformXScene {
//    static func value(_ a: Content) -> Updating<Content> where Content : PlatformXScene {
//        return Updating<Content>({node in a.doUpdate(node)})
//    }
//}

//extension Updating where Content == Never {
//    static func value(_ a : Never) { }
//}

#if false
protocol Tuplish {}
extension XTupleScene : Tuplish {}

extension Updating where Content : Tuplish {
//    static func tuple<X>(_ x: X) -> Updating<Void> {
//        return Updating<Void>({ _ in })
//    }

    func update<A, B>(c: XTupleScene<(A, B)>, n: SCNNode) {
        print("Tuple update func")
    }
    
    static func value<A, B>(_ a: XTupleScene<(A, B)>) -> Updating<XTupleScene<(A, B)>> where A: XScene, B: XScene {
        Updating.tuple(a.value)
    }

    static func value<A, B>(_ a: XGroup<XTupleScene<(A, B)>>) -> Updating<XTupleScene<(A, B)>> where A: XScene, B: XScene {
        Updating.tuple(a.content.value)
    }

    static func tuple<A, B>(_ v: (A, B)) -> Updating<XTupleScene<(A, B)>> where A: XScene, B: XScene {
        let a = Updating<A>.value(v.0)
        let b = Updating<B>.value(v.1)
        return Updating<XTupleScene<(A, B)>>.tuple(a,b)
    }

    static func tuple<A, B>(_ a: Updating<A>, _ b: Updating<B>) -> Updating<XTupleScene<(A, B)>> {
        return Updating<XTupleScene<(A, B)>>({ node in
            if node.childNodes.count == 2 {
                a.update(node.childNodes[0])
                b.update(node.childNodes[1])
            } else if (node.childNodes.count == 0) {
                node.addChildNode(SCNNode())
                node.addChildNode(SCNNode())
                a.update(node.childNodes[0])
                b.update(node.childNodes[1])
            } else {
                fatalError("Unexpected node configuration")
            }

        })
    }
}
    #endif

//extension Updating where Content == XTupleScene<(XSphere, XSphere)> {
//    var update: (SCNNode, Content) -> Void {
//        {(node: SCNNode, content: Content) in
//        content.doUpdate(node)
//        }
//    }
//}

