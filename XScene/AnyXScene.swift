//
//  XAnyScene.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import Foundation
import SceneKit

// Inspo https://github.com/Cosmo/OpenSwiftUI/blob/master/Sources/OpenSwiftUI/Views/AnyView.swift

internal class AnyXSceneStorageBase : PlatformXScene {
    func doUpdate(_ node: SCNNode) {}
}

internal class AnyXSceneStorage<Content: XScene> : AnyXSceneStorageBase {
    public var content: Content
    init(_ scene: Content) {
        self.content = scene
    }
    
    var body: some XScene {
        return self.content
    }
    
    override func doUpdate(_ node: SCNNode) {
        updateScene(content: content, node: node)
    }
}

struct AnyXScene : XScene {
    var body: Never { fatalError() }

    internal var storage: AnyXSceneStorageBase
    
    init<Content: XScene>(_ scene: Content) {
        self.storage = AnyXSceneStorage<Content>(scene)
    }
}

extension AnyXScene : PlatformXScene {
    func doUpdate(_ node: SCNNode) {
        // Using a class here for storage, we are able to dispatch to the correct updater
        storage.doUpdate(node)
    }
}
