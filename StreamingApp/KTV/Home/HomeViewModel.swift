//
//  HomeViewModel.swift
//  KTV
//
//  Created by 이정동 on 12/19/23.
//

import Foundation

@MainActor class HomeViewModel {
    private(set) var home: Home?
    var dataChanged: (() -> Void)?
    
    func requestData() {
        Task {
            do {
//                let home = try await DataLoader.load(url: URLDefines.home, for: Home.self)
                let home = try DataLoader.load(json:"home", for: Home.self)
                self.home = home
                //self.recommendViewModel.recommends = home.recommends
                self.dataChanged?()
            } catch {
                print("json parsing failed: \(error.localizedDescription)")
            }
        }
    }
}
