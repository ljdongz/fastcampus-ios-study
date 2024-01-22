//
//  PurchaseViewModel.swift
//  CCommerce
//
//  Created by 이정동 on 1/18/24.
//

import Foundation
import Combine

final class PurchaseViewModel: ObservableObject {
    enum Action {
        case loadData
        case didTapPurchaseButton
    }
    
    struct State {
        var purchaseItems: [PurchaseSelectedItemViewModel]?
    }
    
    @Published private(set) var state = State()
    
    private(set) var showPaymentViewController = PassthroughSubject<Void, Never>()
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            Task { await loadData() }
        case .didTapPurchaseButton:
            Task { await didTapPurchaseButton() }
        }
    }
}

extension PurchaseViewModel {
    @MainActor
    private func loadData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.state.purchaseItems = [
                PurchaseSelectedItemViewModel(title: "플스1", description: "수량 1개 / 무료 배송"),
                PurchaseSelectedItemViewModel(title: "플스2", description: "수량 1개 / 무료 배송"),
                PurchaseSelectedItemViewModel(title: "플스3", description: "수량 1개 / 무료 배송"),
                PurchaseSelectedItemViewModel(title: "플스4", description: "수량 1개 / 무료 배송"),
                PurchaseSelectedItemViewModel(title: "플스5", description: "수량 1개 / 무료 배송"),
                PurchaseSelectedItemViewModel(title: "플스6", description: "수량 1개 / 무료 배송"),
            ]
        }
    }
    
    @MainActor
    private func didTapPurchaseButton() async {
        showPaymentViewController.send()
    }
}
