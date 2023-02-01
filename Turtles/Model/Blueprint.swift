//
//  DeflatedBlueprint.swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import Foundation

struct Blueprint: Codable, Identifiable, Equatable {
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
    
    func subBlueprintString() -> String {
        let children = self.directChildBlueprints()
        let selfTitle = "→ \(self.title)"
        if children.isEmpty {
            return selfTitle
        } else {
            return ([selfTitle] + children.map { child in
                child.subBlueprintString()
                    .components(separatedBy: "\n")
                    .map { "    " + $0 }
                    .joined(separator: "\n")
            }).joined(separator: "\n")
        }
    }
    
    func childSubBlueprintString() -> String {
        subBlueprintString().split(separator: "\n").dropFirst().joined(separator: "\n")
    }
    
    func directChildBlueprints() -> [Blueprint] {
        items.compactMap {
            switch $0 {
            case .blueprint(let blueprint): return blueprint
            case .task: return nil
            }
        }
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
    
    static func ==(lhs: Blueprint, rhs: Blueprint) -> Bool {
        lhs.id == rhs.id && lhs.items == rhs.items
    }
}

extension Blueprint: Hashable {    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
