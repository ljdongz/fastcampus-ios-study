//
//  DetailViewModel.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import Foundation

final class DetailViewModel: ObservableObject {
    struct State {
        var isLoading: Bool = true
        var banners: DetailBannerViewModel?
        var rate: DetailRateViewModel?
        var title: String?
        var option: DetailOptionViewModel?
        var price: DetailPriceViewModel?
        var mainImageUrls: [String]?
        var more: DetailMoreViewModel?
        var purchase: DetailPurchaseViewModel?
    }
    
    enum Action {
        case loadData
        case loading(Bool)
        case getDataSuccess(ProductDetailResponse)
        case getDataFailure(Error)
        case didTapChangeOption
        case didTapMore
        case didTapFavorite
        case didTapPurchase
    }
    
    @Published private(set) var state = State()
    
    private var loadDataTask: Task<Void, Never>?
    private var isFavorite: Bool = false
    private var needShowMore: Bool = true
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            loadData()
        case .loading(let bool):
//            DispatchQueue.main.async {
//                self.state.isLoading = bool
//            }
            Task { await setIsLoading(bool) }
        case .getDataSuccess(let response):
            Task { await transformProductDetailResponse(response) }
        case .getDataFailure(let error):
            print(error)
        case .didTapChangeOption:
            break
        case .didTapMore:
            needShowMore = false
            state.more = needShowMore ? DetailMoreViewModel() : nil
        case .didTapFavorite:
            isFavorite.toggle()
            state.purchase = DetailPurchaseViewModel(isFavorite: isFavorite)
        case .didTapPurchase:
            break
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
    
    @MainActor
    func setIsLoading(_ bool: Bool) async {
        state.isLoading = bool
    }
}

extension DetailViewModel {
    private func loadData() {
        loadDataTask = Task {
            defer {
                process(.loading(false))
            }
            do {
                //process(.loading(true))
                let response = try await NetworkService.shared.getProductDetailData()
                process(.getDataSuccess(response))
            } catch {
                process(.getDataFailure(error))
            }
        }
    }
    
    @MainActor
    private func transformProductDetailResponse(_ response: ProductDetailResponse) async {
        state.banners = DetailBannerViewModel(imageUrls: response.bannerImages)
        state.rate = DetailRateViewModel(rate: response.product.rate)
        state.title = response.product.name
        state.option = DetailOptionViewModel(
            type: response.option.type,
            name: response.option.name,
            imageUrl: response.option.image
        )
        state.price = DetailPriceViewModel(
            discountRate: "\(response.product.discountPercent)",
            originPrice: "\(response.product.originalPrice)",
            currentPrice: "\(response.product.discountPrice)",
            shippingType: "무료 배송"
        )
        state.mainImageUrls = response.detailImages
        state.more = needShowMore ? DetailMoreViewModel() : nil
        state.purchase = DetailPurchaseViewModel(isFavorite: false)
    }
}
