//
//  ManifestTaskRow.swift
//  Turtles
//
//  Created by Dylan Elliott on 27/9/21.
//

import SwiftUI

struct ManifestTaskRow: View {
    let task: ManifestTask
    let onCompletionChange: (Bool) -> Void
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            CheckView(isChecked: task.completed, onChange: onCompletionChange)
                .frame(height: 20)
            Text(task.title)
                .font(.headline)
                .fontWeight(.regular)
            
        }
    }
}

struct ManifestTaskRow_Previews: PreviewProvider {
    static var previews: some View {
        ManifestTaskRow(task: ManifestTask(id: .init(), title: "Test", completedDate: nil), onCompletionChange: { _ in })
    }
}
