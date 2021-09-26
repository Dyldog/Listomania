//
//  Blueprint.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import Foundation
import SwiftUI

enum BlueprintItem: Identifiable {
    case task(Task)
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
    let title: String
    var items: [BlueprintItem]
    
    func allTasks() -> [Task] {
        return items.flatMap { item -> [Task] in
            switch item {
            case .task(let task): return [task]
            case .blueprint(let blueprint): return blueprint.allTasks()
            }
        }
    }
}

extension Blueprint {
    static var mock: Blueprint {
        let subBlueprint = Blueprint(id: .init(), title: "Sub Blueprint", items: [
            .task(.init(id: .init(), title: "One")),
            .task(.init(id: .init(), title: "Two")),
            .task(.init(id: .init(), title: "Three"))
        ])
        
        let items: [BlueprintItem] = [
            .task(.init(id: .init(), title: "Test Task")),
            .blueprint(subBlueprint)
            
        ]
        let blueprint = Blueprint(id: .init(), title: "Test", items: items)
        
        return blueprint
    }
}
