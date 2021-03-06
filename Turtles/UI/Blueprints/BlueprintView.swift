//
//  BlueprintRow.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

struct BlueprintView: View {
    let blueprint: Blueprint
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(blueprint.title)
            Text("\(blueprint.allTasks().count) tasks")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let subString = blueprint.childSubBlueprintString().mapEmptyToNil() {
                Text(subString)
                    .font(.caption2)
            }
        }
            
    }
}
