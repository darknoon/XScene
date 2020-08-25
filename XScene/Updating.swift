/// Copyright Andrew Pouliot. All rights reserved.

import SceneKit

// If the body
protocol IsBodied {
}

extension Never : XScene {
    public typealias Body = Never
    public var body: Never {
        fatalError()
    }
}

extension XScene {
    static var isComposite: Bool { true }
}

internal protocol PlatformXScene {
    func doUpdate(_ node: SCNNode)
}


//func updateScene<Content : XScene>(content: Content, current: SCNNode) {
//    if let b = content as? PlatformXScene {
//        b.doUpdate(current)
//    } else {
//        // TODO: this only works because Body is already an XScene
//        let body = content.body
//        updateScene(content: body, current: current)
//    }
//}


// wip, will this help?
func updateScene<Content: XScene>(content: Content, node: SCNNode) {
    print("value body updater for \(type(of: Content.self)) - \(type(of: Content.Body.self))")
    if Content.Body.self == Never.self {
        print("Should not be here due to override func value() below!")
        return
    }
    updateScene(content: content.body, node: node)
}

func updateScene<Content: PlatformXScene>(content: Content, node: SCNNode) {
    content.doUpdate(node)
}

func updateScene<A: XScene, B: XScene>(content: XTupleScene<(A, B)>, node: SCNNode) {
    let (a, b) = content.value
    if node.childNodes.count == 2 {
        updateScene(content: a, node: node.childNodes[0])
        updateScene(content: b, node: node.childNodes[1])
    } else if (node.childNodes.count == 0) {
        node.addChildNode(SCNNode())
        node.addChildNode(SCNNode())
        updateScene(content: a, node: node.childNodes[0])
        updateScene(content: b, node: node.childNodes[1])
    } else {
        fatalError("Unexpected node configuration")
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

