//
//  Mocks.swift
//  Turtles
//
//  Created by Dylan Elliott on 27/9/21.
//

import Foundation

extension DeflatedBlueprint {
    static var mock: [DeflatedBlueprint] {
        let subBlueprint = DeflatedBlueprint(id: .init(), title: "Sub Blueprint", items: [
            .task(.init(id: .init(), title: "One")),
            .task(.init(id: .init(), title: "Two")),
            .task(.init(id: .init(), title: "Three"))
        ])
        
        let items: [DeflatedBlueprintItem] = [
            .task(.init(id: .init(), title: "Test Task")),
            .blueprint(subBlueprint.id)
            
        ]
        let blueprint = DeflatedBlueprint(id: .init(), title: "Test", items: items)
        
        return [blueprint, subBlueprint]
    }
}

extension Manifest {
    static var mock: Manifest {
        return Manifest(id: .init(), title: "Title", tasks: [
            .init(id: .init(), title: "1", completedDate: nil),
            .init(id: .init(), title: "2", completedDate: nil),
            .init(id: .init(), title: "3", completedDate: nil)
        ])
    }
}
