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
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rankLabel.text = nil
        self.thumbnailImageView.image = nil
        self.imageTask?.cancel()
        self.imageTask = nil
    }

    func setData(_ data: Home.Ranking, rank: Int) {
        self.rankLabel.text = "\(rank)"
        self.imageTask = .init(
            operation: {
                guard let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0
                else {
                    return
                }
                
                self.thumbnailImageView.image = UIImage(data: responseData)
            }
        )
    }
}
