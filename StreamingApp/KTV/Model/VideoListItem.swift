//
//  VideoListItem.swift
//  KTV
//
//  Created by 이정동 on 12/27/23.
//

import Foundation

struct VideoListItem: Decodable {
    let imageUrl: URL
    let title: String
    let playtime: Double
    let channel: String
    let videoId: Int
}
