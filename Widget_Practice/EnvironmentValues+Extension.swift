//
//  EnvironmentValues+Extension.swift
//  Widget_Practice
//
//  Created by 최주리 on 8/1/24.
//

import SwiftUI

extension EnvironmentValues {
    var deepLinkText: String {
        get { self[DeepLink.self] }
        set { self[DeepLink.self] = newValue }
    }
}
