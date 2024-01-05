//
//  TestLoginIntroView.swift
//  LMessenger
//
//  Created by 이정동 on 1/5/24.
//

import SwiftUI

struct TestLoginButton: View {
    let text: String
    let textColor: Color
    let borderColor: Color
    let action: () -> Void
    
    init(
        text: String,
         textColor: Color,
         borderColor: Color? = nil,
         action: @escaping () -> Void
    ) {
        self.text = text
        self.textColor = textColor
        self.borderColor = borderColor ?? textColor
        self.action = action
    }
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1)
                    }
        })
        .padding(.horizontal, 15)
    }
}

#Preview {
    TestLoginButton(
        text: "로그인", 
        textColor: .lineAppColor
    ) {
            
    }
}
