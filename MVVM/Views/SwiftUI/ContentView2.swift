//
//  ContentView2.swift
//  MVVM
//
//  Created by Michal Ziobro on 26/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import SwiftUI

struct ContentView2: View {
    @State private var tapAmount = 0
    @State private var name = ""
    @State private var slideAmount = 0.0
    
    var body: some View {
        VStack {
            Button("Tap count: \(tapAmount)") {
                self.tapAmount += 1
                print(self.tapAmount)
            }
            TextField("Enter your name:", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Hello, \(name).")
            Slider(value: $slideAmount)
            Text("Amount: \(slideAmount).")
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
