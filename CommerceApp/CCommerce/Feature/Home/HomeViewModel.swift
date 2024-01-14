//
//  HomeViewModel.swift
//  CCommerce
//
//  Created by 이정동 on 1/9/24.
//

import Foundation
import Combine

class HomeViewModel {
    enum Action {
        case loadData
        case loadCoupon
        case getDataSuccess(HomeResponse)
        case getDataFailure(Error)
        case getCouponSuccess(Bool)
        case didTapCouponButton
    }
    final class State {
        struct CollectionViewModels {
            var bannerViewModels: [HomeBannerCollectionViewCellViewModel]?
            var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
            var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
            var couponState: [HomeCouponButtonCollectionViewCellViewModel]?
            var separateLine1ViewModels: [HomeSeparateLineCollectionViewCellViewModel] = [HomeSeparateLineCollectionViewCellViewModel()]
            var separateLine2ViewModels: [HomeSeparateLineCollectionViewCellViewModel] = [HomeSeparateLineCollectionViewCellViewModel()]
            var themeViewModels: (HomethemeHeaderCollectionReusableViewModel, [HomeThemeCollectionViewCellViewModel])?
        }
        @Published var collectionViewModels = CollectionViewModels()
    }
    
    private(set) var state = State()
    
    private var loadDataTask: Task<Void, Never>?
    
    private let couponDownloadedKey = "CouponDownloaded"
    
    func process(action: Action) {
        switch action {
        case .loadData:
            loadData()
        case .loadCoupon:
            loadCoupon()
        case let .getDataSuccess(response):
            transformResponses(response)
        case let .getDataFailure(error):
            print("network error: \(error)")
        case let .getCouponSuccess(isDownloaded):
            Task { await transformCoupon(isDownloaded) }
        case .didTapCouponButton:
            downloadCoupon()
        }
    }
    
    
    deinit {
        loadDataTask?.cancel()
    }
    
}

extension HomeViewModel {
    
    private func loadData() {
        loadDataTask = Task {
            do {
                let response = try await NetworkService.shared.getHomeData()
                process(action: .getDataSuccess(response))
            } catch {
                process(action: .getDataFailure(error))
                print("Network Error: \(error)")
            }
        }
    }
    
    private func loadCoupon() {
        let couponState: Bool = UserDefaults.standard.bool(forKey: couponDownloadedKey)
        process(action: .getCouponSuccess(couponState))
    }
    
    private func transformResponses(_ response: HomeResponse) {
        /*
         각 작업을 Task로 감쌈으로써 async 동작들을 개별적으로 처리할 수 있음.
         ex)
         await transformA()
         await transformB()
         -> A가 끝날 때까지 기다린 후 B 실행
         */
        Task { await transformBanner(response) }
        Task { await transformHorizontalProduct(response) }
        Task { await transformVerticalProduct(response) }
        Task { await transformTheme(response) }
    }
    
    // 함수가 종료되었을 시 Main 쓰레드에서 동작할 수 있도록 함
    // MainActor는 async하게 동작하도록 보장해줘야 함
    @MainActor
    private func transformBanner(_ response: HomeResponse) async {
        self.state.collectionViewModels.bannerViewModels = response.banners.map {
            HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
        }
    }
    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
        self.state.collectionViewModels.horizontalProductViewModels = productToHomeProductCollectionViewCellViewModel(response.horizontalProducts)
    }
    
    @MainActor
    private func transformVerticalProduct(_ response: HomeResponse) async {
        self.state.collectionViewModels.verticalProductViewModels = productToHomeProductCollectionViewCellViewModel(response.verticalProducts)
    }
    
    @MainActor
    private func transformCoupon(_ isDownloaded: Bool) async {
        state.collectionViewModels.couponState = [.init(state: isDownloaded ? .disable : .enable)]
    }
    
    @MainActor
    private func transformTheme(_ response: HomeResponse) async {
        let items = response.themes.map {
            HomeThemeCollectionViewCellViewModel(themeImageUrl: $0.imageUrl)
        }
        state.collectionViewModels.themeViewModels = (HomethemeHeaderCollectionReusableViewModel(headerText: "테마관"), items)
    }
    
    
    private func productToHomeProductCollectionViewCellViewModel(_ product: [Product]) -> [HomeProductCollectionViewCellViewModel] {
        return product.map {
            HomeProductCollectionViewCellViewModel(
                imageUrlString: $0.imageUrl,
                title: $0.title,
                reasonDiscountString: $0.discount,
                originalPrice: $0.originalPrice.moneyString,
                discountPrice: $0.discountPrice.moneyString
            )
        }
        
    }
    
    private func downloadCoupon() {
        UserDefaults.standard.setValue(true, forKey: couponDownloadedKey)
        process(action: .loadCoupon)
    }
}
