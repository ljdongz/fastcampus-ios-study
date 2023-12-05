//
//  PathType.swift
//  voiceMemo
//


/// 화면 별 사용할 NavigationPath Type
enum PathType: Hashable {
    case homeView
    case todoView
    case memoView(isCreateMode: Bool, memo: Memo?) // 생성 or 상세 뷰
}
