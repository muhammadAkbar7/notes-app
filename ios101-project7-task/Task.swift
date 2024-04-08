//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
//    init(title: String, note: String? = nil, dueDate: Date = Date()) {
    init(id: String, title: String, note: String? = nil, dueDate: Date = Date()) {
        self.id = id
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    let createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    //let id: String = UUID().uuidString
    let id: String
}

// MARK: - Task + UserDefaults
extension Task {
    static let userDefaultsKey = "tasks"

    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
         if let encodedData = try? encoder.encode(tasks) {
             UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
         } else {
             print("Failed to encode tasks.")
         }
    }
//    static func save(_ tasks: [Task], forKey key: String) {
//        // 1.
//        let defaults = UserDefaults.standard
//        // 2.
//        let encodedData = try! JSONEncoder().encode(tasks)
//        // 3.
//        defaults.set(encodedData, forKey: key)
//    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        if let savedTasksData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let savedTasks = try? decoder.decode([Task].self, from: savedTasksData) {
                return savedTasks
            } else {
                print("Failed to decode saved tasks.")
            }
        }
        return [] // Return an empty array if tasks are not found or decoding fails.
    }
    
//    static func getTasks(forKey key: String) -> [Task] {
//        // 1.
//        let defaults = UserDefaults.standard
//        // 2.
//        if let data = defaults.data(forKey: key) {
//            // 3.
//            let decodedTasks = try! JSONDecoder().decode([Task].self, from: data)
//            // 4.
//            return decodedTasks
//        } else {
//            // 5.
//            return []
//        }
//    }

    // Add a new task or update an existing task with the current task.
    func save() {
        var savedTasks = Task.getTasks()
        if let index = savedTasks.firstIndex(where: { $0.id == self.id }) {
            savedTasks[index] = self // Update existing task
        } else {
            savedTasks.append(self) // Add new task
        }
        Task.save(savedTasks)
    }
}
