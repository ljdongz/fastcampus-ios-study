//
//  OptionRootView.swift
//  CCommerce
//
//  Created by 이정동 on 1/18/24.
//

import SwiftUI

struct OptionRootView: View {
    @ObservedObject var viewModel: OptionViewModel
    
    var body: some View {
        Text("옵션 선택 화면")
    }
}

#Preview {
    OptionRootView(viewModel: OptionViewModel())
}
