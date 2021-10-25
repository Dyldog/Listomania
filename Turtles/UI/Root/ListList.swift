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
    
    var manifests: [Manifest] {
        database.manifests.filter { $0.completed == false }
    }
    
    @State private var state: ScreenState = .normal
    
    private var showingAddBlueprintAlert: Binding<Bool> { Binding(
        get: { return state == .showingAddBlueprintAlert},
        set: { state = ($0 ? .showingAddBlueprintAlert : .normal) }
    ) }
    
    var body: some View {
        List {
            Section(header: Text("Manifests")) {
                ForEach(manifests) { manifest in
                    NavigationLink {
                        ManifestList(manifestID: manifest.id, database: database)
                    } label: {
                        ManifestRow(manifest: manifest)
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
                    .swipeActions() {
                        Button {
                            withAnimation {
                                database.makeManifest(fromBlueprintWithID: blueprint.id)
                            }
                        } label: {
                            Label("Make Manifest", systemImage: "wand.and.stars")
                        }
                        .tint(.blue)

                    }
                }
                .onMove(perform: {
                    database.moveBlueprint(atIndexes: $0, toIndex: $1)
                })
                
                Button {
                    showingAddBlueprintAlert.wrappedValue = true
                } label: {
                    Text("New Blueprint...")
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Lists")
        .toolbar { EditButton() }
        .environment(\.editMode, $editMode) //#2
        .alert(isPresented: showingAddBlueprintAlert, TextAlert(
            title: "Add Blueprint", message: nil, action: { text in
                if let text = text, !text.isEmpty {
                    self.didAddBlueprint(withTitle: text)
                }
            }
        ))

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
    enum ScreenState {
        case normal
        case showingAddBlueprintAlert
    }
}
