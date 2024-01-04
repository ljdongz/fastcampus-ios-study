//
//  Service.swift
//  LMessenger
//
//  Created by 이정동 on 1/4/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    
    init() {
        self.authService = AuthenticationService()
    }
}

// Test용 StubService
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
}
