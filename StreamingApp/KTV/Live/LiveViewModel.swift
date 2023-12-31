//
//  LiveViewModel.swift
//  KTV
//
//  Created by 이정동 on 12/31/23.
//

import Foundation

enum LiveSortOption {
    case favorite
    case start
}

@MainActor class LiveViewModel {
    private(set) var items: [Live.Item]?
    private(set) var sortOption: LiveSortOption = .favorite
    var dataChanged: (([Live.Item]) -> Void)?
    
    func request(sort: LiveSortOption) {
        Task {
            do {
                let live = try await DataLoader.load(url: URLDefines.live, for: Live.self)
                if sort == .start {
                    self.items = live.list.reversed()
                } else {
                    self.items = live.list
                }
                self.dataChanged?(self.items ?? [])
            } catch {
                print("Live data load failed")
            }
        }
    }
}
