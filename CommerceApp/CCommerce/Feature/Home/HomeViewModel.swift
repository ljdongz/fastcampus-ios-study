//
//  HomeViewModel.swift
//  CCommerce
//
//  Created by 이정동 on 1/9/24.
//

import Foundation
import Combine

class HomeViewModel {
    
    @Published var bannerViewModels: [HomeBannerCollectionViewCellViewModel]?
    @Published var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
    @Published var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
    
    private var loadDataTask: Task<Void, Never>?
    
    func loadData() {
        loadDataTask = Task {
            do {
                let response = try await NetworkService.shared.getHomeData()
                
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
                
            } catch {
                print("Network Error: \(error)")
            }
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
    
    // 함수가 종료되었을 시 Main 쓰레드에서 동작할 수 있도록 함
    // MainActor는 async하게 동작하도록 보장해줘야 함
    @MainActor
    private func transformBanner(_ response: HomeResponse) async {
        self.bannerViewModels = response.banners.map {
            HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
        }
    }
    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
        self.horizontalProductViewModels = response.horizontalProducts.map {
            HomeProductCollectionViewCellViewModel(
                imageUrlString: $0.imageUrl,
                title: $0.title,
                reasonDiscountString: $0.discount,
                originalPrice: "\($0.originalPrice)",
                discountPrice: "\($0.discountPrice)"
            )
        }
    }
    
    @MainActor
    private func transformVerticalProduct(_ response: HomeResponse) async {
        self.verticalProductViewModels = response.verticalProducts.map {
            HomeProductCollectionViewCellViewModel(
                imageUrlString: $0.imageUrl,
                title: $0.title,
                reasonDiscountString: $0.discount,
                originalPrice: "\($0.originalPrice)",
                discountPrice: "\($0.discountPrice)"
            )
        }
    }
    
}
