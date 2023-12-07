//
//  Date+Extensions.swift
//  voiceMemo
//

import Foundation

extension Date {
    
    /// 오전/오후 hh:mm으로 표기
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self)
    }
    
    /// 오늘 or M월 d일 E요일로 표기
    var formattedDay: String {
        let now = Date()
        let calendar = Calendar.current
        
        let nowStartOfDay = calendar.startOfDay(for: now)
        let dateStartOfDay = calendar.startOfDay(for: self)
        
        // 두 날짜의 day를 비교
        let numOfDayDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day!
        
        if numOfDayDifference == 0 {
            return "오늘"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
    }
    
    /// yyyy.M.d
    var formattedVoiceRecorderTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d"
        return formatter.string(from: self)
    }
}
