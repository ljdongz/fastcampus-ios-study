//
//  HomeViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/8/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    enum Section: Int {
        case banner
        case horizontalProductItem
        case verticalProductItem
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private var viewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingViewModel()
        collectionView.collectionViewLayout = createCompositionalLayout()
        setDataSource()
        viewModel.process(action: .loadData)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch Section(rawValue: section) {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
            case .horizontalProductItem:
                return HomeProductCollectionViewCell.horizontalProductItemLayout()
            case .verticalProductItem:
                return HomeProductCollectionViewCell.verticalProductItemLayout()
            case .none:
                return nil
            }
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                switch Section(rawValue: indexPath.section) {
                case .banner:
                    return self?.bannerCell(collectionView, indexPath, itemIdentifier)
                case .horizontalProductItem, .verticalProductItem:
                    return self?.productItemCell(collectionView, indexPath, itemIdentifier)
                case .none:
                    return .init()
                }
        })
    }
    
    private func applySnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        if let bannerViewModels = viewModel.state.collectionViewModels.bannerViewModels {
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerViewModels, toSection: .banner )
        }
        
        if let horizontalProductViewModels = viewModel.state.collectionViewModels.horizontalProductViewModels {
            snapShot.appendSections([.horizontalProductItem])
            snapShot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
        }
        
        if let verticalProductViewModels = viewModel.state.collectionViewModels.verticalProductViewModels {
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        }
        
        dataSource?.apply(snapShot)
    }
    
    private func bannerCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ itemIdentifier: AnyHashable
    ) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeBannerCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: "HomeBannerCollectionViewCell",
                  for: indexPath
              ) as? HomeBannerCollectionViewCell
        else { return .init() }
        
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func productItemCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ itemIdentifier: AnyHashable
    ) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeProductCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: "HomeProductCollectionViewCell",
                  for: indexPath
              ) as? HomeProductCollectionViewCell
        else { return .init() }
        
        cell.setViewModel(viewModel)
        
        return cell
    }
    
    private func bindingViewModel() {
        // Cancellables이 사라지기 전까지 관찰
        // (Cancellables가 사라지는 시기 -> ViewController가 사라질 때)
        viewModel.state.$collectionViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }.store(in: &cancellables)
    }
}

#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
}
