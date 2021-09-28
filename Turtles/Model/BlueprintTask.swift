//
//  Task.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import Foundation

struct BlueprintTask: Identifiable {
    let id: UUID
    let title: String
    
    func manifest() -> ManifestTask {
        return ManifestTask(id: .init(), title: title, completedDate: nil)
    }
}
