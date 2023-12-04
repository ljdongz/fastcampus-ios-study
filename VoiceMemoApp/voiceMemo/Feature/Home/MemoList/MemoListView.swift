//
//  MemoListView.swift
//  voiceMemo
//

import SwiftUI

struct MemoListView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if !memoListViewModel.memos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        rightButtonAction: {
                            memoListViewModel.isEditMemoMode.toggle()
                        },
                        rightButtonType: memoListViewModel.navigationBarRightButtonMode
                    )
                } else {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        isDisplayRightButton: false
                    )
                }
                
                // 타이틀 뷰
                TitleView()
                
                // 안내 뷰 or 메모리스트 컨텐츠 뷰
                if memoListViewModel.memos.isEmpty {
                    MemoAnnouncementView()
                } else {
                    MemoListContentView()
                }
                
                Spacer()
            }
            
            
            
            // 메모 작성 이이콘 뷰
            WriteMemoButton()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert("메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?", isPresented: $memoListViewModel.isDisplayRemoveMemoAlert) {
            Button("삭제", role: .destructive) {
                
            }
            Button("취소", role: .cancel) {}
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
        .padding(.leading, 20)
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
        .font(.system(size: 14))
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
                    .padding(.leading, 20)
                Spacer()
            }
            
            ScrollView(.vertical) {
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    ForEach(memoListViewModel.memos, id: \.self) { memo in
                        MemoContentCellView(memo: memo)
                    }
                }
            }
        }
    }
}

// MARK: - 메모 컨텐츠 셀 뷰
private struct MemoContentCellView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool
    private var memo: Memo
    
    init(isRemoveSelected: Bool = false, memo: Memo) {
        _isRemoveSelected = State(initialValue: false)
        self.memo = memo
    }
    
    
    fileprivate var body: some View {
        Button(
            action: {},
            label: {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(memo.title)
                                .lineLimit(1)
                                .font(.system(size: 16))
                                .foregroundStyle(Color.customBlack)
                            Text(memo.convertedDate)
                                .font(.system(size: 16))
                                .foregroundStyle(Color.customGray2)
                        }
                        Spacer()
                        
                        if memoListViewModel.isEditMemoMode {
                            Button(
                                action: {
                                    isRemoveSelected.toggle()
                                    memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                                },
                                label: {
                                isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                            })
                            
                        }
                    }
                    .padding(20)
                    
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                }
        })
    }
}

// MARK: - 메모 생성 버튼
private struct WriteMemoButton: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: {},
                    label: {
                    Image("writeBtn")
                })
            }
        }
    }
}

struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView()
            .environmentObject(MemoListViewModel(
                memos: [Memo(title: "1", content: "1", date: Date())]
            ))
            .environmentObject(PathModel())
    }
}
