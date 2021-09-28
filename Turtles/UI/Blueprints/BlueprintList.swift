//
//  ContentView.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI
import ComposableNavigator

struct BlueprintList: View {
    
    @State var blueprintID: UUID
    @ObservedObject var database: Database
    var blueprint: Blueprint { database.blueprint(with: blueprintID)! }


    @State private var state: ScreenState = .normal
    private var showingAddSheet: Binding<Bool> { Binding(
        get: { return state == .showingActionSheet},
        set: { state = ($0 ? .showingActionSheet : .normal) }
    ) }
    
    private var showingAddTaskAlert: Binding<Bool> { Binding(
        get: { return state == .showingAddTaskAlert},
        set: { state = ($0 ? .showingAddTaskAlert : .normal) }
    ) }
    
    private var showingAddBlueprintAlert: Binding<Bool> { Binding(
        get: { return state == .showingAddBlueprintAlert },
        set: { state = ($0 ? .showingAddBlueprintAlert : .normal) }
    ) }
    
    private var showingAddExistingBlueprintSheet: Binding<Bool> { Binding(
        get: { return state == .showingAddExistingBlueprintSheet },
        set: { state = ($0 ? .showingAddExistingBlueprintSheet : .normal) }
    ) }
    
    var body: some View {
        List{
            ForEach(blueprint.items) { item in
                self.view(for: item)
                    .swipeActions {
                        Button {
                            database.deleteItem(item, from: blueprintID)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
            }
            .onMove(perform: { database.moveItem(atIndexes: $0, toIndex: $1, inBlueprintWithID: blueprintID) })
        }
        .navigationTitle(blueprint.title)
        .confirmationDialog("Add", isPresented: showingAddSheet, actions: {
            Button("Task", action: { showingAddTaskAlert.wrappedValue = true })
            Button("Blueprint", action: { showingAddExistingBlueprintSheet.wrappedValue = true })
        })
        .alert(isPresented: showingAddTaskAlert, TextAlert(
            title: "Add Task", message: nil, action: { text in
                if let text = text, !text.isEmpty {
                    self.didAddTask(withTitle: text)
                }
            }
        ))
        .sheet(isPresented: showingAddExistingBlueprintSheet, content: {
            SearchView(
                title: "Add Blueprint",
                items: searchItems()) { selected, searchText in
                    switch selected {
                    case .add(let blueprint):
                        database.addBlueprint(blueprint.id, to: blueprintID)
                    case .create:
                        self.didAddBlueprint(withTitle: searchText)
                    }
                    
                    state = .normal
                }
        })
        .alert(isPresented: showingAddBlueprintAlert, TextAlert(
            title: "Add Blueprint", message: nil, action: { text in
                if let text = text, !text.isEmpty {
                    self.didAddBlueprint(withTitle: text)
                }
            }
        ))
        .toolbar(content: {
            Button("Add", action: {
                showingAddSheet.wrappedValue = true
            })
        })
    }
    
    @ViewBuilder
    func view(for item: BlueprintItem) -> some View {
        switch item {
        case .task(let task):
            BlueprintTaskRow(task: task)
        case .blueprint(let blueprint):
            NavigationLink {
                BlueprintList(blueprintID: blueprint.id, database: database)
            } label: {
                BlueprintView(blueprint: blueprint)
            }
        }
    }
    
    func searchItems() -> [BlueprintSearchItem] {
        database.blueprints.filter { $0.id != blueprintID }.map { BlueprintSearchItem.add($0) }
    }
    
    func didAddTask(withTitle title: String) {
        database.addTask(BlueprintTask(id: .init(), title: title), to: blueprintID)
    }
    
    func didAddBlueprint(withTitle title: String) {
        database.addBlueprint(titled: title, to: blueprintID)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        BlueprintList(blueprintID: DeflatedBlueprint.mock.first!.id, database: Database())
    }
}

extension BlueprintList {
    enum ScreenState {
        case normal
        case showingActionSheet
        case showingAddTaskAlert
        case showingAddBlueprintAlert
        case showingAddExistingBlueprintSheet
    }
}
