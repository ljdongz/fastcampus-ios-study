//
//  TodoViewModel.swift
//  voiceMemo
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var title: String
    @Published var time: Date
    @Published var date: Date
    @Published var isDisplayCalendar: Bool
    
    init(
        title: String = "",
        time: Date = Date(),
        date: Date = Date(),
        isDisplayCalendar: Bool = false
    ) {
        self.title = title
        self.time = time
        self.date = date
        self.isDisplayCalendar = isDisplayCalendar
    }
}

extension TodoViewModel {
    func setIsDisplayCalendar(_ isDisplay: Bool) {
        isDisplayCalendar = isDisplay
    }
}
