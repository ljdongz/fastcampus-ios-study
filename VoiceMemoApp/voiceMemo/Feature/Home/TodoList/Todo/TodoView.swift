//
//  TodoView.swift
//  voiceMemo
//

import SwiftUI

struct TodoView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftButtonAction: {
                    pathModel.paths.removeLast()
                }, rightButtonAction: {
                    todoListViewModel.addTodo(
                        .init(
                            title: todoViewModel.title,
                            time: todoViewModel.time,
                            day: todoViewModel.date,
                            isSelected: false
                        )
                    )
                    pathModel.paths.removeLast()
                }, rightButtonType: .create
            )
            
            // 타이틀 뷰
            TitleView()
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            // todo 타이틀 뷰 (텍스트필드)
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            
            // 시간 선택
            TodoTimeView(todoViewModel: todoViewModel)
            
            // 날짜 선택
            TodoDayView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
                .padding(.top, 20)
            
            Spacer()
        }
    }
}

// MARK: - Title View
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            Text("To do list를\n추가해 보세요.")
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - Todo 제목 입력 View
private struct TodoTitleView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요", text: $todoViewModel.title)
    }
}

// MARK: - Todo 시간 선택 View
private struct TodoTimeView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(.wheel)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - Todo 날짜 선택 View
private struct TodoDayView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("날짜")
                    .foregroundStyle(Color.customIconGray)
                Spacer()
            }
            
            HStack {
                Button(
                    action: {
                        todoViewModel.setIsDisplayCalendar(true)
                    },
                    label: {
                        Text("\(todoViewModel.date.formattedDay)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.customGreen)
                    }
                )
                .popover(
                    isPresented: $todoViewModel.isDisplayCalendar,
                    content: {
                        DatePicker("", selection: $todoViewModel.date, displayedComponents: [.date])
                            .labelsHidden()
                            .datePickerStyle(.graphical)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .onChange(of: todoViewModel.date) { _ in
                                // 날짜가 선택되면(todoViewModel.day 값이 변경되면) 동작
                                todoViewModel.setIsDisplayCalendar(false)
                            }
                    }
                )
                
                Spacer()
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
            .environmentObject(PathModel())
            .environmentObject(TodoListViewModel())
    }
}
