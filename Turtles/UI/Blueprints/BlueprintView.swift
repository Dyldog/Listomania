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
            
            Text(blueprint.childSubBlueprintString())
                .font(.caption2)
        }
            
    }
}
