import Foundation
import SwiftUI

class TasksViewModel: ObservableObject {
    @Published var tasks: [Task] = dummyTasks
    @Published var newTaskTitle: String = ""
    @Published var selectedPriority: Task.Priority = .medium
    @Published var isEditing: Bool = false
    @Published var selectedTask: Task?
    
    // Add new task
    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        
        let newTask = Task(
            title: newTaskTitle,
            priority: selectedPriority
        )
        
        tasks.append(newTask)
        newTaskTitle = ""
        selectedPriority = .medium
    }
    
    // Toggle task completion
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            updatedTask.isCompleted.toggle()
            updatedTask.updatedAt = Date()
            tasks[index] = updatedTask
        }
    }
    
    // Delete task
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
    
    // Update task
    func updateTask() {
        guard let task = selectedTask else { return }
        
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            updatedTask.title = newTaskTitle
            updatedTask.priority = selectedPriority
            updatedTask.updatedAt = Date()
            tasks[index] = updatedTask
            
            isEditing = false
            selectedTask = nil
            newTaskTitle = ""
            selectedPriority = .medium
        }
    }
    
    // Sort tasks by priority and due date
    func sortTasks() {
        tasks.sort { task1, task2 in
            if task1.priority != task2.priority {
                return task1.priority.rawValue < task2.priority.rawValue
            }
            return task1.dueDate ?? Date.distantFuture < task2.dueDate ?? Date.distantFuture
        }
    }
}
