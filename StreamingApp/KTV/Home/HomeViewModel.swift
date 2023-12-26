//
//  HomeViewModel.swift
//  KTV
//
//  Created by 이정동 on 12/19/23.
//

import Foundation

class HomeViewModel {
    private(set) var home: Home?
    var dataChanged: (() -> Void)?
    
    func requestData() {
        guard let jsonUrl = Bundle.main.url(forResource: "home", withExtension: "json")
        else {
            print("resouce not found")
            return
        }
        
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: jsonUrl)
            let home = try jsonDecoder.decode(Home.self, from: data)
            self.home = home
            self.dataChanged?()
        } catch {
            print("json parsing failed")
        }
    }
}
