//
//  DetailRootView.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import SwiftUI
import Kingfisher

struct DetailRootView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.state.isLoading {
                Text("로딩중")
            } else {
                if let error = viewModel.state.isError {
                    Text(error)
                } else {
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            bannerView
                            
                            rateView
                            
                            if let title = viewModel.state.title {
                                Text(title)
                            }
                            
                            optionView
                            
                            Divider()
                                .padding(.horizontal, 15)
                            
                            HStack(spacing: 0) {
                                Spacer()
                                Button(
                                    action: {
                                        viewModel.process(.didTapOption)
                                    },
                                    label: {
                                        Text("옵션 선택하기")
                                            .font(CPFont.SwiftUI.medium12)
                                            .foregroundStyle(Color(.keyColorBlue))
                                })
                            }
                            .padding(.top, 33)
                            .padding(.horizontal, 37)
                            
                            priceView
                            
                            mainImageView
                            
                            if let moreViewModel = viewModel.state.more {
                                DetailMoreView(viewModel: moreViewModel) {
                                    viewModel.process(.didTapMore)
                                }
                                .padding(.vertical, 10)
                            }
                        }
                    }
                    
                    if let purchaseViewModel = viewModel.state.purchase {
                        DetailPurchaseView(
                            viewModel: DetailPurchaseViewModel(
                                isFavorite: purchaseViewModel.isFavorite
                            )
                        ) {
                            viewModel.process(.didTapFavorite)
                        } onPurchaseTapped: {
                            viewModel.process(.didTapPurchase)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
                
                
            }
            
        }
        .onAppear(perform: {
            viewModel.process(.loadData)
        })
        
    }
    
    @ViewBuilder
    var bannerView: some View {
        if let bannersViewModel = viewModel.state.banners {
            DetailBannerView(viewModel: bannersViewModel)
        }
    }
    
    @ViewBuilder
    var rateView: some View {
        if let rateViewModel = viewModel.state.rate {
            HStack {
                Spacer()
                DetailRateView(viewModel: rateViewModel)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
        }
    }
    
    @ViewBuilder
    var optionView: some View {
        if let optionViewModel = viewModel.state.option {
            DetailOptionView(viewModel: optionViewModel)
                .padding(.vertical, 20)
        }
    }
    
    @ViewBuilder
    var priceView: some View {
        if let priceViewModel = viewModel.state.price {
            DetailPriceView(viewModel: priceViewModel)
                .padding(.top, 22)
        }
    }
    
    @ViewBuilder
    var mainImageView: some View {
        if let mainImageViewModel = viewModel.state.mainImageUrls {
            LazyVStack(spacing: 0, content: {
                ForEach(mainImageViewModel, id: \.self) {
                    KFImage.url(URL(string: $0))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            })
            .padding(.top, 40)
            .frame(maxHeight: viewModel.state.more == nil ? .infinity : 200, alignment: .top)
            .clipped()
        }
    }
}

#Preview {
    DetailRootView(viewModel: DetailViewModel())
}
