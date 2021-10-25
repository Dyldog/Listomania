//
//  DeflatedBlueprint.swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import Foundation

class Blueprint: Codable, Identifiable {
    let id: UUID
    var title: String
    var items: [BlueprintItem]
    
    init(id: UUID, title: String, items: [BlueprintItem]) {
        self.id = id
        self.title = title
        self.items = items
    }

    func allTasks() -> [BlueprintTask] {
        return items.flatMap { item -> [BlueprintTask] in
            switch item {
            case .task(let task): return [task]
            case .blueprint(let blueprint): return blueprint.allTasks()
            }
        }
    }
    
    func manifest() -> Manifest {
        Manifest(blueprintID: id, id: .init(), title: title, tasks: allTasks().map { $0.manifest() })
    }
}
