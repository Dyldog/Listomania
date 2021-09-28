//
//  BlueprintSearchItem.swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import Foundation

enum BlueprintSearchItem: SearchItem {
    case add(Blueprint)
    case create
    
    var title: String {
        switch self {
        case .add(let blueprint): return blueprint.title
        case .create: return "Create New Blueprint"
        }
    }
}
