//
//  DetailMoreView.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import SwiftUI

final class DetailMoreViewModel: ObservableObject {
    
}

struct DetailMoreView: View {
    @ObservedObject var viewModel: DetailMoreViewModel
    var onMoreTapped: () -> Void
    
    var body: some View {
        Button(
            action: {
                onMoreTapped()
            }, label: {
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10, content: {
                    Text("상품정보 더보기")
                        .font(CPFont.SwiftUI.bold17)
                        .foregroundStyle(Color(.keyColorBlue))
                    Image(.down)
                        .foregroundStyle(Color(.icon))
                })
                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                .border(.keyColorBlue, width: 1)
        })
        .padding(.horizontal, 10)
        
    }
}

#Preview {
    DetailMoreView(viewModel: DetailMoreViewModel()) {
        
    }
}
