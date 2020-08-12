//
//  SceneKitStuff.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import Foundation
import SceneKit
import SwiftUI


extension XSphere : PlatformXScene {
    func doUpdate(_ node: SCNNode) {
        
        if let geom = node.geometry, let geomSphere = geom as? SCNSphere {
            print("Already a sphere, updating radius to \(radius)")
            geomSphere.radius = CGFloat(radius)
        } else {
            print("I'm a creating sphere of radius \(radius)");
            let geom = SCNSphere(radius: CGFloat(radius))
            node.geometry = geom
        }
    }
}

struct XSceneView<Content> : NSViewRepresentable where Content : XScene {
    
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
            #if false
            var c: some XScene = content
            var p: PlatformXScene?
            while p == nil {
                if let ps = c as? PlatformXScene {
                    p = ps
                } else {
                    c = c.body
                }
            }
            #else
            if let b = content as? PlatformXScene {
                b.doUpdate(root)
            } else {
                // TODO: this only works because Body is already an XScene
                let body = content.body
                if let b = body as? PlatformXScene {
                    b.doUpdate()
                }
            }
            #endif
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
        XSceneView{
            XSphere(radius: 12.0)
        }
    }
}
