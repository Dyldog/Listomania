//
//  BlueprintTaskRow.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

struct BlueprintTaskRow: View {
    let task: BlueprintTask
    var body: some View {
        Text(task.title)
    }
}
