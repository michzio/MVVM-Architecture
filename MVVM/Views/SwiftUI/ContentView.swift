//
//  ContentView.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import SwiftUI

struct User : Swift.Identifiable {
    var id = UUID()
    var name: String
}

struct ContentView: View {
    
    let users = [
        User(name: "Taylor"),
        User(name: "Adele"),
        User(name: "Justin")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                HStack(alignment: .center, spacing: 50) {
                    Text("Hello World")
                        .font(.largeTitle)
                    /*.frame(minWidth: 0, maxWidth: .infinity,
                           minHeight: 0, maxHeight: .infinity)*/
                    .background(Color.red)
                    .foregroundColor(.white)
                    Spacer()
                    Text("Hello World 2") //.layoutPriority(1)
                    .font(.largeTitle)
                }.edgesIgnoringSafeArea(.bottom)
                Text("Huge")
    //            VStack {
    //                ForEach([1,2,3], id: \.self) { num in
    //                    Text("\(num)").font(.largeTitle)
    //                }
    //                ForEach(users) { user in
    //                    Text("\(user.name)").font(.title)
    //                }
    //            }
                // Dynamic list
                List(users) { user in
                    Text("\(user.name)").font(.title)
                }
                // Stack list
                List {
                    Section(header: Text("Header")) {
                        ForEach(users) { user in
                            Text("\(user.name)")
                                .font(.title)
                        }
                    }
                    Text("LOL")
                    
                    ForEach(users) { user in
                        Text("\(user.name)")
                            .font(.title)
                    }
                    Text("LOL2")
                    Button("Button") {
                        // do stuff
                    }
                    Text("LOL3")
                }
            }.navigationBarTitle("SwiftUI Tour")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
