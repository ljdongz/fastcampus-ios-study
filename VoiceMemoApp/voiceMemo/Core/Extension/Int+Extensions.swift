//
//  Int+Extensions.swift
//  voiceMemo
//

import Foundation

extension Int {
    /// 타이머 총 시간을 hh : mm : ss 문자열로 변환
    var formattedTimeString: String {
        let hours = self / 3600
        let minuts = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        let hoursString = String(format: "%02d", hours)
        let minutsString = String(format: "%02d", minuts)
        let secondsString = String(format: "%02d", seconds)
        
        return "\(hoursString) : \(minutsString) : \(secondsString)"
    }
    
    /// 타이머가 종료되는 시각
    var formattedSettingTime: String {
        let currentDate = Date()
        let settingDate = currentDate.addingTimeInterval(TimeInterval(self))
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "HH:mm"
        
        let formattedTime = formatter.string(from: settingDate)
        return formattedTime
    }
}
