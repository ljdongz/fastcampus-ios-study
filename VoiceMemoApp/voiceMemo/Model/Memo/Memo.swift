//
//  Memo.swift
//  voiceMemo
//

import Foundation

struct Memo: Hashable {
    var title: String
    var content: String
    var date: Date
    var isRemoveSelected: Bool = false
    var id = UUID()
    
    var convertedDate: String {
        String("\(date.formattedDay) - \(date.formattedTime)")
    }
}
