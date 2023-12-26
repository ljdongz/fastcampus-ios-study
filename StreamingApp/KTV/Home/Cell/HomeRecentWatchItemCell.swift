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
    
    private var imageTask: Task<Void, Never>?
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYMMDD."
        return formatter
    }()
    
    static let identifier = "HomeRecentWatchItemCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.thumbnailImageView.layer.cornerRadius = 42
        self.thumbnailImageView.layer.borderColor = UIColor(resource: .strokeLight).cgColor
        self.thumbnailImageView.layer.borderWidth = 2
        self.thumbnailImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageTask?.cancel()
        self.imageTask = nil
        self.thumbnailImageView.image = nil
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
        self.dateLabel.text = nil
    }
    
    func setData(_ data: Home.Recent) {
        self.imageTask = .init(
            operation: {
                guard let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0
                else {
                    return
                }
                
                self.thumbnailImageView.image = UIImage(data: responseData)
            }
        )
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.channel
        self.dateLabel.text = Self.dateFormatter.string(
            from: .init(timeIntervalSince1970: data.timeStamp)
        )
    }
}
