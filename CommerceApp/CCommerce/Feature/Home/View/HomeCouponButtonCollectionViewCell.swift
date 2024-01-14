//
//  HomeCouponButtonCollectionViewCell.swift
//  CCommerce
//
//  Created by 이정동 on 1/14/24.
//

import UIKit
import Combine

struct HomeCouponButtonCollectionViewCellViewModel: Hashable {
    enum CouponState {
        case enable
        case disable
    }
    
    var state: CouponState
}

final class HomeCouponButtonCollectionViewCell: UICollectionViewCell {
    
    static let reusableId = "HomeCouponButtonCollectionViewCell"
    
    private weak var didTapCouponDownload: PassthroughSubject<Void, Never>?
    
    @IBOutlet weak var couponButton: UIButton! {
        didSet {
            couponButton.setImage(CPImage.buttonActivate, for: .normal)
            couponButton.setImage(CPImage.buttonComplete, for: .disabled)
        }
    }
    
    func setViewModel(
        _ viewModel: HomeCouponButtonCollectionViewCellViewModel,
        _ didTapCouponDownload: PassthroughSubject<Void, Never>?
    ) {
        couponButton.isEnabled = viewModel.state == .enable ? true : false
        self.didTapCouponDownload = didTapCouponDownload
    }
    
    @IBAction private func didTapCouponButton(_ sender: Any) {
        didTapCouponDownload?.send()
    }
}

extension HomeCouponButtonCollectionViewCell {
    static func couponButtonItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(37)
        )
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets  = .init(top: 28, leading: 22, bottom: 0, trailing: 22)
        return section
    }
}
