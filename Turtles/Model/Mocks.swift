//
//  Mocks.swift
//  Turtles
//
//  Created by Dylan Elliott on 27/9/21.
//

import Foundation

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

extension Manifest {
    static var mock: Manifest {
        return Manifest(blueprint: .mock)
    }
}
