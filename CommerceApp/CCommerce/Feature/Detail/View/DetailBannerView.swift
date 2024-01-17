//
//  DetailBannerView.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import SwiftUI
import Kingfisher

final class DetailBannerViewModel: ObservableObject {
    @Published var imageUrls: [String]
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
    }
}

struct DetailBannerView: View {
    @ObservedObject var viewModel: DetailBannerViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.imageUrls, id: \.self) { url in
                    KFImage(URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.never)
        
    }
}

#Preview {
    DetailBannerView(viewModel: DetailBannerViewModel(imageUrls: [
        "https://picsum.photos/id/1/500/500",
        "https://picsum.photos/id/2/500/500",
        "https://picsum.photos/id/3/500/500",
        "https://picsum.photos/id/4/500/500",
    ]))
}
