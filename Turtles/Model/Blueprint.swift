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
        return justTasks() + justBlueprints().flatMap { $0.justTasks() }
    }
    
    func justTasks() -> [BlueprintTask] {
        return items.flatMap { item -> [BlueprintTask] in
            switch item {
            case .task(let task): return [task]
            case .blueprint(let blueprint): return blueprint.justTasks()
            }
        }.uniqueElements()
    }
    
    func justBlueprints() -> [Blueprint] {
        return items.flatMap { item -> [Blueprint] in
            switch item {
            case .task: return []
            case .blueprint(let blueprint): return blueprint.justBlueprints()
            }
        }.uniqueElements()
    }
    
    func manifest() -> Manifest {
        Manifest(blueprintID: id, id: .init(), title: title, tasks: allTasks().map { $0.manifest() })
    }
}

extension Blueprint: Hashable {
    static func == (lhs: Blueprint, rhs: Blueprint) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
