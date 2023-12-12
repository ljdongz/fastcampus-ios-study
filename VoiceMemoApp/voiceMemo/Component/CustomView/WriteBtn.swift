//
//  WriteBtn.swift
//  voiceMemo
//
//

import SwiftUI

// MARK: - 1. ViewModifier 프로토콜 채택
public struct WriteButtonViewModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(
                        action: action,
                        label: {
                            Image("writeBtn")
                    })
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 2. View 확장
extension View {
    public func writeButton(perform action: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(
                        action: action,
                        label: {
                            Image("writeBtn")
                    })
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 3. 새로운 View 생성
public struct WriteButtonView<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(
                        action: action,
                        label: {
                            Image("writeBtn")
                    })
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}
