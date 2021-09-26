//
//  ListList.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

struct ListList: View {
    let manifests: [Manifest]
    let blueprints: [Blueprint]
    @State var state: ScreenState = .normal
    
    var body: some View {
        List {
            Section(header: Text("Manifests")) {
                ForEach(manifests) { manifest in
                    ManifestRow(manifest: manifest)
                }
            }
            
            Section(header: Text("Blueprints")) {
                ForEach(blueprints) { blueprint in
                    Button(action: {}, label: { BlueprintRow(blueprint: blueprint) })
                }
            }
        }
    }
}

extension ListList {
    enum ScreenState {
        case normal
        case showingActionSheet(Blueprint)
    }
}
