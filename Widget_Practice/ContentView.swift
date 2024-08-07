//
//  ContentView.swift
//  Widget_Practice
//
//  Created by 최주리 on 7/26/24.
//

import ActivityKit
import SwiftUI

struct ContentView: View {
//    @Environment(\.deepLinkText) var deepLinkText: String
    
    var body: some View {
//        VStack {
//            if deepLinkText.isEmpty {
//                Text("hello world")
//            } else {
//                Text(deepLinkText)
//            }
//        }
//        .padding()
        
        VStack {
            Button("start") {
                print("tapped")
                let dynamicIslandWidgetAttributes = MyWidgetAttributes(name: "test")
                let contentState = MyWidgetAttributes.ContentState(emoji: "😎")
                
                do {
                    let activity = try Activity<MyWidgetAttributes>.request(
                        attributes: dynamicIslandWidgetAttributes,
                        contentState: contentState)
                    print(activity)
                } catch {
                    print(error)
                }
            }
            
            Button("test") {
                print("test")
            }
        }
        .onAppear {
            print("onAppear")
        }
    }
}

#Preview {
    ContentView()
}
