//
//  ContentView.swift
//  Widget_Practice
//
//  Created by 최주리 on 7/26/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.deepLinkText) var deepLinkText: String
    
    var body: some View {
        VStack {
            if deepLinkText.isEmpty {
                Text("hello world")
            } else {
                Text(deepLinkText)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
