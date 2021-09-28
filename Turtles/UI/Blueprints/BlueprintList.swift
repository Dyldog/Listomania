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
    
    var body: some View {
        List(blueprint.items) { item in
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
        .navigationTitle(blueprint.title)
        .confirmationDialog("Add", isPresented: showingAddSheet, actions: {
            Button("Task", action: { showingAddTaskAlert.wrappedValue = true })
            Button("Blueprint", action: { showingAddBlueprintAlert.wrappedValue = true })
        })
        .alert(isPresented: showingAddTaskAlert, TextAlert(
            title: "Add Task", message: nil, action: { text in
                if let text = text, !text.isEmpty {
                    self.didAddTask(withTitle: text)
                }
            }
        ))
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
    
    func didAddTask(withTitle title: String) {
        database.addTask(BlueprintTask(id: .init(), title: title), to: blueprintID)
    }
    
    func didAddBlueprint(withTitle title: String) {
        database.addBlueprint(titled: title, to: blueprintID)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        BlueprintList(blueprintID: Blueprint.mock.id, database: Database())
    }
}

extension BlueprintList {
    enum ScreenState {
        case normal
        case showingActionSheet
        case showingAddTaskAlert
        case showingAddBlueprintAlert
    }
}
