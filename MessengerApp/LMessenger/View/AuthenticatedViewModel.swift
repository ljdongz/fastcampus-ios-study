//
//  AuthenticatedViewModel.swift
//  LMessenger
//
//  Created by 이정동 on 1/4/24.
//

import Foundation

// 인증 상태
enum AuthenticationState {
    case unauthenticated // 비인증
    case authenticated // 인증
}

class AuthenticatedViewModel: ObservableObject {
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
