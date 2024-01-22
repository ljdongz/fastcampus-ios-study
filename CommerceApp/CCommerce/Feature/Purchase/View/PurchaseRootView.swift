//
//  PurchaseRootView.swift
//  CCommerce
//
//  Created by 이정동 on 1/22/24.
//

import UIKit

final class PurchaseRootView: UIView {
    
    private var scrollViewConstraints: [NSLayoutConstraint]?
    private var titleLabelViewConstraints: [NSLayoutConstraint]?
    private var purchaseItemStackViewConstraints: [NSLayoutConstraint]?
    private var purchaseButtonConstraints: [NSLayoutConstraint]?

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "주문 상품 목록"
        view.font = CPFont.UIKit.medium17
        view.textColor = .bk
        return view
    }()
    
    private lazy var purchaseItemStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 7
        return view
    }()
    
    private lazy var purchaseButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("결제하기", for: .normal)
        view.setTitleColor(.wh, for: .normal)
        view.titleLabel?.font = CPFont.UIKit.medium17
        view.layer.backgroundColor = UIColor.keyColorBlue.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if scrollViewConstraints == nil {
            let constraints = [
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                
                containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
            scrollViewConstraints = constraints
        }
        
        if titleLabelViewConstraints == nil,
           let superView = titleLabel.superview {
            let constraints = [
                titleLabel.topAnchor.constraint(equalTo: superView.topAnchor, constant: 33),
                titleLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 33),
                titleLabel.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -33)
            ]
            NSLayoutConstraint.activate(constraints)
            titleLabelViewConstraints = constraints
        }
        
        if purchaseItemStackViewConstraints == nil,
           let superView = purchaseItemStackView.superview {
            let constraints = [
                purchaseItemStackView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 19),
                purchaseItemStackView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20),
                purchaseItemStackView.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20),
                purchaseItemStackView.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -33)
            ]
            NSLayoutConstraint.activate(constraints)
            purchaseItemStackViewConstraints = constraints
        }
        
        if purchaseButtonConstraints == nil,
           let superView = purchaseButton.superview {
            let constraints = [
                purchaseButton.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20),
                purchaseButton.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20),
                purchaseButton.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -32),
                purchaseButton.heightAnchor.constraint(equalToConstant: 50)
            ]
            NSLayoutConstraint.activate(constraints)
            purchaseButtonConstraints = constraints
        }
        
        super.updateConstraints()
    }
    
    private func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(purchaseItemStackView)
        addSubview(purchaseButton)
    }
    
    func setPurchaseItem(_ viewModels: [PurchaseSelectedItemViewModel]) {
        purchaseItemStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        
        viewModels.forEach({
            purchaseItemStackView.addArrangedSubview(PurchaseSelectedItemView(viewModel: $0))
        })
    }
}
