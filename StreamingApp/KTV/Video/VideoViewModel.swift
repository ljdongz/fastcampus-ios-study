//
//  VideoViewModel.swift
//  KTV
//
//  Created by 이정동 on 12/27/23.
//

import Foundation

@MainActor class VideoViewModel {
    
    private(set) var video: Video?
    var dataChangeHandler: ((Video) -> Void)?
    
    func request() {
        Task {
            do {
                let video = try await DataLoader.load(url: URLDefines.video, for: Video.self)
                self.video = video
                self.dataChangeHandler?(video)
            } catch {
                print("Video Load did failed")
            }
        }
    }
}
