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
        HStack {
            Text(task.title)
            Spacer()
            CheckView(isChecked: task.completed, onChange: onCompletionChange)
        }
    }
}

struct ManifestTaskRow_Previews: PreviewProvider {
    static var previews: some View {
        ManifestTaskRow(task: ManifestTask(id: .init(), title: "Test", completedDate: nil), onCompletionChange: { _ in })
    }
}

struct CheckView: View {
   @State var isChecked:Bool = false
   func toggle(){
       isChecked = !isChecked
       onChange(isChecked)
   }
    let onChange: (Bool) -> Void
   var body: some View {
       Button(action: toggle){
           Image(systemName: isChecked ? "checkmark.square": "square")

       }

   }

}
