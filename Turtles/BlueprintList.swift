//
//  ContentView.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

struct BlueprintList: View {
    
    @State var blueprint: Blueprint
    
    @State private var state: ScreenState = .normal
    private var showingAddSheet: Binding<Bool> { Binding(
        get: { return state == .showingActionSheet},
        set: { state = ($0 ? .showingActionSheet : .normal) }
    ) }
    
    private var showingAddTaskAlert: Binding<Bool> { Binding(
        get: { return state == .showingAddTaskAlert},
        set: { state = ($0 ? .showingAddTaskAlert : .normal) }
    ) }
    
    var body: some View {
        NavigationView {
            List(blueprint.items) { item in
                Self.view(for: item)
            }
            .navigationTitle(blueprint.title)
            .confirmationDialog("Add", isPresented: showingAddSheet, actions: {
                Button("Task", action: { showingAddTaskAlert.wrappedValue = true })
                Button("Blueprint", action: {})
            })
            .alert(isPresented: showingAddTaskAlert, TextAlert(
                title: "Add Task", message: nil, action: { text in
                    if let text = text, !text.isEmpty {
                        self.didAddTask(withTitle: text)
                    }
                }
            ))
            .toolbar(content: {
                Button("Add", action: {
                    showingAddSheet.wrappedValue = true
                })
            })
        }
    }
    
    @ViewBuilder
    static func view(for item: BlueprintItem) -> some View {
        switch item {
        case .task(let task):
            BlueprintTaskRow(task: task)
        case .blueprint(let blueprint):
            NavigationLink(destination: BlueprintList(blueprint: blueprint), label: { BlueprintRow(blueprint: blueprint) })
        }
    }
    
    func didAddTask(withTitle title: String) {
        blueprint.items.append(.task(Task(id: .init(), title: title)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        BlueprintList(blueprint: Blueprint.mock)
    }
}

extension BlueprintList {
    enum ScreenState {
        case normal
        case showingActionSheet
        case showingAddTaskAlert
    }
}

