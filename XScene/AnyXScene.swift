//
//  XAnyScene.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import Foundation

// Inspo https://github.com/Cosmo/OpenSwiftUI/blob/master/Sources/OpenSwiftUI/Views/AnyView.swift

class AnyXSceneStorageBase {}
class AnyXSceneStorage<Content: XScene> : AnyXSceneStorageBase {
    public var content: Content
    init(_ scene: Content) {
        self.content = scene
    }
    var body: some XScene {
        return self.content
    }
}


struct AnyXScene : XScene {
    var body: Never { fatalError() }

    private var storage: AnyXSceneStorageBase
    
    init<Content: XScene>(_ scene: Content) {
        self.storage = AnyXSceneStorage<Content>(scene)
    }
}

