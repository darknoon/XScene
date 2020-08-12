//
//  ContentView.swift
//  UIWorld
//
//  Created by Andrew Pouliot on 8/11/20.
//

import SwiftUI

struct ContentView: View {
    @State var radius: Float = 1.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        XSceneView {
            XSphere(radius: radius)
        }.frame(width: 300, height: 300, alignment: .top)
        .onReceive(timer, perform: {t in
            radius = 1.0 + 0.1 * Float(sin(t.timeIntervalSince1970));
        })
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    
    }
}
