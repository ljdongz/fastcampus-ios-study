//
//  DetailPurchaseView.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import SwiftUI

final class DetailPurchaseViewModel: ObservableObject {
    @Published var isFavorite: Bool
    
    init(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}

struct DetailPurchaseView: View {
    @ObservedObject var viewModel: DetailPurchaseViewModel
    var onFavoriteTapped: () -> Void
    var onPurchaseTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 30, content: {
            Button(
                action: {
                    onFavoriteTapped()
                },
                label: {
                    Spacer()
                        .frame(width: 30)
                    viewModel.isFavorite ? Image(.favoriteOn) : Image(.favoriteOff)
                })
            
            Button(
                action: {
                    onPurchaseTapped()
                },
                label: {
                    Text("구매하기")
                        .font(CPFont.SwiftUI.medium17)
                        .foregroundStyle(Color.wh)
                })
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            .background(Color.keyColorBlue)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        })
        .padding(.vertical, 5)
    }
}

#Preview {
    DetailPurchaseView(viewModel: DetailPurchaseViewModel(isFavorite: false)) {
        
    } onPurchaseTapped: {
        
    }
    
}
