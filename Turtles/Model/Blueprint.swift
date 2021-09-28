//
//  Blueprint.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import Foundation
import SwiftUI

enum BlueprintItem: Identifiable, Equatable {
    static func == (lhs: BlueprintItem, rhs: BlueprintItem) -> Bool {
        switch (lhs, rhs) {
        case let (.task(a), .task(b)): return a.id == b.id
        case let (.blueprint(a), .blueprint(b)): return a.id == b.id
        default: return false
        }
    }
    
    case task(BlueprintTask)
    case blueprint(Blueprint)
    
    var id: UUID {
        switch self {
        case .task(let task): return task.id
        case .blueprint(let blueprint): return blueprint.id
        }
    }
    
    var title: String {
        switch self {
        case .task(let task): return task.title
        case .blueprint(let blueprint): return blueprint.title
        }
    }
}

struct Blueprint: Identifiable {
    let id: UUID
    var title: String
    var items: [BlueprintItem]
    
    func allTasks() -> [BlueprintTask] {
        return items.flatMap { item -> [BlueprintTask] in
            switch item {
            case .task(let task): return [task]
            case .blueprint(let blueprint): return blueprint.allTasks()
            }
        }
    }
    
    func manifest() -> Manifest {
        Manifest(id: .init(), title: title, tasks: allTasks().map { $0.manifest() })
    }
    
    func allBlueprints() -> [Blueprint] {
        return items.flatMap { item -> [Blueprint] in
            switch item {
            case .task: return []
            case .blueprint(let blueprint): return blueprint.allBlueprints()
            }
        } + [self]
    }
}
