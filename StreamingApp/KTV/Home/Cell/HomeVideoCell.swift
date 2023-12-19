//
//  HomeVideoTableViewCell.swift
//  KTV
//
//  Created by 이정동 on 12/18/23.
//

import UIKit

class HomeVideoCell: UITableViewCell {
    
    static let identifier = "HomeVideoCell"
    static let height: CGFloat = 320
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor(resource: .strokeLight).cgColor
        self.containerView.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
