//
//  TestMemoListView.swift
//  voiceMemo
//
//  Created by 이정동 on 12/4/23.
//

import SwiftUI

struct TestMemoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if memoListViewModel.memos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        isDisplayRightButton: false
                    )
                } else {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        rightButtonAction: {
                            memoListViewModel.navigationRightButtonTapped()
                        },
                        rightButtonType: memoListViewModel.navigationBarRightButtonMode
                    )
                }
                
                // 타이틀 뷰
                TitleView()
                    .padding(.leading, 20)
                    .padding(.top, 20)
                
                // 안내 뷰 or 메모 리스트 뷰
                if memoListViewModel.memos.isEmpty {
                    MemoAnnouncementView()
                } else {
                    MemoListContentView()
                }
            }
            
            // 메모 작성 버튼
            MemoWriteButtonView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "\(memoListViewModel.removeMemoCount)개를 삭제하시겠습니까?",
            isPresented: $memoListViewModel.isDisplayRemoveMemoAlert) {
                Button("삭제", role: .destructive) {
                    memoListViewModel.removeButtonTapped()
                }
                Button("취소", role: .cancel) {
                    
                }
            }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
                Text("메모를\n추가해 보세요.")
            } else {
                Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
    }
}

// MARK: - 메모 안내 뷰
private struct MemoAnnouncementView: View {
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("“퇴근 9시간 전 메모“")
            Text("“기획서 작성 후 퇴근하기 메모“")
            Text("“밀린 집안 일 하기 메모“")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}

// MARK: - 메모 리스트 컨텐츠 뷰
private struct MemoListContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .padding(.leading, 20)
            
            ScrollView {
                Divider()
                ForEach(Array(memoListViewModel.memos.enumerated()), id: \.element) { index, memo in
                    MemoContentCellView(memo: memo)
                }
            }
        }
    }
}

// MARK: - 메모 컨텐츠 셀 뷰
private struct MemoContentCellView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool = false
    private var memo: Memo
    
    init(isRemoveSelected: Bool = false, memo: Memo) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button(
            action: {
                pathModel.paths.append(.memoView(isCreateMode: false, memo: memo))
            },
            label: {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(memo.title)")
                            Text("\(memo.content)")
                        }
                        .foregroundStyle(Color.customBlack)
                        
                        Spacer()
                        
                        Button(
                            action: {
                                isRemoveSelected.toggle()
                                memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                            },
                            label: {
                                if memoListViewModel.isEditMemoMode {
                                    isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                                }
                        })
                        
                    }
                    .padding(20)
                    
                    Divider()
                }
        })
        
    }
}

// MARK: - 메모 작성 버튼 뷰
private struct MemoWriteButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: {
                        pathModel.paths.append(.memoView(
                            isCreateMode: true,
                            memo: nil)
                        )
                    },
                    label: {
                    Image("writeBtn")
                })
            }
        }
    }
}

#Preview {
    TestMemoListView()
        .environmentObject(PathModel())
//        .environmentObject(MemoListViewModel())
        .environmentObject(MemoListViewModel(memos: [Memo(title: "1", content: "1111", date: Date())]))
}
