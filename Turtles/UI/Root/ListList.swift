//
//  ListList.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

struct ListList: View {
    @State var editMode: EditMode = .inactive // #1
    @ObservedObject var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    @State private var state: ScreenState = .normal
    
    @State private var deleteBlueprintID: UUID? {
        didSet { state = .showingDeleteBlueprintAlert }
    }
    
    var body: some View {
        List {
            Section(header: Text("Manifests")) {
                ForEach(database.manifests) { manifest in
                    NavigationLink {
                        ManifestList(manifestID: manifest.id, database: database)
                    } label: {
                        ManifestRow(manifest: manifest)
                    }
                    .swipeActions() {
                        Button {
                            withAnimation {
                                database.deleteManifest(manifest.id)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                    
                }
                .onMove(perform: {
                    database.moveManifest(atIndexes: $0, toIndex: $1)
                    
                })
            }
            
            Section(header: Text("Blueprints")) {
                ForEach(database.blueprints) { blueprint in
                    NavigationLink {
                        BlueprintList(blueprintID: blueprint.id, database: database)
                    } label: {
                        BlueprintView(blueprint: blueprint)
                    }
//                    .onDrag { // mean drag a row container
//                         return NSItemProvider()
//                    }
                    .swipeActions() {
                        Button {
                            withAnimation {
                                database.makeManifest(fromBlueprintWithID: blueprint.id)
                            }
                        } label: {
                            Label("Make Manifest", systemImage: "wand.and.stars")
                        }
                        .tint(.blue)
                        
                        Button {
                            withAnimation {
                                deleteBlueprintID = blueprint.id
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
                .onMove(perform: {
                    database.moveBlueprint(atIndexes: $0, toIndex: $1)
                })
                
                Button {
                    if Debug.isDebugMode {
                        database.addTask(.init(id: .init(), title: "HELLO"), to: database.blueprints.first!.id)
                        
                        if let manifest = database.manifests.first, let task = manifest.incompleteTasks.first {
                            database.updateCompletionStatus(for: task.id, to: true, in: manifest.id)
                        }
                    } else {
                        state = .showingAddBlueprintAlert
                    }
                } label: {
                    Text("New Blueprint...")
                }
            }
        }
        .navigationBarTitle("Lists")
        .environment(\.editMode, $editMode) //#2
        .alert(isPresented: $state.equals(.showingAddBlueprintAlert, default: .normal), TextAlert(
            title: "Add Blueprint", message: nil, action: { text in
                if let text = text, !text.isEmpty {
                    self.didAddBlueprint(withTitle: text)
                }
            }
        ))
        .alert(
            Text("Delete blueprint?"),
            isPresented: $state.equals(.showingDeleteBlueprintAlert, default: .normal),
            presenting: deleteBlueprintID) { id in
//                Button("Cancel") { }
                Button("Delete", role: .destructive) {
                    database.deleteBlueprint(id)
                }
            } message: {
                if let blueprint = database.blueprint(with: $0) {
                    Text("""
                    Are you sure you want to delete "\(blueprint.title)"?
                    It will be removed from any other blueprints referencing it and any manifests created from it will also be deleted.
                    """)
                } else {
                    Text("ERROR!")
                }
            }
//            .navigationViewStyle(.stack)
    }
    
    func didAddBlueprint(withTitle title: String) {
        database.addBlueprint(titled: title)
    }
}

extension ListList {
    enum Alerts: Identifiable {
        var id: String {
            switch self {
            case .makeManifest(let blueprint):
                return "makeManifest\(blueprint.id.uuid)"
            case .newBlueprint:
                return "newBlueprint"
            }
        }
        
        case makeManifest(DeflatedBlueprint)
        case newBlueprint
    }
}

struct ListList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListList(database: Database())
        }
    }
}

extension ListList {
    enum ScreenState: Equatable {
        case normal
        case showingAddBlueprintAlert
        case showingDeleteBlueprintAlert
    }
}

extension Binding where Value == Bool {
    init<T: Equatable>(_ binding: Binding<T>, off: T, on: T) {
        self.init {
            binding.wrappedValue == on
        } set: {
            if $0 == true {
                binding.wrappedValue = on
            } else {
                binding.wrappedValue = off
            }
        }
        
    }
}

extension Binding where Value: Equatable {
    func equals(_ value: Value, default defaultValue: Value) -> Binding<Bool> {
        Binding<Bool> {
            self.wrappedValue == value
        } set: {
            if $0 == true, self.wrappedValue != value {
                self.wrappedValue = value
            } else {
                self.wrappedValue = defaultValue
            }
        }

    }
}
