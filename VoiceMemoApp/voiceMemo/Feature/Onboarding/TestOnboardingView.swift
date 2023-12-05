//
//  TestOnboardingView.swift
//  voiceMemo
//
//  Created by 이정동 on 11/24/23.
//

import SwiftUI

struct TestOnboardingView: View {
    
    @StateObject var pathModel = PathModel()
    @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            OnboardingContentListView(viewModel: viewModel)
                .navigationDestination(for: PathType.self) { path in
                    switch path {
                    case .homeView:
                        HomeView()
                            .navigationBarBackButtonHidden()
                    case .todoView:
                        TestTodoView()
                            .navigationBarBackButtonHidden()
                    case .memoView:
                        TestMemoView()
                            .navigationBarBackButtonHidden()
                    }
                }
        }
        .environmentObject(pathModel)
    }
}

private struct OnboardingContentListView: View {
    
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selected = 0
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        TabView(selection: $selected,
                content:  {
            ForEach(Array(viewModel.onboardingContents.enumerated()), id: \.element) { index, content in
                OnboardingContentView(onboardingContent: content)
                    .tag(index)
            }
        })
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(selected % 2 == 0 ? Color.customSky : Color.customBackgroundGreen)
    }
}

private struct OnboardingContentView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    private var onboardingContent: OnboardingContent
    
    init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button(action: {
                        pathModel.paths.append(.homeView)
                    }, label: {
                        Text("시작하기")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.customGreen)
                        
                        Image("startHome")
                            .renderingMode(.template)
                            .foregroundStyle(Color.customGreen)
                    })
                    
                    Spacer()
                        .frame(height: 50)
                }
                
                Spacer()
            }
            .background(Color.customWhite)
            .shadow(radius: 5)
        }
    }
}


#Preview {
    TestOnboardingView()
}
