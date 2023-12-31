//
//  TimerView.swift
//  voiceMemo
//

import SwiftUI

struct TimerView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                isDisplayLeftButton: false,
                isDisplayRightButton: false
            )
            
            if timerViewModel.isDisplaySetTimeView {
                // 타이머 설정 화면
                TimerSettingView(timerViewModel: timerViewModel)
            } else {
                // 타이머 작동 뷰
                TimerOperationView(timerViewModel: timerViewModel)
            }
        }
        
    }
}

// MARK: - 타이머 설정 뷰
private struct TimerSettingView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 타이틀
            TitleView()
            
            Spacer()
                .frame(height: 50)
            
            // 타이머 피커 뷰
            TimePickerView(timerViewModel: timerViewModel)
                .padding(.top, 50)
            
            // 설정하기 버튼 뷰
            TimerCreateButtonView(timerViewModel: timerViewModel)
            
            Spacer()
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
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 타이머 피커 뷰
private struct TimePickerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Divider()
            
            HStack {
                Picker("Hour", selection: $timerViewModel.time.hours) {
                    ForEach(0..<24) { hour in
                        Text("\(String(format: "%02d", hour))")
                    }
                }
                
                Text(" : ")
                
                Picker("Minute", selection: $timerViewModel.time.minuts) {
                    ForEach(0..<60) { minute in
                        Text("\(String(format: "%02d", minute))")
                    }
                }
                
                Text(" : ")
                
                Picker("Second", selection: $timerViewModel.time.seconds) {
                    ForEach(0..<60) { second in
                        Text("\(String(format: "%02d", second))")
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            
            Divider()
        }
    }
}

// MARK: - 타이머 생성 버튼 뷰
private struct TimerCreateButtonView: View {
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
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.customGreen)
            })
        }
        .padding(.vertical, 30)
    }
}

// MARK: - 타이머 작동 뷰
private struct TimerOperationView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            TimerCircleView(timerViewModel: timerViewModel)
            
            Spacer()
                .frame(height: 10)
            
            TimerOperationButtonView(timerViewModel: timerViewModel)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 타이머 원형 뷰
private struct TimerCircleView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("\(timerViewModel.timeRemaining.formattedTimeString)")
                    .font(.system(size: 28))
                    .foregroundStyle(Color.customBlack)
                    .monospaced()
                
                HStack(alignment: .bottom) {
                    Image(systemName: "bell.fill")
                    
                    Text("\(timerViewModel.timeRemaining.formattedSettingTime)")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.customBlack)
                        .padding(.top, 10)
                }
            }
            
            Circle()
                .stroke(Color.customOrange, lineWidth: 6)
                .frame(width: 350)
        }
    }
}

// MARK: - 타이머 작동 버튼 화면
private struct TimerOperationButtonView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    var body: some View {
        HStack {
            Button(
                action: {
                    timerViewModel.cancelButtonTapped()
                },
                label: {
                    Text("취소")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.customBlack)
                    //                            .padding(.vertical, 25)
                    //                            .padding(.horizontal, 22)
                        .frame(width: 70, height: 70)
                        .background(
                            Circle()
                                .fill(Color.customGray2.opacity(0.3))
                        )
                })
            
            Spacer()
            
            Button(
                action: {
                    timerViewModel.pauseOrRestartButtonTapped()
                },
                label: {
                    Text(timerViewModel.isPaused ? "계속 진행" : "일시 정지")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.customBlack)
                    //                            .padding(.vertical, 25)
                    //                            .padding(.horizontal, 7)
                        .frame(width: 70, height: 70)
                        .background(
                            Circle()
                                .fill(Color.customOrange.opacity(0.3))
                        )
                })
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}




