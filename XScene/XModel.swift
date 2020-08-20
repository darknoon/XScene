import SceneKit

fileprivate func loadModel(name: String) -> SCNNode? {
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
