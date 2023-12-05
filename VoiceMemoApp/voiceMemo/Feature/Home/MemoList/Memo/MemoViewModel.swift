//
//  MemoViewModel.swift
//  voiceMemo
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    @Published var isDisplayRemoveMemoAlert: Bool
    
    init(
        memo: Memo = Memo(title: "", content: "", date: Date()),
        isDisplayRemoveMemoAlert: Bool = false
    ) {
        self.memo = memo
        self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
    }
}

extension MemoViewModel {
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
        self.isDisplayRemoveMemoAlert = isDisplay
    }
}
