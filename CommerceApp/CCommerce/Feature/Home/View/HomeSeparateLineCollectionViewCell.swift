//
//  HomeSeparateLineCollectionViewCell.swift
//  CCommerce
//
//  Created by 이정동 on 1/14/24.
//

import UIKit

struct HomeSeparateLineCollectionViewCellViewModel: Hashable {
}

class HomeSeparateLineCollectionViewCell: UICollectionViewCell {
    static let reusableId = "HomeSeparateLineCollectionViewCell"
    
    func setViewModel(_ viewModel: HomeSeparateLineCollectionViewCellViewModel) {
        contentView.backgroundColor = CPColor.UIKit.gray1
    }
}

extension HomeSeparateLineCollectionViewCell {
    static func separateLineLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(11)
        )
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        return section
    }
}
