import XCTest
@testable import Sample

final class TaskTests: XCTestCase {
    
    func testTaskInitialization() {
        let task = Task(title: "Test Task")
        
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.priority, .medium)
        XCTAssertNotNil(task.dueDate)
        XCTAssertNotNil(task.createdAt)
        XCTAssertNotNil(task.updatedAt)
    }
    
    func testTaskPriority() {
        let highPriorityTask = Task(title: "Urgent Task", priority: .high)
        let lowPriorityTask = Task(title: "Low Priority Task", priority: .low)
        
        XCTAssertEqual(highPriorityTask.priority, .high)
        XCTAssertEqual(lowPriorityTask.priority, .low)
    }
    
    func testTaskDueDate() {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let task = Task(title: "Tomorrow Task", dueDate: tomorrow)
        
        XCTAssertEqual(task.dueDate, tomorrow)
    }
    
    func testTaskCoding() throws {
        let task = Task(title: "Coding Test Task", priority: .high)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(task)
        let decodedTask = try decoder.decode(Task.self, from: data)
        
        XCTAssertEqual(decodedTask.title, task.title)
        XCTAssertEqual(decodedTask.priority, task.priority)
        XCTAssertEqual(decodedTask.isCompleted, task.isCompleted)
    }
    
    func testDummyData() {
        for task in dummyTasks {
            XCTAssertFalse(task.isCompleted)
            XCTAssertNotNil(task.createdAt)
            XCTAssertNotNil(task.updatedAt)
            
            if let dueDate = task.dueDate {
                XCTAssertTrue(dueDate > Date())
            }
        }
    }
}
