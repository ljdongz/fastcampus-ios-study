//
//  DetailViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/18/24.
//

import UIKit
import SwiftUI
import Combine

class DetailViewController: UIViewController {
    
    let viewModel: DetailViewModel = DetailViewModel()
    
    lazy var rootView = UIHostingController(rootView: DetailRootView(viewModel: viewModel))
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        addRootView()
        bindViewModelAction()
    }
    

    private func addRootView() {
        addChild(rootView)
        view.addSubview(rootView.view)
        
        rootView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootView.view.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModelAction() {
        viewModel.showOptionViweController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let vc = OptionViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cancellables)
        
        viewModel.showPurchaseViweController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let vc = PurchaseViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cancellables)
    }

}
