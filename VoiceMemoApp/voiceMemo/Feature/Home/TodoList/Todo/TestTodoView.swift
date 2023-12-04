//
//  TestTodoView.swift
//  voiceMemo
//
//  Created by 이정동 on 12/4/23.
//

import SwiftUI

struct TestTodoView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftButtonAction: {
                    pathModel.paths.removeLast()
                },
                rightButtonAction: {
                    todoListViewModel.addTodo(
                        Todo(
                            title: todoViewModel.title,
                            time: todoViewModel.time,
                            day: todoViewModel.day,
                            isSelected: false
                        )
                    )
                    pathModel.paths.removeLast()
                },
                rightButtonType: .create
            )
            
            // title View
            TodoTitleView()
            
            // title input view
            TitleInputView(todoViewModel: todoViewModel)
            
            // time view
            TodoTimeView(todoViewModel: todoViewModel)
            
            // date view
            TodoDayView(todoViewModel: todoViewModel)
            
            Spacer()
        }
    }
}

private struct TodoTitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("To do list를\n추가해 보세요.")
                .font(.system(size: 30, weight: .bold))
            
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 20)
        
    }
}

private struct TitleInputView: View {
    
    @ObservedObject private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        
        TextField(
            "제목을 입력하세요.",
            text: $todoViewModel.title
        )
        .font(.system(size: 16))
        .padding()
    }
}

private struct TodoTimeView: View {
    
    @ObservedObject private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)
        }
    }
}

private struct TodoDayView: View {
    
    @ObservedObject private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 10) {
            
            HStack {
                Text("날짜")
                
                Spacer()
            }
            
            HStack {
                Button(action: {
                    todoViewModel.setIsDisplayCalendar(true)
                }, label: {
                    Text("\(todoViewModel.day.formattedDay)")
                })
                
                Spacer()
            }
        }
        .padding(.leading, 20)
        .popover(
            isPresented: $todoViewModel.isDisplayCalendar, content: {
                DatePicker(
                    "",
                    selection: $todoViewModel.day,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .frame(maxWidth: .infinity)
                .onChange(of: todoViewModel.day) { _ in
                    todoViewModel.setIsDisplayCalendar(false)
                }
        })
    }
}

#Preview {
    TestTodoView()
}
