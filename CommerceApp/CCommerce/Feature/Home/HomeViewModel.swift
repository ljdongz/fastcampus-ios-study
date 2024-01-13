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
        case getDataSuccess(HomeResponse)
        case getDataFailure(Error)
    }
    final class State {
        struct CollectionViewModels {
            var bannerViewModels: [HomeBannerCollectionViewCellViewModel]?
            var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
            var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
        }
        @Published var collectionViewModels = CollectionViewModels()
    }
    
    private(set) var state = State()
    
    private var loadDataTask: Task<Void, Never>?
    
    func process(action: Action) {
        switch action {
        case .loadData:
            loadData()
        case let .getDataSuccess(response):
            transformResponses(response)
        case let .getDataFailure(error):
            print("network error: \(error)")
        }
    }
    
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
    
    deinit {
        loadDataTask?.cancel()
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
}
