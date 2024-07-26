//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by 최주리 on 7/26/24.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetLiveActivity()
    }
}
