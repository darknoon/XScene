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

    static func getSceneRoot<Content>(rootView: NSHostingView<XSceneView<Content>>) -> SCNNode? {
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
        
        XCTAssertEqual(root.childNodes.count, 0, "Should just be a sphere")
        XCTAssert(root.geometry is SCNSphere, "Didn't find a sphere")

    }
}
