//
//  MemoViewModel.swift
//  voiceMemo
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo = Memo(title: "", content: "", date: Date())) {
        self.memo = memo
    }
}
