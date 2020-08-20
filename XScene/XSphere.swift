import SceneKit

struct XSphere : XScene {
    let radius: Float

    var body: Never { fatalError() }
}


extension XSphere : PlatformXScene {
    func doUpdate(_ node: SCNNode) {
        if let geom = node.geometry, let geomSphere = geom as? SCNSphere {
//            print("Already a sphere, updating radius to \(radius)")
            geomSphere.radius = CGFloat(radius)
        } else {
            print("I'm a creating sphere of radius \(radius)");
            let geom = SCNSphere(radius: CGFloat(radius))
            node.geometry = geom
        }
    }
}
