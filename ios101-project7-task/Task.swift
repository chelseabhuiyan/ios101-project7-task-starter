//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable, Equatable{

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
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
    let id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {


    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {

        // TODO: Save the array of tasks
        let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(tasks) {
                UserDefaults.standard.set(encoded, forKey: "tasksKey")
            }
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "tasksKey") {
               let decoder = JSONDecoder()
               if let tasks = try? decoder.decode([Task].self, from: data) {
                   return tasks
               }
           }
         
        return [] // 👈 replace with returned saved tasks
    }

    // Add a new task or update an existing task with the current task.
    func save() {
        
        // TODO: Save the current task
        // Retrieve the currently saved tasks from UserDefaults
        var tasks = Task.getTasks()
        
        // Find the index of the task with the same ID, if it exists
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            // Update the existing task
            tasks[index] = self
        } else {
            // Add the new task to the array
            tasks.append(self)
        }
        
        // Save the updated tasks array to UserDefaults
        Task.save(tasks)
    }
}
