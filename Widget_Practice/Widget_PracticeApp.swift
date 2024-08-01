//
//  Widget_PracticeApp.swift
//  Widget_Practice
//
//  Created by 최주리 on 7/26/24.
//

import SwiftUI

@main
struct Widget_PracticeApp: App {
    @State var text: String = ""
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.deepLinkText, text)
                .onOpenURL { url in
                    text = url.absoluteString.removingPercentEncoding ?? ""
                }
        }
    }
}
