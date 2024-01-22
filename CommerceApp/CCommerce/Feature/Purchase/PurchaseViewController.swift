//
//  PurchaseViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/18/24.
//

import UIKit
import Combine

final class PurchaseViewController: UIViewController {
    
    
    private var viewModel = PurchaseViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var rootView: PurchaseRootView = {
        let view = PurchaseRootView()
        return view
    }()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .wh
        bindViewModel()
        viewModel.process(.loadData)
    }
    
    
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let viewModels = self?.viewModel.state.purchaseItems else { return }
                self?.rootView.setPurchaseItem(viewModels)
            }.store(in: &cancellables)
        
        viewModel.showPaymentViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let vc = PaymentViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cancellables)
    }
    
}

#Preview {
    PurchaseViewController()
}
