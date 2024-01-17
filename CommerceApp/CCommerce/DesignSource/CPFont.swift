//
//  CPFont.swift
//  CCommerce
//
//  Created by 이정동 on 1/6/24.
//

import UIKit
import SwiftUI

enum CPFont {
    
}

extension CPFont {
    enum UIKit {
        static let regular10: UIFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        static let regular12: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let medium12: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let bold12: UIFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        static let regular14: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let bold14: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        static let regular16: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let bold16: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        static let light17: UIFont = UIFont.systemFont(ofSize: 17, weight: .light)
        static let medium17: UIFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        static let bold17: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        static let bold20: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
}

extension CPFont {
    enum SwiftUI {
        static let regular10: Font = Font.system(size: 10, weight: .regular)
        
        static let regular12: Font = Font.system(size: 12, weight: .regular)
        static let medium12: Font = Font.system(size: 12, weight: .medium)
        static let bold12: Font = Font.system(size: 12, weight: .bold)
        
        static let regular14: Font = Font.system(size: 14, weight: .regular)
        static let bold14: Font = Font.system(size: 14, weight: .bold)
        
        static let regular16: Font = Font.system(size: 16, weight: .regular)
        static let bold16: Font = Font.system(size: 16, weight: .bold)
        
        static let light17: Font = Font.system(size: 17, weight: .light)
        static let medium17: Font = Font.system(size: 17, weight: .medium)
        static let bold17: Font = Font.system(size: 17, weight: .bold)
        
        static let bold20: Font = Font.system(size: 20, weight: .bold)
    }
}
