//
//  Manifest.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import Foundation

struct Manifest: Identifiable, Codable {
    let id: UUID
    let title: String
    var tasks: [ManifestTask]
    var incompleteTasks: [ManifestTask] { tasks.filter { $0.completed == false }}
    var completedTasks: [ManifestTask] { tasks.filter { $0.completed == true }}
    
    var completed: Bool {
        return self.tasks.count != self.completedTasks.count
    }
}

extension Manifest {
    init(blueprint: Blueprint) {
        self.init(id: .init(), title: blueprint.title, tasks: blueprint.allTasks().map { $0.manifest() })
    }
}
