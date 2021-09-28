//
//  Database.swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import Foundation

class Database: ObservableObject {
    @Published var blueprints: [Blueprint] = Blueprint.mock.allBlueprints()
    @Published var manifests: [Manifest] = [.mock]
    
    func blueprint(with id: UUID) -> Blueprint? {
        return blueprints.first(where: { $0.id == id })
    }
    
    func manifest(with id: UUID) -> Manifest? {
        return manifests.first(where: { $0.id == id })
    }
    
    func makeManifest(from blueprint: Blueprint) {
        manifests.append(blueprint.manifest())
    }
    
    func makeNewBlueprint(title: String) -> Blueprint {
        let blueprint = Blueprint(id: .init(), title: title, items: [])
        blueprints.append(blueprint)
        return blueprint
    }
    
    func deleteItem(_ item: BlueprintItem, from blueprint: UUID) {
        guard let idx = blueprints.firstIndex(where: {$0.id == blueprint }) else { return }
        var blueprint = blueprints[idx]
        blueprint.items.removeAll(where: { $0 == item })
        blueprints[idx] = blueprint
    }
    
    func addTask(_ task: BlueprintTask, to blueprint: UUID) {
        guard let idx = blueprints.firstIndex(where: {$0.id == blueprint }) else { return }
        var blueprint = blueprints[idx]
        blueprint.items.append(.task(task))
        blueprints[idx] = blueprint
    }
    
    func addBlueprint(titled title: String, to blueprintID: UUID? = nil) {
        let blueprint = Blueprint(id: .init(), title: title, items: [])
        blueprints.append(blueprint)
        
        if let parentID = blueprintID, let idx = blueprints.firstIndex(where: {$0.id == parentID }) {
            var parent = blueprints[idx]
            parent.items.append(.blueprint(blueprint))
            blueprints[idx] = parent
        }
    }
    
    func updateCompletionStatus(for taskID: UUID, to newStatus: Bool, in manifestID: UUID) {
        guard let manifestIdx = manifests.firstIndex(where: { $0.id == manifestID }) else { return }
        var manifest = manifests[manifestIdx]
        guard let taskIdx = manifest.tasks.firstIndex(where: { $0.id == taskID }) else { return }
        manifest.tasks[taskIdx].completed = newStatus
        manifests[manifestIdx] = manifest
    }
}
