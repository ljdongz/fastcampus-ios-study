//
//  TimerViewModel.swift
//  voiceMemo
//

import Foundation

class TimerViewModel: ObservableObject {
    @Published var isDisplaySetTimeView: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    
    init(
        isDisplaySetTimeView: Bool = true,
        time: Time = .init(hours: 0, minuts: 0, seconds: 0),
        timer: Timer? = nil,
        timeRemaining: Int = 0,
        isPaused: Bool = false
    ) {
        self.isDisplaySetTimeView = isDisplaySetTimeView
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
    }
}

extension TimerViewModel {
    func settingButtonTapped() {
        isDisplaySetTimeView = false
        timeRemaining = time.convertedSeconds
        
        startTimer()
    }
    
    func cancelButtonTapped() {
        stopTimer()
        isDisplaySetTimeView = true
    }
    
    func pauseOrRestartButtonTapped() {
        if isPaused {
            startTimer()
        } else {
            timer?.invalidate()
            timer = nil
        }
        isPaused.toggle()
    }
}

private extension TimerViewModel {
    func startTimer() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true, 
            block: { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.stopTimer()
                    
                    // TODO: 로컬 알림
                }
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
