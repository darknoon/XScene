//
//  XSceneTests.swift
//  XSceneTests
//
//  Created by Andrew Pouliot on 8/11/20.
//

import XCTest
import SnapshotTesting
import SwiftUI
import SceneKit
import Combine

@testable import XScene

class XSceneTests: XCTestCase {

    func testJustASphere() {
        let s = XSceneView{
            XSphere(radius: 10.0)
        }
        assertSnapshot(matching: s, as: .description)
    }
    
    func testTupleOfSpheres() {
        let s = XSceneView{
            XSphere(radius: 10.0)
            XSphere(radius: 0.5)
        }
        assertSnapshot(matching: s, as: .description)
    }

    func testGroup() {
        let g = XGroup{
            XSphere(radius: 10.0)
            XSphere(radius: 0.5)
        }
        assertSnapshot(matching: g, as: .description)
        assertSnapshot(matching: g.content, as: .description)
    }

    static func getSceneRoot<Content>(rootView: NSHostingView<Content>) -> SCNNode? {
        guard let plhv = rootView.subviews.first?.subviews.first else {
            XCTFail("Couldn't find a view in our platform host")
            return nil
        }
        guard let scnView = plhv as? SCNView else {
            XCTFail("Found view is not a scene view")
            return nil
        }
        guard let root = scnView.scene?.rootNode else {
            XCTFail("Couldn't find root of scene")
            return nil
        }
        return root
    }
    
    func testMount() {
        let v = NSHostingView(rootView: XSceneView{
            XSphere(radius: 10.0)
        })
        v.layout()

        guard let root = XSceneTests.getSceneRoot(rootView: v) else {
            return
        }
        
        // We should probably put the sphere in a wrapper, but it isn't at the moment
        XCTAssertEqual(root.childNodes.count, 0, "Should just be a sphere")
        XCTAssert(root.geometry is SCNSphere, "Didn't find a sphere")
        
    }
    
    func testMountTwoSpheres() {
        let v = NSHostingView(rootView: XSceneView{
            XSphere(radius: 10.0)
            XSphere(radius: 5.0)
        })
        v.layout()

        guard let root = XSceneTests.getSceneRoot(rootView: v) else {
            return
        }
        
        XCTAssertEqual(root.childNodes.count, 2, "Looking for 2 spheres")
        XCTAssert(root.childNodes[0].geometry is SCNSphere, "Didn't find a sphere")
    }
    
    func testMountAnyScene() {
        
        let pub = PassthroughSubject<Bool, Never>()
        
        struct MyWrapper : View {
            let pub: AnyPublisher<Bool, Never>
            @State var showGroup: Bool = false
            var body: some View {
                XSceneView{
                    MyAnyScene(showGroup: showGroup)
                }.onReceive(pub) { newValue in
                    self.showGroup = newValue
                }
            }
        }
        
        struct MyAnyScene: XScene {
            let showGroup: Bool
            var body: some XScene {
               let a = XSphere(radius: 10)
                let b = XGroup{
                    XSphere(radius: 10)
                    XSphere(radius: 2)
                }
                showGroup ? AnyXScene(b) : AnyXScene(a)
            }
        }
        
        let v = NSHostingView(rootView: MyWrapper(pub: pub.eraseToAnyPublisher()))
        v.layout()
        
        guard let root = XSceneTests.getSceneRoot(rootView: v) else {
            return
        }

        XCTAssert(root.childNodes.count == 0, "Should have single sphere")
        XCTAssert(root.geometry is SCNSphere, "Should have single sphere body")
        
        pub.send(true)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.4))

        XCTAssert(root.childNodes.count == 2, "Should have group body")
        XCTAssert(root.childNodes[0].geometry is SCNSphere, "Should have group body")
        
    }
}
