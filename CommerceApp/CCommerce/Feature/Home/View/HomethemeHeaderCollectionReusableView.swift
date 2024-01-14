//
//  HomethemeHeaderCollectionReusableView.swift
//  CCommerce
//
//  Created by 이정동 on 1/14/24.
//

import UIKit

struct HomethemeHeaderCollectionReusableViewModel {
    var headerText: String
}

final class HomethemeHeaderCollectionReusableView: UICollectionReusableView {
    static let reusableId = "HomethemeHeaderCollectionReusableView"
    
    @IBOutlet weak var themeHeaderLabel: UILabel!
    
    func setViewModel(_ viewModel: HomethemeHeaderCollectionReusableViewModel) {
        themeHeaderLabel.text = viewModel.headerText
    }
}
