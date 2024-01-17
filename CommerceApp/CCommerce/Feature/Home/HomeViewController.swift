//
//  HomeViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/8/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private enum Section: Int {
        case banner
        case horizontalProductItem
        case separateLine1
        case couponButton
        case verticalProductItem
        case separateLine2
        case theme
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var dataSource: DataSource = setDataSource()
    private var viewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var currentSection: [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    private var didTapCouponDownload = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        bindingViewModel()
        collectionView.collectionViewLayout = createCompositionalLayout()
//        setDataSource()
        viewModel.process(action: .loadData)
        viewModel.process(action: .loadCoupon)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch self?.currentSection[section] {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
            case .horizontalProductItem:
                return HomeProductCollectionViewCell.horizontalProductItemLayout()
            case .verticalProductItem:
                return HomeProductCollectionViewCell.verticalProductItemLayout()
            case .couponButton:
                return HomeCouponButtonCollectionViewCell.couponButtonItemLayout()
            case .separateLine1, .separateLine2:
                return HomeSeparateLineCollectionViewCell.separateLineLayout()
            case .theme:
                return HomeThemeCollectionViewCell.themeLayout()
            case .none:
                return nil
            }
        }
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                switch self?.currentSection[indexPath.section] {
                case .banner:
                    return self?.bannerCell(collectionView, indexPath, itemIdentifier)
                case .horizontalProductItem, .verticalProductItem:
                    return self?.productItemCell(collectionView, indexPath, itemIdentifier)
                case .couponButton:
                    return self?.couponButtonCell(collectionView, indexPath, itemIdentifier)
                case .separateLine1, .separateLine2:
                    return self?.separateLineCell(collectionView, indexPath, itemIdentifier)
                case .theme:
                    return self?.themeCell(collectionView, indexPath, itemIdentifier)
                case .none:
                    return .init()
                }
        })
        
        dataSource.supplementaryViewProvider = {
            [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let viewModel = self?.viewModel.state.collectionViewModels.themeViewModels?.0 
            else { return nil }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomethemeHeaderCollectionReusableView.reusableId,
                for: indexPath
            ) as? HomethemeHeaderCollectionReusableView
            headerView?.setViewModel(viewModel)
            return headerView
        }
        return dataSource
    }
    
    private func applySnapShot() {
        var snapShot = SnapShot()
        
        if let bannerViewModels = viewModel.state.collectionViewModels.bannerViewModels {
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerViewModels, toSection: .banner )
        }
        
        if let horizontalProductViewModels = viewModel.state.collectionViewModels.horizontalProductViewModels {
            snapShot.appendSections([.horizontalProductItem])
            snapShot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
            snapShot.appendSections([.separateLine1])
            snapShot.appendItems(
                viewModel.state.collectionViewModels.separateLine1ViewModels,
                toSection: .separateLine1
            )
        }
        
        if let couponButtonViewModels = viewModel.state.collectionViewModels.couponState {
            
            snapShot.appendSections([.couponButton])
            snapShot.appendItems(couponButtonViewModels, toSection: .couponButton)
        }
        
        if let verticalProductViewModels = viewModel.state.collectionViewModels.verticalProductViewModels {
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        }
        
        if let themeViewModels = viewModel.state.collectionViewModels.themeViewModels?.1 {
            snapShot.appendSections([.separateLine2])
            snapShot.appendItems(
                viewModel.state.collectionViewModels.separateLine1ViewModels,
                toSection: .separateLine2
            )
            snapShot.appendSections([.theme])
            snapShot.appendItems(themeViewModels, toSection: .theme)
        }
        
        dataSource.apply(snapShot)
    }
    
    private func bannerCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ itemIdentifier: AnyHashable
    ) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeBannerCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeBannerCollectionViewCell.reusableId,
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
                withReuseIdentifier: HomeProductCollectionViewCell.reusableId,
                  for: indexPath
              ) as? HomeProductCollectionViewCell
        else { return .init() }
        
        cell.setViewModel(viewModel)
        
        return cell
    }
    
    private func couponButtonCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ itemIdentifier: AnyHashable
    ) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeCouponButtonCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCouponButtonCollectionViewCell.reusableId,
                  for: indexPath
              ) as? HomeCouponButtonCollectionViewCell
        else { return .init() }
        
        cell.setViewModel(viewModel, didTapCouponDownload)
        
        return cell
    }
    
    private func separateLineCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ itemIdentifier: AnyHashable
    ) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeSeparateLineCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeSeparateLineCollectionViewCell.reusableId,
                  for: indexPath
              ) as? HomeSeparateLineCollectionViewCell
        else { return .init() }
        
        cell.setViewModel(viewModel)
        
        return cell
    }
    
    private func themeCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ itemIdentifier: AnyHashable
    ) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeThemeCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeThemeCollectionViewCell.reusableId,
                  for: indexPath
              ) as? HomeThemeCollectionViewCell
        else { return .init() }
        
        return cell
    }
    
    private func bindingViewModel() {
        // Cancellables이 사라지기 전까지 관찰
        // (Cancellables가 사라지는 시기 -> ViewController가 사라질 때)
        viewModel.state.$collectionViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }.store(in: &cancellables)
        
        didTapCouponDownload.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.process(action: .didTapCouponButton)
            }.store(in: &cancellables)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Favorite", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSection[indexPath.section] {
        case .banner:
            break
        case .separateLine1, .separateLine2:
            break
        case .couponButton:
            break
        case .horizontalProductItem, .verticalProductItem:
            let storyboard = UIStoryboard(name: "Detail", bundle: nil)
            guard let vc = storyboard.instantiateInitialViewController() as? DetailViewController else { return }
            navigationController?.pushViewController(vc, animated: true)
        case .theme:
            break
        }
    }
}
