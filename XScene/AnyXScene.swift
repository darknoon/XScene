//
//  XAnyScene.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import Foundation

// Inspo https://github.com/Cosmo/OpenSwiftUI/blob/master/Sources/OpenSwiftUI/Views/AnyView.swift

class AnyXsceneStorageBase {}
class AnyXsceneStorage<Content: XScene> : AnyXsceneStorageBase {
    public var content: Content
    init(_ scene: Content) {
        self.content = scene
    }
    var body: some XScene {
        return self.content
    }
}


struct AnyXScene : XScene {
    var body: some XScene {
        XEmptyScene()
//        fatalError()
    }
    
    private var storage: AnyXsceneStorageBase
    
    init<Content: XScene>(_ scene: Content) {
        self.storage = AnyXsceneStorage<Content>(scene)
    }
}

