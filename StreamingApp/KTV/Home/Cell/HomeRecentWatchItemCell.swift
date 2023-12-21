//
//  HomeRecentWatchItemCell.swift
//  KTV
//
//  Created by 이정동 on 12/21/23.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    static let identifier = "HomeRecentWatchItemCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.thumbnailImageView.layer.cornerRadius = 42
        self.thumbnailImageView.layer.borderColor = UIColor(resource: .strokeLight).cgColor
        self.thumbnailImageView.layer.borderWidth = 2
        self.thumbnailImageView.clipsToBounds = true
    }

}
