//
//  DeflatedBlueprintItem.swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import Foundation

enum BlueprintItem: Codable, Identifiable, Equatable {
    case task(BlueprintTask)
    case blueprint(Blueprint)
    
    var id: UUID {
        switch self {
        case .task(let task): return task.id
        case .blueprint(let blueprint): return blueprint.id
        }
    }
}
