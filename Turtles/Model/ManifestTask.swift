//
//  ManifestTask.swift
//  Turtles
//
//  Created by Dylan Elliott on 27/9/21.
//

import Foundation

struct ManifestTask: Identifiable {
    let id: UUID
    let title: String
    var completedDate: Date?
    var completed: Bool {
        get { completedDate != nil }
        set { completedDate = newValue ? Date() : nil }
    }
}
