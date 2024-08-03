//
//  PhotoModel.swift
//  Widget_Practice
//
//  Created by 최주리 on 8/3/24.
//

import Foundation

struct PhotoModel: Decodable {
    let items: [Item]
    
    struct Item: Decodable {
        let media: Media
    }
    
    struct Media: Decodable {
        let m: String
    }
}
