//
//  OptionViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/18/24.
//

import UIKit
import SwiftUI

final class OptionViewController: UIViewController {

    let viewModel: OptionViewModel = OptionViewModel()
    
    lazy var rootView = UIHostingController(rootView: OptionRootView(viewModel: viewModel))

    override func viewDidLoad() {
        super.viewDidLoad()

        addRootView()
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

}
