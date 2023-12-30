//
//  DateComponentsFormatter+Ext.swift
//  KTV
//
//  Created by 이정동 on 12/29/23.
//

import Foundation

extension DateComponentsFormatter {
    static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
}
