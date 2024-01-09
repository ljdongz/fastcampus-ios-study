//
//  HomeBannerCollectionViewCell.swift
//  CCommerce
//
//  Created by 이정동 on 1/8/24.
//

import UIKit

struct HomeBannerCollectionViewCellViewModel: Hashable {
    let bannerImage: UIImage
    
    
}

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func setViewModel(_ viewModel: HomeBannerCollectionViewCellViewModel) {
        self.imageView.image = viewModel.bannerImage
    }
}
