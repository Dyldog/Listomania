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
        Text(manifest.title)
    }
}
