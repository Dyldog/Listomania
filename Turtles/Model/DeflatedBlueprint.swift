//
//  Blueprint.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import Foundation
import SwiftUI

enum DeflatedBlueprintItem: Identifiable, Equatable, Codable {
    static func == (lhs: DeflatedBlueprintItem, rhs: DeflatedBlueprintItem) -> Bool {
        switch (lhs, rhs) {
        case let (.task(a), .task(b)): return a.id == b.id
        case let (.blueprint(a), .blueprint(b)): return a == b
        default: return false
        }
    }
    
    case task(BlueprintTask)
    case blueprint(UUID)
    
    var id: UUID {
        switch self {
        case .task(let task): return task.id
        case .blueprint(let blueprintID): return blueprintID
        }
    }
}

extension BlueprintItem {
    var deflated: DeflatedBlueprintItem {
        switch self {
        case .task(let task): return .task(task)
        case .blueprint(let blueprint): return .blueprint(blueprint.id)
        }
    }
}

struct DeflatedBlueprint: Identifiable, Codable {
    let id: UUID
    var title: String
    var items: [DeflatedBlueprintItem]
}
