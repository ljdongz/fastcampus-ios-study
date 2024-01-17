//
//  DetailOptionView.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import SwiftUI
import Kingfisher

final class DetailOptionViewModel: ObservableObject {
    @Published var type: String
    @Published var name: String
    @Published var imageUrl: String
    
    init(type: String, name: String, imageUrl: String) {
        self.type = type
        self.name = name
        self.imageUrl = imageUrl
    }
}

struct DetailOptionView: View {
    @ObservedObject var viewModel: DetailOptionViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.type)
                    .font(CPFont.SwiftUI.regular12)
                    .foregroundStyle(Color(.gray5))
                Text(viewModel.name)
                    .font(CPFont.SwiftUI.bold14)
                    .foregroundStyle(Color(.bk))
            }
            
            Spacer()
            
            KFImage(URL(string: viewModel.imageUrl))
                .resizable()
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 33)
    }
}

#Preview {
    DetailOptionView(
        viewModel: DetailOptionViewModel(
            type: "색상",
            name: "코랄",
            imageUrl: "https://picsum.photos/id/1/500/50"
        )
    )
}
