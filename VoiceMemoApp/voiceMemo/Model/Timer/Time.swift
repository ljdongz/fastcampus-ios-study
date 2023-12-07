//
//  Time.swift
//  voiceMemo
//

import Foundation

struct Time {
    var hours: Int
    var minuts: Int
    var seconds: Int
    
    var convertedSeconds: Int {
        return (hours * 3600) + (minuts * 60) + seconds
    }
}
