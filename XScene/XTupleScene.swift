import SceneKit.SCNNode

@frozen public struct XTupleScene<T> : XScene {
    public var value: T

    init(_ value: T) {
        self.value = value
    }

    public var body: Never { fatalError() }
}

