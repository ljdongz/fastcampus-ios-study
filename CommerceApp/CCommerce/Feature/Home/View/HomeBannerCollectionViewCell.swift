//
//  HomeBannerCollectionViewCell.swift
//  CCommerce
//
//  Created by 이정동 on 1/8/24.
//

import UIKit
import Kingfisher

struct HomeBannerCollectionViewCellViewModel: Hashable {
    let bannerImageUrl: String
}

class HomeBannerCollectionViewCell: UICollectionViewCell {
    static let reusableId = "HomeBannerCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setViewModel(_ viewModel: HomeBannerCollectionViewCellViewModel) {
        self.imageView.kf.setImage(with: URL(string: viewModel.bannerImageUrl))
    }
}

extension HomeBannerCollectionViewCell {
    static func bannerLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(165 / 393)
        )
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
