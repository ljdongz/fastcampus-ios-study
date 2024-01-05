//
//  AuthenticatedViewModel.swift
//  LMessenger
//
//  Created by 이정동 on 1/4/24.
//

import Foundation
import Combine

// 인증 상태
enum AuthenticationState {
    case unauthenticated // 비인증
    case authenticated // 인증
}

class AuthenticatedViewModel: ObservableObject {
    
    enum Action {
        case googleLogin
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    var userId: String?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .googleLogin:
            container.services.authService.signInWithGoogle()
                .sink { completion in
                    // TODO:
                } receiveValue: { user in
                    self.userId = user.id
                }.store(in: &subscriptions)
        }
    }
}
