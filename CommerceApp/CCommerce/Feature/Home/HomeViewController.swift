//
//  HomeViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/8/24.
//

import UIKit

class HomeViewController: UIViewController {
    enum Section: Int {
        case banner
        case horizontalProductItem
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
//    private var compositionalLayout: UICollectionViewCompositionalLayout = {
//        UICollectionViewCompositionalLayout { section, _ in
//            switch Section(rawValue: section) {
//            case .banner:
//                let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .fractionalHeight(1.0)
//                )
//                let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
//                
//                let groupSize: NSCollectionLayoutSize = .init(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .fractionalWidth(165 / 393)
//                )
//                let group: NSCollectionLayoutGroup = .horizontal(
//                    layoutSize: groupSize,
//                    subitems: [item]
//                )
//                
//                let section: NSCollectionLayoutSection = .init(group: group)
//                section.orthogonalScrollingBehavior = .groupPaging
//                return section
//            case .horizontalProductItem:
//                let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .fractionalHeight(1.0)
//                )
//                let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
//                
//                let groupSize: NSCollectionLayoutSize = .init(
//                    widthDimension: .absolute(117),
//                    heightDimension: .estimated(224)
//                )
//                let group: NSCollectionLayoutGroup = .horizontal(
//                    layoutSize: groupSize,
//                    subitems: [item]
//                )
//                group.contentInsets = .init(top: 0, leading: 7, bottom: 0, trailing: 7)
//                
//                let section: NSCollectionLayoutSection = .init(group: group)
//                section.orthogonalScrollingBehavior = .continuous
//                section.contentInsets  = .init(top: 20, leading: 26, bottom: 0, trailing: 26)
//                return section
//            case .none:
//                return nil
//            }
//        }
//        
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // compositionalLayout 설정
        //collectionView.collectionViewLayout = compositionalLayout
        collectionView.collectionViewLayout = createCompositionalLayout()

        
        // DiffableDataSource 설정
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch Section(rawValue: indexPath.section) {
                case .banner:
                    guard let viewModel = itemIdentifier as? HomeBannerCollectionViewCellViewModel,
                          let cell = collectionView.dequeueReusableCell(
                              withReuseIdentifier: "HomeBannerCollectionViewCell",
                              for: indexPath
                          ) as? HomeBannerCollectionViewCell
                    else { return .init() }
                    
                    cell.setViewModel(viewModel)
                    
                    return cell
                case .horizontalProductItem:
                    guard let viewModel = itemIdentifier as? HomeProductCollectionViewCellViewModel,
                          let cell = collectionView.dequeueReusableCell(
                              withReuseIdentifier: "HomeProductCollectionViewCell",
                              for: indexPath
                          ) as? HomeProductCollectionViewCell
                    else { return .init() }
                    
                    cell.setViewModel(viewModel)
                    
                    return cell
                case .none:
                    return .init()
                }
                
        })
        
        var snapShot: NSDiffableDataSourceSnapshot<Section, AnyHashable> = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapShot.appendSections([.banner])
        snapShot.appendItems([
            HomeBannerCollectionViewCellViewModel(bannerImage: .slide1),
            HomeBannerCollectionViewCellViewModel(bannerImage: .slide2),
            HomeBannerCollectionViewCellViewModel(bannerImage: .slide3)
        ],
            toSection: .banner
        )
        
        snapShot.appendSections([.horizontalProductItem])
        snapShot.appendItems([
                HomeProductCollectionViewCellViewModel(
                    imageUrlString: "",
                    title: "플레이스테이션1플레이스테이션1플레이스테이션1",
                    reasonDiscountString: "쿠폰 할인",
                    originalPrice: "10000",
                    discountPrice: "8000"
                ),
                HomeProductCollectionViewCellViewModel(
                    imageUrlString: "",
                    title: "플레이스테이션2",
                    reasonDiscountString: "쿠폰 할인",
                    originalPrice: "10000",
                    discountPrice: "8000"
                ),
                HomeProductCollectionViewCellViewModel(
                    imageUrlString: "",
                    title: "플레이스테이션3",
                    reasonDiscountString: "쿠폰 할인",
                    originalPrice: "10000",
                    discountPrice: "8000"
                ),
                HomeProductCollectionViewCellViewModel(
                    imageUrlString: "",
                    title: "플레이스테이션4",
                    reasonDiscountString: "쿠폰 할인",
                    originalPrice: "10000",
                    discountPrice: "8000"
                ),
                HomeProductCollectionViewCellViewModel(
                    imageUrlString: "",
                    title: "플레이스테이션5",
                    reasonDiscountString: "쿠폰 할인",
                    originalPrice: "10000",
                    discountPrice: "8000"
                )
            ],
            toSection: .horizontalProductItem
        )
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch Section(rawValue: section) {
            case .banner:
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
                
                return section
            case .horizontalProductItem:
                let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
                
                let groupSize: NSCollectionLayoutSize = .init(
                    widthDimension: .absolute(117),
                    heightDimension: .estimated(224)
                )
                let group: NSCollectionLayoutGroup = .horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                group.contentInsets = .init(top: 0, leading: 7, bottom: 0, trailing: 7)
                
                let section: NSCollectionLayoutSection = .init(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets  = .init(top: 20, leading: 26, bottom: 0, trailing: 26)
                return section
            case .none:
                return nil
            }
        }
    }
}

//#Preview {
//    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
//}
