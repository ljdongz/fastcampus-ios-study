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
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailContainerView.layer.cornerRadius = 5
        self.thumbnailContainerView.clipsToBounds = true
        self.rankLabel.layer.cornerRadius = 5
        self.rankLabel.clipsToBounds = true
        
        self.playTimeBGView.backgroundColor = .clear
        self.playTimeLabel.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setData(_ data: Home.Recommend, rank: Int?) {
        self.rankLabel.isHidden = rank == nil
        if let rank {
            self.rankLabel.text = "\(rank)"
        }
        self.playTimeLabel.text = Self.timeFormatter.string(from: data.playtime)
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.channel
        self.imageTask = .init(
            operation: {
                guard let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0
                else { return }
                self.thumbnailImageView.image = UIImage(data: responseData)
            }
            
        )
    }
    
}
