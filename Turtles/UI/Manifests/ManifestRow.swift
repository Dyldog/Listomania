//
//  ManifestRow.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

struct ManifestRow: View {
    let manifest: Manifest
    
    var body: some View {
        HStack {
            Text(manifest.title)
            Spacer()
            Text("\(manifest.completedTasks.count)/\(manifest.tasks.count)")
                .font(.headline)
        }
    }
}
