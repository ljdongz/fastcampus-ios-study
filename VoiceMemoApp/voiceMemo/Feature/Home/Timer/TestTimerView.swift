//
//  TestTimerView.swift
//  voiceMemo
//
//  Created by 이정동 on 12/7/23.
//

import SwiftUI

struct TestTimerView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                isDisplayLeftButton: false,
                isDisplayRightButton: false
            )
            
            if timerViewModel.isDisplaySetTimeView {
                // 타이머 세팅 화면
                TimerSettingView(timerViewModel: timerViewModel)
            } else {
                // 타이머 작동 화면
                TimerOperationView(timerViewModel: timerViewModel)
            }
        }
        
    }
}

// MARK: - 타이머 세팅 뷰
private struct TimerSettingView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        ZStack {
            // 타이틀 뷰
            VStack {
                TitleView()
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            VStack {
                // 타임 피커 뷰
                TimePickerView(timerViewModel: timerViewModel)
                    .padding(.bottom, 50)
                
                // 세팅 버튼 뷰
                TimerSettingButtonView(timerViewModel: timerViewModel)
            }
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("타이머")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.customBlack)
            Spacer()
        }
    }
}

// MARK: - 타임 피커 뷰
private struct TimePickerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Divider()
            
            HStack {
                Picker("Hours", selection: $timerViewModel.time.hours) {
                    ForEach(0..<24) { hour in
                        Text(String(format: "%02d", hour))
                    }
                }
                Text(" : ")
                Picker("Minuts", selection: $timerViewModel.time.minuts) {
                    ForEach(0..<60) { minute in
                        Text(String(format: "%02d", minute))
                    }
                }
                Text(" : ")
                Picker("Seconds", selection: $timerViewModel.time.seconds) {
                    ForEach(0..<60) { second in
                        Text(String(format: "%02d", second))
                    }
                }
            }
            .font(.system(size: 20))
            .foregroundStyle(Color.customBlack)
            .pickerStyle(.wheel)
            
            Divider()
        }
    }
}

// MARK: - 타이머 설정 버튼 뷰
private struct TimerSettingButtonView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        HStack {
            Button(
                action: {
                    timerViewModel.settingButtonTapped()
                },
                label: {
                    Text("설정하기")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.customGreen)
            })
        }
    }
}

// MARK: - 타이머 작동 화면
private struct TimerOperationView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 타이머 원형 뷰
            TimerCircleView(timerViewModel: timerViewModel)
            
            Spacer()
                .frame(height: 50)
            
            // 타이머 작동 버튼 뷰
            TimerOperationButtonView(timerViewModel: timerViewModel)
        }
    }
}

// MARK: - 타이머 원형 뷰
private struct TimerCircleView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        ZStack {
            Circle()
                .stroke(Color.customOrange, lineWidth: 6)
                .frame(width: 300, height: 300)
            
            VStack(spacing: 15) {
                Text("\(timerViewModel.timeRemaining.formattedTimeString)")
                    .font(.system(size: 40))
                HStack {
                    Image(systemName: "bell.fill")
                    Text("\(timerViewModel.timeRemaining.formattedSettingTime)")
                }
            }
        }
    }
}

// MARK: - 타이머 작동 버튼 뷰
private struct TimerOperationButtonView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        HStack {
            Button(
                action: {
                    timerViewModel.cancelButtonTapped()
                },
                label: {
                    Text("취소")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.black)
                        .frame(width: 70, height: 70)
                        .background(
                            Circle().fill(Color.customGray2.opacity(0.3))
                        )
            })
            
            Spacer()
            
            Button(
                action: {
                    timerViewModel.pauseOrRestartButtonTapped()
                },
                label: {
                    Text(timerViewModel.isPaused ? "재생" : "일시정지")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.black)
                        .frame(width: 70, height: 70)
                        .background(
                            Circle().fill(Color.customOrange.opacity(0.3))
                        )
            })
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    TestTimerView()
}
