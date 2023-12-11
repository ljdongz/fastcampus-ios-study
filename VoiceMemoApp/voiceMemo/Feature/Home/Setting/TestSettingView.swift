//
//  TestSettingView.swift
//  voiceMemo
//
//  Created by 이정동 on 12/10/23.
//

import SwiftUI

struct TestSettingView: View {
    var body: some View {
        VStack {
            // 타이틀 뷰
            TitleView()
            
            // 탭 카운트 뷰
            TotalTabCountView()
                .padding(.vertical, 50)
            
            Divider()
            
            // 네비게이션 뷰
            MenuNavigationView()
            
            Divider()
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 종합 탭 카운트 뷰
private struct TotalTabCountView: View {
    
    fileprivate var body: some View {
        HStack {
            Spacer()
            TabCountView(title: "To do")
            Spacer()
            TabCountView(title: "메모")
            Spacer()
            TabCountView(title: "음성메모")
            Spacer()
        }
    }
}

// MARK: - 탭 카운트 뷰
private struct TabCountView: View {
    private var title: String
    
    init(title: String) {
        self.title = title
    }
    
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.system(size: 14))
            
            Text("\(10)")
                .font(.system(size: 30, weight: .medium))
        }
    }
}

// MARK: - 메뉴 네비게이션 뷰
private struct MenuNavigationView: View {
    
    fileprivate var body: some View {
        VStack {
            MenuView(title: "To do 리스트") {}
            MenuView(title: "메모") {}
            MenuView(title: "음성메모") {}
            MenuView(title: "타이머") {}
        }
    }
}

// MARK: - 메뉴 뷰
private struct MenuView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(title: String, tabAction: @escaping () -> Void) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button(
            action: { tabAction() },
            label: {
                HStack {
                    Text(title)
                    Spacer()
                    Image("arrowRight")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.customIconGray)
                }
        })
        .font(.system(size: 16, weight: .medium))
        .foregroundStyle(Color.customBlack)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        
    }
}

#Preview {
    TestSettingView()
}
