//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by 이정동 on 12/21/23.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
    
    static let identifier = "HomeRankingItemCell"
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rankLabel.text = nil
    }

    func setRank(_ rank: Int) {
        self.rankLabel.text = "\(rank)"
    }
}
