//
//  MoreTableViewCell.swift
//  KTV
//
//  Created by 이정동 on 12/27/23.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    
    static let identifier = "MoreTableViewCell"
    static let height: CGFloat = 48

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.titleLabel.text = nil
        self.rightTextLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(_ item: MoreItem, separatorHidden: Bool) {
        self.titleLabel.text = item.title
        self.rightTextLabel.text = item.rightText
        self.separatorView.isHidden = separatorHidden
    }
    
}
