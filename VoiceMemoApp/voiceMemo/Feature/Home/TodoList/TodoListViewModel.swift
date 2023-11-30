//
//  TodoListViewModel.swift
//  voiceMemo
//

import Foundation

class TodoListViewModel: ObservableObject {
    
    @Published var todos: [Todo]
    @Published var isEditTodoMode: Bool // 편집 모드 여부
    @Published var removeTodos: [Todo] // 삭제할 todo 리스트
    @Published var isDisplayRemoveTodoAlert: Bool
    
    var removTodosCount: Int {
        removeTodos.count
    }
    
    var navigationBarRightButtonMode: NavigationBtnType {
        // 현재 편집 모드인 경우 "완료" 버튼으로, 아닌 경우 "편집" 버튼으로 표시
        isEditTodoMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditTodoMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

// MARK: - 로직

extension TodoListViewModel {
    /// Todo 완료 여부 체크박스 토글 (편집 모드 X)
    /// - Parameter todo: 선택한 Todo Model
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].isSelected.toggle()
        }
    }
    
    /// Todo 추가
    /// - Parameter todo: 추가할 Todo Model
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    /// 네비게이션 우측 버튼 클릭 동작 (편집 모드일 경우와 아닌 경우)
    func navigationRightButtonTapped() {
        
        // 현재 편집 모드이면서 삭제할 Todo가 존재할 때
        if isEditTodoMode && !removeTodos.isEmpty {
            setIsDisplayRemoveTodoAlert(true)
        }
        
        // 모드 변환
        isEditTodoMode.toggle()
        
        
//        if isEditTodoMode {
//            if removeTodos.isEmpty {
//                isEditTodoMode = false
//            } else {
//                // alert을 불러줌
//                setIsDisplayRemoveTodoAlert(true)
//            }
//        } else {
//            isEditTodoMode = true
//        }
    }
    
    /// Todo 삭제 알림 여부
    /// - Parameter isDisplay: Alert 여부 값 전달
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    /// 삭제할 Todo 선택
    /// - Parameter todo: 삭제할 Todo Model
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        // 삭제할 Todo 리스트에 선택한 Todo 존재 (= 삭제 취소할 Todo)
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    /// 삭제 Alert에서 삭제 버튼 클릭
    func removeButtonTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        removeTodos.removeAll()
        //isEditTodoMode = false
    }
}
