//
//  BlueprintRow.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

struct BlueprintRow: View {
    let blueprint: Blueprint
    
    var body: some View {
        Text(blueprint.title)
    }
}
