//
//  SettingView.swift
//  voiceMemo
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                isDisplayLeftButton: false,
                isDisplayRightButton: false
            )
            
            // 타이틀 뷰
            TitleView()
            
            Spacer()
                .frame(height: 35)
            
            // 총 탭 카운트 뷰
            TotalTabCountView()
            
            Spacer()
                .frame(height: 40)
            
            // 탭 네비게이션 뷰
            TotalTabNavigationView()
            
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

// MARK: - 전테 탭 카운트 뷰
private struct TotalTabCountView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    fileprivate var body: some View {
        HStack {
            Spacer()
            TabCountView(title: "To do", count: homeViewModel.todosCount)
            Spacer()
                .frame(width: 70)
            TabCountView(title: "메모", count: homeViewModel.memosCount)
            Spacer()
                .frame(width: 70)
            TabCountView(title: "음성메모", count: homeViewModel.voiceRecordersCount)
            Spacer()
        }
        
    }
}

// MARK: - 각 탭 카운트 뷰
private struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(Color.customBlack)
            
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(Color.customBlack)
        }
    }
}

// MARK: - 전체 탭 이동 뷰
private struct TotalTabNavigationView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    fileprivate var body: some View {
        VStack {
            Divider()
            
            TabNavigationView(title: "To do List") {
                homeViewModel.changeSelectedTab(.todoList)
            }
            
            TabNavigationView(title: "메모장") {
                homeViewModel.changeSelectedTab(.memo)
            }
            
            TabNavigationView(title: "음성메모") {
                homeViewModel.changeSelectedTab(.voiceRecorder)
            }
            
            TabNavigationView(title: "타이머") {
                homeViewModel.changeSelectedTab(.timer)
            }
            
            Divider()
        }
    }
}

// MARK: - 탭 이동 뷰
private struct TabNavigationView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(title: String, tabAction: @escaping () -> Void) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button(
            action: {
                tabAction()
            },
            label: {
                HStack {
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.customBlack)

                    Spacer()
                    
                    Image("arrowRight")
                }
        })
        .padding(20)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(HomeViewModel())
    }
}
