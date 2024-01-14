//
//  HomeProductCollectionViewCell.swift
//  CCommerce
//
//  Created by 이정동 on 1/9/24.
//

import UIKit
import Kingfisher

struct HomeProductCollectionViewCellViewModel: Hashable {
    let imageUrlString: String
    let title: String
    let reasonDiscountString: String
    let originalPrice: String
    let discountPrice: String
}

class HomeProductCollectionViewCell: UICollectionViewCell {
    static let reusableId = "HomeProductCollectionViewCell"
    
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productReasonDiscountLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    
    func setViewModel(_ viewModel: HomeProductCollectionViewCellViewModel) {
        productItemImageView.kf.setImage(with: URL(string: viewModel.imageUrlString))
        productTitleLabel.text = viewModel.title
        productReasonDiscountLabel.text = viewModel.reasonDiscountString
        originalPriceLabel.attributedText = NSMutableAttributedString(
            string: viewModel.originalPrice,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        discountPriceLabel.text = viewModel.discountPrice
    }
}

extension HomeProductCollectionViewCell {
    static func horizontalProductItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(
            widthDimension: .absolute(117),
            heightDimension: .estimated(224)
        )
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets  = .init(top: 20, leading: 26, bottom: 0, trailing: 26)
        section.interGroupSpacing = 10
        return section
    }
    
    static func verticalProductItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .estimated(277)
        )
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        
        let groupSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(277)
        )
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .init(top: 0, leading: 7, bottom: 0, trailing: 7)
        group.edgeSpacing = .init(leading: .none, top: .fixed(5), trailing: .none, bottom: .fixed(5))
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 20, leading: 19, bottom: 0, trailing: 19)
        
        return section
    }
}
