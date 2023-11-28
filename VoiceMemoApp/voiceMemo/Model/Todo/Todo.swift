//
//  Todo.swift
//  voiceMemo
//

import Foundation

struct Todo: Hashable {
    
    var title: String
    var time: Date
    var day: Date
    var isSelected: Bool

    
    /// ex 1) 오늘 - 오후 03:00에 알림
    /// ex 2) M월 dd일 E요일 - 오전 03:00에 알림
    var convertedDayAndTime: String {
        String("\(day.formattedDay) - \(time.formattedTime)에 알림")
    }
}
