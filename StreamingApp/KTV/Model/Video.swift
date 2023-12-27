//
//  Video.swift
//  KTV
//
//  Created by 이정동 on 12/27/23.
//

import Foundation

struct Video: Decodable {
    let videoId: Int
    let videoURL: URL
    let title: String
    let uploadTimestamp: TimeInterval
    let playCount: Int
    let favoriteCount: Int
    let channelImageUrl: URL
    let channel: String
    let channelId: Int
    let recommends: [VideoListItem]
}
