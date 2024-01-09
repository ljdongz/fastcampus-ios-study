//
//  HomeViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/8/24.
//

import UIKit

class HomeViewController: UIViewController {
    enum Section {
        case banner
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>?
    private var compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(165 / 393)
        )
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // compositionalLayout 설정
        collectionView.collectionViewLayout = compositionalLayout

        
        // DiffableDataSource 설정
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "HomeBannerCollectionViewCell",
                    for: indexPath
                ) as! HomeBannerCollectionViewCell
                cell.setImage(itemIdentifier)
                return cell
        })
        
        var snapShot: NSDiffableDataSourceSnapshot<Section, UIImage> = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapShot.appendSections([.banner])
        snapShot.appendItems([
            UIImage(resource: .slide1),
            UIImage(resource: .slide2),
            UIImage(resource: .slide3)
        ],
            toSection: .banner
        )
        
        dataSource?.apply(snapShot)
    }
}
