//
//  ContentView2.swift
//  MVVM
//
//  Created by Michal Ziobro on 26/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import SwiftUI

// reference type
class SomeUser : ObservableObject {
    @Published var name = "" // notify views about changes happen to this property
}

struct ContentView2: View {
    @State private var tapAmount = 0 // @State only for value types -> Primitive types
    @State private var name = ""
    @State private var slideAmount = 0.0
    
    @State private var favoriteFood = "Pizza"
    let options = ["Pizza", "Pasta", "Hot dogs"]
    
    @State private var showingAllOptions = false
    
    // for reference types
    @ObservedObject var user = SomeUser()
    
    @EnvironmentObject var someUser: SomeUser // do not need to pass user between views!
    
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
            Picker("Favorite food", selection: $favoriteFood) {
                ForEach(options, id: \.self) { food in
                    Text(food)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            List {
                Toggle(isOn: $showingAllOptions.animation()) {
                    Text("Showing all options")
                }
                
                if showingAllOptions {
                    Text("More options here: ")
                }
            }
            NavigationView {
                List {
                    TextField("Enter your name", text: $user.name)

                    NavigationLink(destination: Text("Hurray")) {
                        Text("Hello, \(user.name)")
                    }
                }
            }
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
            //.environmentObject(SomeUser()) // just for previewing purposes (should be from Scene delegate on simulator)
    }
}
