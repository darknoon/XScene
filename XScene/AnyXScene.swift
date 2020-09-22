//
//  XAnyScene.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import Foundation
import SceneKit

// Inspo https://github.com/Cosmo/OpenSwiftUI/blob/master/Sources/OpenSwiftUI/Views/AnyView.swift

internal class AnyXSceneStorageBase {
    func doUpdate(_ node: SCNNode) {}
}

//struct AnyXSceneUpdater<Content: XScene>: XSceneUpdater {
//    func doUpdate(_ node: SCNNode) {
//
//    }
//}

internal class AnyXSceneStorage<Content: XScene> : AnyXSceneStorageBase {
    typealias Updater = AnyXSceneUpdater<Content>
    
    public var content: Content
    init(_ scene: Content) {
        self.content = scene
    }
    
    var body: Never { fatalError() }
}

struct AnyXScene : XScene {
    var body: Never { fatalError() }

    internal var storage: AnyXSceneStorageBase
    
    init<Content: XScene>(_ scene: Content) {
        self.storage = AnyXSceneStorage<Content>(scene)
    }
}
