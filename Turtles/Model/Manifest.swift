//
//  Manifest.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import Foundation

struct Manifest: Identifiable {
    let id: UUID
    let title: String
    let tasks: [Task]
}

extension Manifest {
    init(blueprint: Blueprint) {
        self.init(id: .init(), title: blueprint.title, tasks: blueprint.allTasks())
    }
}
