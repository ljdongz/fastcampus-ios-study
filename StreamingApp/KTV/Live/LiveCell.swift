//
//  LiveCell.swift
//  KTV
//
//  Created by 이정동 on 12/31/23.
//

import UIKit

class LiveCell: UICollectionViewCell {
    
    static let height: CGFloat = 76
    static let identifier = "LiveCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.liveLabel.layer.cornerRadius = 5
        self.liveLabel.clipsToBounds = true
        self.imageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageTask?.cancel()
        self.imageTask = nil
        self.imageView.image = nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }

    func setData(_ data: Live.Item) {
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.channel
        self.imageTask = self.imageView.loadImage(url: data.thumbnailUrl)
    }
}
