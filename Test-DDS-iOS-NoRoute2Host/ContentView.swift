//
//  ContentView.swift
//  Test-DDS-iOS-NoRoute2Host
//
//  Created by Yaoyu Hu on 12/21/23.
//

import SwiftUI

struct ContentView: View {
    var ddsSample = DDSSample(name: "DDSSample", domainID: 0)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
