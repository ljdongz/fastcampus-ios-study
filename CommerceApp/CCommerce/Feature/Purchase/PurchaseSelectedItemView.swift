//
//  PurchaseSelectedItemView.swift
//  CCommerce
//
//  Created by 이정동 on 1/18/24.
//

import UIKit

struct PurchaseSelectedItemViewModel {
    var title: String
    var description: String
}

final class PurchaseSelectedItemView: UIView {
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = CPFont.UIKit.regular12
        view.textColor = .bk
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = CPFont.UIKit.regular12
        view.textColor = .gray5
        return view
    }()
    
    private var contentStackViewConstraints: [NSLayoutConstraint]?

    var viewModel: PurchaseSelectedItemViewModel
    
    init(viewModel: PurchaseSelectedItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        commonInit()
        setViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if contentStackViewConstraints == nil {
            let constraints = [
                contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            ]
            NSLayoutConstraint.activate(constraints)
            contentStackViewConstraints = constraints
        }
        
        super.updateConstraints()
    }
    
    private func commonInit() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        
        setBorder()
    }
    
    private func setBorder() {
        layer.borderColor = UIColor.gray0.cgColor
        layer.borderWidth = 1
    }
    
    private func setViewModel() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

#Preview {
    PurchaseSelectedItemView(viewModel: PurchaseSelectedItemViewModel(title: "TEst", description: "Test"))
}
