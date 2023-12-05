//
//  MemoView.swift
//  voiceMemo
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject var memoViewModel: MemoViewModel
    @State var isCreateMode: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                CustomNavigationBar(
                    leftButtonAction: {
                        pathModel.paths.removeLast()
                    },
                    rightButtonAction: {
                        if isCreateMode {
                            memoListViewModel.addMemo(memoViewModel.memo)
                        } else {
                            memoListViewModel.updateMemo(memoViewModel.memo)
                        }
                        pathModel.paths.removeLast()
                    },
                    rightButtonType: isCreateMode ? .create : .complete
                )
                
                
                // 메모 타이틀 입력 뷰
                MemoTitleInputView(
                    memoViewModel: memoViewModel,
                    isCreateMode: $isCreateMode
                )
                
                // 메모 컨텐츠 입력 뷰
                MemoContentInputView(memoViewModel: memoViewModel)
            }
            
            // 삭제 플로팅 버튼
            if !isCreateMode {
                MemoRemoveButtonView(memoViewModel: memoViewModel)
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
            }
            
        }
    }
}

// MARK: - 메모 제목 입력 뷰
private struct MemoTitleInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocused: Bool
    @Binding private var isCreateMode: Bool
    
    init(memoViewModel: MemoViewModel, isCreateMode: Binding<Bool>) {
        self.memoViewModel = memoViewModel
        self._isCreateMode = isCreateMode
    }
    
    fileprivate var body: some View {
        TextField(
            "제목을 입력하세요.",
            text: $memoViewModel.memo.title
        )
        .font(.system(size: 30))
        .padding(.horizontal, 30)
        .focused($isTitleFieldFocused)
        .onAppear {
            if isCreateMode {
                isTitleFieldFocused = true
            }
        }
    }
}

// MARK: - 메모 컨텐츠 입력 뷰
private struct MemoContentInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))
            
            if memoViewModel.memo.content.isEmpty {
                Text("메모를 입력하세요")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.customGray1)
                    .allowsHitTesting(false) // 사용자 터치를 입력받지 않음 (상호작용 X)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 메모 삭제 버튼 뷰
private struct MemoRemoveButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: {
                        memoListViewModel.removeMemo(memoViewModel.memo)
                        pathModel.paths.removeLast()
                    },
                    label: {
                        Image("trash")
                            .resizable()
                            .frame(width: 40, height: 40)
                    })
            }
        }
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoView(memoViewModel: MemoViewModel())
            .environmentObject(PathModel())
            .environmentObject(MemoListViewModel())
        
    }
}
