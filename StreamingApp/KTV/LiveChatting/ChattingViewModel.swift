//
//  ChattingViewModel.swift
//  KTV
//
//  Created by 이정동 on 12/31/23.
//

import Foundation

@MainActor class ChattingViewModel {
    private let chatSimulator = ChatSimulator()
    
    var chatReceived: (() -> Void)?
    private(set) var messages: [ChatMessage] = []
    
    init() {
        self.chatSimulator.setMessageHandler { [weak self] message in
            self?.messages.append(message)
            self?.chatReceived?()
        }
    }
    
    func start() {
        self.chatSimulator.start()
    }
    
    func stop() {
        self.chatSimulator.stop()
    }
    
    func sendMessage(_ message: String) {
        self.chatSimulator.sendMessage(message)
    }
}
