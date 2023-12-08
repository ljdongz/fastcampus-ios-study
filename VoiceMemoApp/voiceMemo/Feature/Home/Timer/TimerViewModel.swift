//
//  TimerViewModel.swift
//  voiceMemo
//

import Foundation
import UIKit

class TimerViewModel: ObservableObject {
    @Published var isDisplaySetTimeView: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    var notificationService: NotificationService
    
    init(
        isDisplaySetTimeView: Bool = true,
        time: Time = .init(hours: 0, minuts: 0, seconds: 0),
        timer: Timer? = nil,
        timeRemaining: Int = 0,
        isPaused: Bool = false,
        notificationService: NotificationService = .init()
    ) {
        self.isDisplaySetTimeView = isDisplaySetTimeView
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.notificationService = notificationService
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
        
        // 백 그라운드 상태에서 Notification 작업을 수행할 수 있도록 backgroundTaskID 설정
        var backgroundTaskID: UIBackgroundTaskIdentifier?
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            // 기존 backgroundTaskID가 설정되있다면 해제
            if let task = backgroundTaskID {
                UIApplication.shared.endBackgroundTask(task)
                backgroundTaskID = .invalid
            }
        }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true, 
            block: { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.stopTimer()
                    self.notificationService.sendNotification()
                    
                    if let task = backgroundTaskID {
                        UIApplication.shared.endBackgroundTask(task)
                        backgroundTaskID = .invalid
                    }
                }
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
