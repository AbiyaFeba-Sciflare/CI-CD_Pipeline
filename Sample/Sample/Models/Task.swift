import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    var createdAt: Date
    var updatedAt: Date
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    init(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// Dummy data for testing
let dummyTasks: [Task] = [
    Task(title: "Buy groceries", priority: .medium, dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())),
    Task(title: "Finish project report", priority: .high, dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())),
    Task(title: "Call mom", priority: .low),
    Task(title: "Walk the dog", priority: .medium),
    Task(title: "Prepare presentation", priority: .high, dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()))
]
