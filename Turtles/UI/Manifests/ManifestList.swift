//
//  ManifestList.swift
//  Turtles
//
//  Created by Dylan Elliott on 27/9/21.
//

import SwiftUI

struct ManifestList: View {
    let manifest: Manifest
    let database: Database
    
    var body: some View {
        List(manifest.tasks) { task in
            ManifestTaskRow(task: task, onCompletionChange: { self.onTaskChange(taskID: task.id, newStatus: $0) })
                .buttonStyle(PlainButtonStyle())
        }
        .navigationTitle(manifest.title)
    }
    
    func onTaskChange(taskID: UUID, newStatus: Bool) {
        database.updateCompletionStatus(for: taskID, to: newStatus, in: manifest.id)
    }
}

struct ManifestList_Previews: PreviewProvider {
    static var previews: some View {
        return ManifestList(manifest: .mock, database: Database())
    }
}
