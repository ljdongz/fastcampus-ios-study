//
//  DIContainer.swift
//  LMessenger
//
//  Created by 이정동 on 1/4/24.
//

import Foundation

class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
