//
//  ImageCache.swift
//  Widget_Practice
//
//  Created by 최주리 on 8/3/24.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
