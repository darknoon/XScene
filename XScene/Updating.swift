/// Copyright Andrew Pouliot. All rights reserved.

import SceneKit

extension Never : XScene {
    typealias Body = Never
    var body: Never {
        fatalError()
    }
}

internal protocol PlatformXScene {
    typealias Body = Never
    func doUpdate(_ node: SCNNode)
}


internal struct Updating<Content: XScene> {
    public let update: (Content) -> Void
}

extension Updating where Content : PlatformXScene {
    static func updater() {
        
    }

}
