//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    /*
     <<< EnvironmentObject로 사용하는 이유 >>>
     TodoView에서도 TodoListViewModel을 사용하는데, TodoListView의 하위 View로 사용되는 것이 아닌
     독립적인 View로 사용되기 때문에, 전역적으로 상태를 공유하기 위함
     */
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    var body: some View {
        ZStack {
            // Todo Cell List
            VStack {
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        isDisplayRightButton: true,
                        rightButtonAction: {
                            todoListViewModel.navigationRightButtonTapped()
                        },
                        rightButtonType: todoListViewModel.navigationBarRightButtonMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                }
                
            }
            
            WriteTodoButtonView()
                .padding(.bottom, 50)
                .padding(.trailing, 20)
        }
        .alert(
            "To do list \(todoListViewModel.removTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert) {
                Button("삭제", role: .destructive) {
                    todoListViewModel.removeButtonTapped()
                }
                Button("취소", role: .cancel) {
                }
            }
    }
}

// MARK: - Todo List Title View

private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - Todo List 안내 뷰

private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("“매일 아침 8시 운동가라고 알려줘“")
            Text("“내일 8시 수강 신청하라고 알려줘“")
            Text("“1시 반 점심약속 리마인드 해줘“")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}

// MARK: - Todo List 컨텐츠 뷰

private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할 일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
        .padding(.top, 20)
    }
}

// MARK: - Todo 셀 뷰

private struct TodoCellView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    

    
    fileprivate var body: some View {
        
        HStack {
            if !todoListViewModel.isEditTodoMode {
                Button(
                    action: {
                        todoListViewModel.selectedBoxTapped(todo)
                    }, label: {
                        todo.isSelected ? Image("selectedBox") : Image("unSelectedBox")
                    })
            }
            
            Spacer()
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.system(size: 16))
                    .foregroundStyle(todo.isSelected ? Color.customIconGray : Color.customBlack)
                    .strikethrough(todo.isSelected ? true : false)
                Text(todo.convertedDayAndTime)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.customIconGray)
            }
            
            Spacer()
            
            if todoListViewModel.isEditTodoMode {
                Button(
                    action: {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    }, label: {
                        isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                )
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        
        Rectangle()
            .fill(Color.customGray0)
            .frame(height: 1)
    }
}

// MARK: - Todo 작성 버튼 뷰

private struct WriteTodoButtonView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        pathModel.paths.append(.todoView)
                    },
                    label: {
                        Image("writeBtn")
                    })
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(PathModel())
            .environmentObject(TodoListViewModel(todos: [Todo(title: "Test", time: Date(), day: Date(), isSelected: false)]))
    }
}
