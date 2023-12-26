//
//  HomeRecommendViewModel.swift
//  KTV
//
//  Created by 이정동 on 12/26/23.
//

import Foundation

class HomeRecommendViewModel {
    private(set) var isFolded: Bool = true {
        didSet {
            self.foldChanged?(self.isFolded)
        }
    }
    
    var foldChanged: ((Bool) -> Void)?
    var recommends: [Home.Recommend]?
    var itemCount: Int {
        let count = self.isFolded ? 5 : self.recommends?.count ?? 0
        //return min(self.recommends?.count ?? 0, count)
        return count
    }
    
    func toggleFoldState() {
        self.isFolded.toggle()
    }
}
