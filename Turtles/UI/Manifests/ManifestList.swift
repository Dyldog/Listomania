//
//  ManifestList.swift
//  Turtles
//
//  Created by Dylan Elliott on 27/9/21.
//

import SwiftUI

struct ManifestList: View {
    @State var manifestID: UUID
    var manifest: Manifest { database.manifest(with: manifestID)! }
    @ObservedObject var database: Database
    @State private var showAddView: Bool = false
    var sortedTasks: [ManifestTask] {
        manifest.tasks.filter { $0.completed == false } +
        manifest.tasks.filter { $0.completed == true }
    }
    
    var body: some View {
        List {
            ForEach(sortedTasks) { task in
                ManifestTaskRow(task: task, onCompletionChange: { self.onTaskChange(taskID: task.id, newStatus: $0) })
                    .buttonStyle(PlainButtonStyle())
            }
            .onMove(perform: { database.moveTask(atIndexes: $0, toIndex: $1, inManifestWithID: manifest.id) })
        }
        .fullScreenCover(isPresented: $showAddView) {
            AddTaskToManifestView {
                defer { showAddView = false }
                guard let (title, addToBlueprint) = $0 else { return }
                database.addTask(
                    ManifestTask(
                        id: .init(),
                        title: title,
                        completedDate: nil
                    ),
                    to: manifest.id
                )
                
                if addToBlueprint {
                    database.addTask(
                        BlueprintTask(
                            id: .init(),
                            title: title
                        ),
                        to: manifest.blueprintID
                    )
                }
            }
        }
        .navigationTitle(manifest.title)
        .toolbar {
            Button {
                showAddView = true
            } label: {
                Image(systemName: "plus")
            }
        }
//        .toolbar { EditButton() }
    }
    
    func onTaskChange(taskID: UUID, newStatus: Bool) {
        withAnimation {
            database.updateCompletionStatus(for: taskID, to: newStatus, in: manifest.id)
        }
    }
}

struct ManifestList_Previews: PreviewProvider {
    static var previews: some View {
        return ManifestList(manifestID: Manifest.mock.id, database: Database())
    }
}
