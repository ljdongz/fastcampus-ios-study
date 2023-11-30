//
//  TestTodoListView.swift
//  voiceMemo
//
//  Created by 이정동 on 11/30/23.
//

import SwiftUI

struct TestTodoListView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        isDisplayRightButton: false
                    )
                } else {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        rightButtonAction: todoListViewModel.navigationRightButtonTapped,
                        rightButtonType: todoListViewModel.navigationBarRightButtonMode
                    )
                }
                
                TitleView()
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    ContentListView()
                }
            }
            
            WriteTodoButtonView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
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
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Todo List 안내 뷰
private struct AnnouncementView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("“매일 아침 8시 운동가라고 알려줘“")
            Text("“내일 8시 수강 신청하라고 알려줘“")
            Text("“1시 반 점심약속 리마인드 해줘“")
            Spacer()
        }
        .foregroundStyle(Color.customGray2)
        .font(.system(size: 16))
    }
}

// MARK: - Todo List Content View

private struct ContentListView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("할 일 목록")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 10)
            
            ScrollView(.vertical) {
                VStack {
//                    Rectangle()
//                        .fill(Color.customGray0)
//                        .frame(height: 1)
                    Divider()
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        ContentCellView(todo: todo)
                    }
                }
                
            }
            
            
                
        }
    }
}

// MARK: - Todo List Content Cell View
private struct ContentCellView: View {
    
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool = false
    private var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    fileprivate var body: some View {
        HStack {
            if !todoListViewModel.isEditTodoMode {
                Button(action: {
                    /*
                     버튼 클릭 시 todoListViewModel.todos 배열 내 특정 todo가 변경됨.
                     todos는 property wrapper로 선언되있어 값이 변경됨에 따라 뷰를 다시 그림.
                     todoListViewModel을 관찰하고 있는 모든 뷰가 다시 그려짐.
                     따라서 todo 변수는 일반적인 인스턴스 변수로 선언이 되어있지만, 상위 뷰(ContentListView)가 업데이트 됨에 따라, ContentCellView의 값이 변경된 todo를 전달하면서 뷰가 그려짐
                     */
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
                Button(action: {
                    isRemoveSelected.toggle()
                }, label: {
                    todo.isSelected ? Image("selectedBox") : Image("unSelectedBox")
                })
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        
        Divider()
    }
}

// MARK: - Todo 작성 버튼
private struct WriteTodoButtonView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image("writeBtn")
                })
            }
        }
    }
}

#Preview {
    TestTodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel(todos: [Todo(title: "Test", time: Date(), day: Date(), isSelected: false)]))
//            .environmentObject(TodoListViewModel())
}
