//
//  Database.swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import UIKit
import Combine

enum Debug {
    static var forceDebugMode: Bool?
    
    static var isDebugMode: Bool {
        return forceDebugMode ?? UIApplication.isUITest
    }
}

class Database: NSObject, ObservableObject {
    @Published var deflatedBlueprints: [DeflatedBlueprint] = [] { didSet { blueprints = inflatedBlueprints }}
    @Published var blueprints: [Blueprint] = []
    @Published var manifests: [Manifest] = [] 
    
    override init() {
        super.init()
        
        if Debug.isDebugMode {
            let id1 = UUID()
            deflatedBlueprints = [
                .init(id: id1, title: "Going Out", items: [
                    .task(.init(id: .init(), title: "Keys")),
                    .task(.init(id: .init(), title: "Wallet")),
                    .task(.init(id: .init(), title: "Vape")),
                ]),
                .init(id: .init(), title: "Work", items: [
                    .blueprint(id1),
                    .task(.init(id: .init(), title: "Laptop")),
                ]),
                .init(id: .init(), title: "Camping", items: [])
            ]
            
            NotificationHandler.shared.clearNotifications()
        } else {
            restorePersistedData()
        }
    }
    
    private func deflatedBlueprint(with id: UUID) -> DeflatedBlueprint? {
        return deflatedBlueprints.first(where: { $0.id == id })
    }
    func blueprint(with id: UUID) -> Blueprint? {
        guard let deflated = deflatedBlueprint(with: id) else { return nil }
        return inflate(deflated)
    }
    
    func manifest(with id: UUID) -> Manifest? {
        return manifests.first(where: { $0.id == id })
    }
    
    func makeManifest(fromBlueprintWithID id: UUID) {
        guard let blueprint = blueprint(with: id) else { return }
        let manifest = blueprint.manifest()
        manifests.append(manifest)
        TaskNotificationsManager.scheduleNotifications(forNewManifest: manifest)
        persistData()
    }
    
    func makeNewBlueprint(title: String) -> DeflatedBlueprint {
        let blueprint = DeflatedBlueprint(id: .init(), title: title, items: [])
        deflatedBlueprints.append(blueprint)
        persistData()
        return blueprint
    }
    
    func deleteBlueprint(_ id: UUID) {
        deflatedBlueprints.removeAll(where: { $0.id == id })
        manifests.filter { $0.blueprintID == id }.forEach {
            deleteManifest($0.id)
        }
        persistData()
    }
    
    func deleteManifest(_ id: UUID) {
        guard let idx = manifests.firstIndex(where: {$0.id == id }) else { return }
        
        TaskNotificationsManager.removeNotifications(forManifest: manifests[idx])
        
        manifests.removeAll(where: { $0.id == id })
        
        persistData()
    }
    
    func deleteItem(_ item: BlueprintItem, from blueprint: UUID) {
        guard let idx = deflatedBlueprints.firstIndex(where: {$0.id == blueprint }) else { return }
        var blueprint = deflatedBlueprints[idx]
        let deflatedItem = item.deflated
        blueprint.items.removeAll(where: { $0 == deflatedItem })
        deflatedBlueprints[idx] = blueprint
        
        persistData()
    }
    
    func addTask(_ task: BlueprintTask, to blueprint: UUID) {
        guard let idx = deflatedBlueprints.firstIndex(where: {$0.id == blueprint }) else { return }
        var blueprint = deflatedBlueprints[idx]
        blueprint.items.append(.task(task))
        deflatedBlueprints[idx] = blueprint
        
        persistData()
        
        objectWillChange.send()
    }
    
    func addTask(_ task: ManifestTask, to manifest: UUID) {
        guard let idx = manifests.firstIndex(where: {$0.id == manifest }) else { return }
        var manifest = manifests[idx]
        manifest.tasks.append(task)
        manifests[idx] = manifest
        
        persistData()
    }
    
    func addBlueprint(titled title: String, to blueprintID: UUID? = nil) {
        let blueprint = DeflatedBlueprint(id: .init(), title: title, items: [])
        deflatedBlueprints.append(blueprint)
        
        if let parentID = blueprintID, let idx = deflatedBlueprints.firstIndex(where: {$0.id == parentID }) {
            var parent = deflatedBlueprints[idx]
            parent.items.append(.blueprint(blueprint.id))
            deflatedBlueprints[idx] = parent
        }
        
        persistData()
    }
    
    func addBlueprint(_ child: UUID, to parent: UUID) {
        guard let idx = deflatedBlueprints.firstIndex(where: {$0.id == parent }) else { return }
        var blueprint = deflatedBlueprints[idx]
        blueprint.items.append(.blueprint(child))
        deflatedBlueprints[idx] = blueprint
        
        persistData()
    }
    
    func updateCompletionStatus(for taskID: UUID, to newStatus: Bool, in manifestID: UUID) {
        guard let manifestIdx = manifests.firstIndex(where: { $0.id == manifestID }) else { return }
        var manifest = manifests[manifestIdx]
        guard let taskIdx = manifest.tasks.firstIndex(where: { $0.id == taskID }) else { return }
        manifest.tasks[taskIdx].completed = newStatus
        manifests[manifestIdx] = manifest
        
        TaskNotificationsManager.handleTaskCompletion(forManifest: manifest)
        
        persistData()
    }
    
    private func inflate(_ blueprint: DeflatedBlueprint) -> Blueprint {
        let inflatedItems: [BlueprintItem] = blueprint.items.compactMap {
            switch $0 {
            case .task(let task): return .task(task)
            case .blueprint(let id):
                guard let child = self.blueprint(with: id) else { return nil }
                return .blueprint(child)
            }
        }
        
        return Blueprint(id: blueprint.id, title: blueprint.title, items: inflatedItems)
    }
    
    private func inflate(_ blueprints: [DeflatedBlueprint]) -> [Blueprint] {
        blueprints.map(inflate)
    }
    
    private var inflatedBlueprints: [Blueprint] { inflate(deflatedBlueprints) }
    
    // MARK: - Moving Items
    
    func moveItem(atIndexes indexes: IndexSet, toIndex: Int, inBlueprintWithID id: UUID) {
        guard let idx = deflatedBlueprints.firstIndex(where: {$0.id == id }) else { return }
        var blueprint = deflatedBlueprints[idx]
        blueprint.items.move(fromOffsets: indexes, toOffset: toIndex)
        deflatedBlueprints[idx] = blueprint
        persistData()
    }
    
    func moveTask(atIndexes indexes: IndexSet, toIndex: Int, inManifestWithID id: UUID) {
        guard let idx = manifests.firstIndex(where: {$0.id == id }) else { return }
        var manifest = manifests[idx]
        manifest.tasks.move(fromOffsets: indexes, toOffset: toIndex)
        manifests[idx] = manifest
        persistData()
    }
    
    func moveBlueprint(atIndexes indexes: IndexSet, toIndex: Int) {
        deflatedBlueprints.move(fromOffsets: indexes, toOffset: toIndex)
        persistData()
    }
    
    func moveManifest(atIndexes indexes: IndexSet, toIndex: Int) {
        manifests.move(fromOffsets: indexes, toOffset: toIndex)
        persistData()
    }
    
    // MARK: - Data Persistence
    
    let encoder = JSONEncoder()
    
    private func persistData() {
        do {
            let manifestsData = try encoder.encode(manifests)
            UserDefaults.standard.set(manifestsData, forKey: UserDefaultsKeys.manifests.rawValue)
            
            let blueprintData = try encoder.encode(deflatedBlueprints)
            UserDefaults.standard.set(blueprintData, forKey: UserDefaultsKeys.blueprints.rawValue)
            
            UserDefaults.standard.synchronize()
        } catch {
            print(error)
        }
    }
    
    let decoder = JSONDecoder()
    
    private func restorePersistedData() {
        do {
            if let manifestsData = UserDefaults.standard.data(forKey: UserDefaultsKeys.manifests.rawValue) {
                manifests = try decoder.decode([Manifest].self, from: manifestsData)
                
                
                NotificationHandler.shared.clearNotifications()
                
                manifests.forEach {
                    if $0.completed == false {
                        TaskNotificationsManager.scheduleNotifications(forNewManifest: $0)
                    }
                }
            }
            
            if let blueprintData = UserDefaults.standard.data(forKey: UserDefaultsKeys.blueprints.rawValue) {
                deflatedBlueprints = try decoder.decode([DeflatedBlueprint].self, from: blueprintData)
            }
        } catch {
            print(error)
        }
    }
}

extension Database {
    enum UserDefaultsKeys: String {
        case manifests
        case blueprints
    }
}

extension Database {
    static func mock() -> Database {
        let databse = Database()
        databse.manifests = [Manifest.mock]
        return databse
    }
}
