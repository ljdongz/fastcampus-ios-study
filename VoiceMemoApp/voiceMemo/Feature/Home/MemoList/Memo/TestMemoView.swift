//
//  TestMemoView.swift
//  voiceMemo
//
//  Created by 이정동 on 12/5/23.
//

import SwiftUI

struct TestMemoView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject private var memoViewModel: MemoViewModel
    private var isCreateMode: Bool
    
    init(memoViewModel: MemoViewModel, isCreateMode: Bool) {
        _memoViewModel = StateObject(wrappedValue: memoViewModel)
        self.isCreateMode = isCreateMode
    }
    
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
                
                // 제목 입력 화면
                MemoTitleInputView(
                    memoViewModel: memoViewModel,
                    isCreateMode: isCreateMode
                )
                
                // 컨텐츠 입력 화면
                MemoContentInputView(memoViewModel: memoViewModel)
            }
            
            // 메모 삭제 버튼
            if !isCreateMode {
                MemoRemoveButtonView(memoViewModel: memoViewModel)
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
            }
            
        }
    }
}

// MARK: - 메모 제목 입력 화면
private struct MemoTitleInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocused: Bool
    private var isCreateMode: Bool
    
    fileprivate init(memoViewModel: MemoViewModel, isCreateMode: Bool) {
        self.memoViewModel = memoViewModel
        self.isCreateMode = isCreateMode
    }
    
    fileprivate var body: some View {
        TextField(
            "제목을 입력하세요.",
            text: $memoViewModel.memo.title
        )
        .font(.system(size: 30))
        .focused($isTitleFieldFocused)
        .padding(.horizontal, 20)
        .onAppear {
            if isCreateMode { isTitleFieldFocused = true }
        }
    }
}

// MARK: - 메모 컨텐츠 입력 화면
private struct MemoContentInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
            
            if memoViewModel.memo.content.isEmpty {
                Text("내용을 입력하세요.")
                    .foregroundStyle(Color.customGray2)
                    .allowsHitTesting(false)
            }
        }
        .padding(.horizontal, 20)
        
    }
}

// MARK: - 메모 삭제 버튼
private struct MemoRemoveButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @ObservedObject private var memoViewModel: MemoViewModel
    
    init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: {
                        memoViewModel.setIsDisplayRemoveMemoAlert(true)
                    },
                    label: {
                        Image("trash")
                    })
            }
        }
        .alert(
            "삭제하시겠습니까?",
            isPresented: $memoViewModel.isDisplayRemoveMemoAlert) {
                Button("삭제", role: .destructive) {
                    memoListViewModel.removeMemo(memoViewModel.memo)
                    pathModel.paths.removeLast()
                }
                Button("취소", role: .cancel) {
                    
                }
            }
    }
}

#Preview {
    TestMemoView(memoViewModel: MemoViewModel(), isCreateMode: false)
        .environmentObject(PathModel())
        .environmentObject(MemoListViewModel())
}
