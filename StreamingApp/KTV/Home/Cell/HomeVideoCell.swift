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
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubtitleLabel: UILabel!
    
    private var thumbnailTask: Task<Void, Never>?
    private var channelThumbnailTask: Task<Void, Never>?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailTask?.cancel()
        self.thumbnailTask = nil
        self.channelThumbnailTask?.cancel()
        self.channelThumbnailTask = nil
        
        self.thumbnailImageView.image = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
        self.channelTitleLabel.text = nil
        self.channelImageView.image = nil
        self.channelSubtitleLabel.text = nil
    }
    
    
    func setData(_ data: Home.Video) {
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
        self.channelTitleLabel.text = data.channel
        self.channelSubtitleLabel.text = data.channelDescription
        self.hotImageView.isHidden = !data.isHot
        self.thumbnailTask = .init(
            operation: {
                guard
                    let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0
                else {
                    return
                }
                
                self.thumbnailImageView.image = UIImage(data: responseData)
            }
        )
        self.channelThumbnailTask = .init(
            operation: {
                guard
                    let responseData = try? await URLSession.shared.data(for: .init(url: data.channelThumbnailURL)).0
                else {
                    return
                }
                
                self.thumbnailImageView.image = UIImage(data: responseData)
            }
        )
    }
}
