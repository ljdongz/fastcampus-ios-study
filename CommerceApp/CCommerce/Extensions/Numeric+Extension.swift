//
//  Numeric+Extension.swift
//  CCommerce
//
//  Created by 이정동 on 1/13/24.
//

import Foundation

extension Numeric {
    var moneyString: String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return (formatter.string(for: self) ?? "") + "원"
    }
}
