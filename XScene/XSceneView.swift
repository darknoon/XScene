/// Copyright Andrew Pouliot. All rights reserved.

import SceneKit
import SwiftUI

#if os(macOS)
import AppKit.NSColor
typealias PlatformColor = NSColor
#elseif os(iOS)
import UIKit.UIColor
typealias PlatformColor = UIColor
#endif

enum WorldBackground {
    case platformColor(PlatformColor)
    case color(Color)
}

extension SwiftUI.Color {
    static var supportsCGColor: Bool {
        let bun = Bundle(for: SwiftUI.NSHostingView<EmptyView>.self)
        if let ver = bun.infoDictionary?["CFBundleVersion"] as? String {
            return "96.0.401".compare(ver, options: .numeric) == .orderedAscending
        }
        return false
    }
    
    var safeCGColor: CGColor? {
        if Self.supportsCGColor {
            return cgColor
        }
        // Some basic fallback for previous OS versions
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        default:
            return nil
        }
    }
}

struct XSceneView<Content> : NSViewRepresentable where Content : XScene {
    
    let content: Content
    let background: WorldBackground
    
    init(background: WorldBackground = .color(.black), @XSceneBuilder _ content: () -> Content) {
        self.content = content()
        self.background = background
    }
    
    func makeNSView(context: Context) -> SCNView {
        // Load the SKScene from 'GameScene.sks'
        let sceneView = SCNView(frame: CGRect(x:0 , y:0, width: 300, height: 300))

        let scene = SCNScene()
        updateSceneBackground(scene: scene, background: background)

        sceneView.scene = scene
        sceneView.showsStatistics = true
        return sceneView
    }
    
    private func updateSceneBackground(scene: SCNScene, background: WorldBackground) {
        switch background {
        case let .color(color):
            scene.background.contents = color.safeCGColor
        case let .platformColor(color):
            scene.background.contents = color
        }

    }
    
    func updateNSView(_ scnView: SCNView, context: Context) {
        guard let scene = scnView.scene else { return }
        updateSceneBackground(scene: scene, background: background)
//        updateScene(content: content, node: scene.rootNode)
        content.doUpdate(scene.rootNode)
    }
    
}

// ~View modifier
// Needs an actual ModifiedView to be efficient?
extension XSceneView {
    func background(_ color: Color) -> Self {
        return Self(background: .color(color), { return content })
    }
    func background(_ color: PlatformColor) -> Self {
        return Self(background: .platformColor(color), { return content })
    }
}

struct SceneKitStuff_Previews: PreviewProvider {
    static var previews: some View {
        XSceneView{
            XSphere(radius: 12.0)
        }
    }
}
