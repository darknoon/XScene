//
//  ContentView.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        XSceneView {
            XSphere(radius: 4.0)
        }.frame(width: 300, height: 300, alignment: .top)
//        CheckOrderView()
        Text("Hello, world!")
            .padding()
//        Circle()
//            .fill(Color.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    
    }
}
