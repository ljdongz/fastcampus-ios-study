//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by 이정동 on 12/19/23.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {
    
    static let identifier = "HomeRecommendItemCell"
    static let height: CGFloat = 71

    @IBOutlet weak var thumbnailContainerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var playTimeBGView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailContainerView.layer.cornerRadius = 5
        self.thumbnailContainerView.clipsToBounds = true
        self.rankLabel.layer.cornerRadius = 5
        self.rankLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setData(_ data: VideoListItem, rank: Int?) {
        self.rankLabel.isHidden = rank == nil
        if let rank {
            self.rankLabel.text = "\(rank)"
        }
        self.playTimeLabel.text = DateComponentsFormatter.timeFormatter.string(from: data.playtime)
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.channel
        self.imageTask = thumbnailImageView.loadImage(url: data.imageUrl)
    }
    
}
