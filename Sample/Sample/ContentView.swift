//
//  ContentView.swift
//  Sample
//
//  Created by Vision003 on 15/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TasksViewModel()
    
    var body: some View {
        NavigationView {  // This is line 13
            VStack {
                createTaskSection
                taskListSection
            }
            .navigationTitle("TODO List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.sortTasks) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
    
    // Break down the complex view into smaller components
    private var createTaskSection: some View {
        VStack(spacing: 12) {
            TextField("Enter task...", text: $viewModel.newTaskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            priorityPickerView
            actionButtonsView
        }
        .padding(.vertical)
    }
    
    private var priorityPickerView: some View {
        Picker("Priority", selection: $viewModel.selectedPriority) {
            ForEach(Task.Priority.allCases, id: \.self) { priority in
                Text(priority.rawValue)
                    .tag(priority)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    private var actionButtonsView: some View {
        HStack {
            Button(action: {
                viewModel.isEditing ? viewModel.updateTask() : viewModel.addTask()
            }) {
                Text(viewModel.isEditing ? "Update" : "Add")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            if viewModel.isEditing {
                Button(action: {
                    viewModel.isEditing = false
                    viewModel.selectedTask = nil
                    viewModel.newTaskTitle = ""
                    viewModel.selectedPriority = .medium
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var taskListSection: some View {
        List {
            ForEach(viewModel.tasks) { task in
                TaskRow(task: task)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteTask(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.isEditing = true
                            viewModel.selectedTask = task
                            viewModel.newTaskTitle = task.title
                            viewModel.selectedPriority = task.priority
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    viewModel.deleteTask(viewModel.tasks[index])
                }
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack {
            Button(action: {
                // Toggle completion status
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            taskInfoView
            Spacer()
            priorityBadge
        }
    }
    
    private var taskInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
            
            if let dueDate = task.dueDate {
                Text("Due: \(dueDate, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var priorityBadge: some View {
        Text(task.priority.rawValue)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        Color(
                            hue: CGFloat(task.priority.rawValue.count) / 3.0,
                            saturation: 0.5,
                            brightness: 0.9
                        )
                    )
            )
            .font(.caption)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    ContentView()
}
