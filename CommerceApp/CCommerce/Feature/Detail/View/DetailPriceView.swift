//
//  DetailPriceView.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import SwiftUI

final class DetailPriceViewModel: ObservableObject {
    @Published var discountRate: String
    @Published var originPrice: String
    @Published var currentPrice: String
    @Published var shippingType: String
    
    init(discountRate: String, originPrice: String, currentPrice: String, shippingType: String) {
        self.discountRate = discountRate
        self.originPrice = originPrice
        self.currentPrice = currentPrice
        self.shippingType = shippingType
    }
}

struct DetailPriceView: View {
    @ObservedObject var viewModel: DetailPriceViewModel
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 21) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .bottom, spacing: 0, content: {
                        Text(viewModel.discountRate)
                            .font(CPFont.SwiftUI.bold12)
                            .foregroundStyle(Color(.icon))
                            
                        Text(viewModel.originPrice)
                            .font(CPFont.SwiftUI.bold16)
                            .foregroundStyle(Color(.gray5))
                            .strikethrough()
                            
                        Spacer()
                    })
                    
                    Text(viewModel.currentPrice)
                        .font(CPFont.SwiftUI.bold20)
                        .foregroundStyle(Color(.keyColorRed))
                }
                
                Text(viewModel.shippingType)
                    .font(CPFont.SwiftUI.regular12)
                    .foregroundStyle(Color(.icon))
            }
            .padding(.horizontal, 33)
    }
}

#Preview {
    DetailPriceView(
        viewModel: DetailPriceViewModel(
            discountRate: "53%",
            originPrice: "300,000원",
            currentPrice: "139,000원",
            shippingType: "무료배송"
        )
    )
}
