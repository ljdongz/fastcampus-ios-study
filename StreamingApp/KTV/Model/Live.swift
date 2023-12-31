//
//  Live.swift
//  KTV
//
//  Created by 이정동 on 12/31/23.
//

import Foundation

struct Live: Decodable {
    let list: [Item]
}

extension Live {
    struct Item: Decodable {
        let videoId: Int
        let thumbnailUrl: URL
        let title: String
        let channel: String
    }
}
