//
//  SceneKitStuff.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import Foundation
import SceneKit
import SwiftUI

// TODO: make some kind of view updater that will persist and handle changes in the tree

func _updateScene<C0, C1>(_ node: SCNNode, content: XTupleScene<(C0, C1)>) {
    _updateScene(node.childNodes[0], content: content.value.0);
    _updateScene(node.childNodes[1], content: content.value.1);
}

func _updateScene<XSphere>(_ node: SCNNode, content: XSphere) {
    
}

struct XSceneView<Content> : NSViewRepresentable {
    
    let content: Content
    
    init(@XSceneBuilder _ content: () -> Content) {
        self.content = content()
        print("Init with content")
    }
    
    func makeNSView(context: Context) -> SCNView {
        // Load the SKScene from 'GameScene.sks'
        let sceneView = SCNView(frame: CGRect(x:0 , y:0, width: 300, height: 300))

        let scene = SCNScene()
        scene.background.contents = NSColor.red

        //let sph = SCNSphere(radius: 10)
        //sph.firstMaterial!.emission.contents = NSColor.green
        //scene.rootNode.addChildNode(SCNNode(geometry: sph))
        if let finderGuy = loadModel(name: "FinderGuy") {
            scene.rootNode.addChildNode(finderGuy)
            dump(finderGuy)
        }

        sceneView.backgroundColor = .black
        sceneView.scene = scene
        sceneView.showsStatistics = true
        return sceneView
    }
    
    func updateNSView(_ scnView: SCNView, context: Context) {
        if let root = scnView.scene?.rootNode {
            _updateScene(root, content: content)
        }
    }
    
    typealias NSViewType = SCNView
    
    func loadModel(name: String) -> SCNNode? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "usdz") else { return nil }
        var errOpt: NSError? = nil
        let mdlAsset = MDLAsset(url: url, vertexDescriptor: nil, bufferAllocator: nil, preserveTopology: true, error: &errOpt)
        if let err = errOpt {
            print("Error loading asset, \(err.debugDescription)")
            return nil
        }
        
        let scene = SCNScene(mdlAsset: mdlAsset)
        return scene.rootNode
    }

    
}

struct SceneKitStuff_Previews: PreviewProvider {
    static var previews: some View {
        MySceneView{
            XSphere(radius: 12.0)
        }
    }
}
