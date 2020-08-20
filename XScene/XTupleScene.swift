import SceneKit.SCNNode

struct XTupleScene<T> : XScene {
    public var value: T

    init(_ value: T) {
        self.value = value
    }

    var body: Never { fatalError() }
}

// This obviously does not scale. Can't enumerate all of the possibilities
extension XTupleScene : PlatformXScene where T == (XSphere, XSphere) {
    func doUpdate(_ node: SCNNode) {
        if node.childNodes.count == 2 {
            value.0.doUpdate(node.childNodes[0])
            value.1.doUpdate(node.childNodes[1])
        } else if (node.childNodes.count == 0) {
            node.addChildNode(SCNNode())
            node.addChildNode(SCNNode())
            value.0.doUpdate(node.childNodes[0])
            value.1.doUpdate(node.childNodes[1])
        } else {
            fatalError("Unexpected node configuration")
        }
    }
}
