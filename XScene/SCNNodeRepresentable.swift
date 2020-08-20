/// Copyright Andrew Pouliot. All rights reserved.

import SceneKit
import SwiftUI

struct SCNNodeRepresentableContext<Scene> where Scene : SCNNodeRepresentable {
    public let coordinator: Scene.Coordinator
    // TODO: how to make @internal(set)
    public var transaction: Transaction
    // TODO: how to make @internal(set)
    public var environment: EnvironmentValues

}

protocol SCNNodeRepresentable {
    typealias Body = Never
    associatedtype NodeType : SCNNode
    
    func makeNode(context: Self.Context) -> Self.NodeType

    func updateNode(_ node: Self.NodeType, context: Self.Context)

    static func dismantleNode(_ node: Self.NodeType, coordinator: Self.Coordinator)

    /// A type to coordinate with the view.
    associatedtype Coordinator = Void
    
    func makeCoordinator() -> Self.Coordinator

    typealias Context = SCNNodeRepresentableContext<Self>

}

