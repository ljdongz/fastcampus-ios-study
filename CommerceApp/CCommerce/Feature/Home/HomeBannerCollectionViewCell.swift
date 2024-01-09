//
//  HomeBannerCollectionViewCell.swift
//  CCommerce
//
//  Created by 이정동 on 1/8/24.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
