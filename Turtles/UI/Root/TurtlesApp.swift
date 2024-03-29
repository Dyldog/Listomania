//
//  TurtlesApp.swift
//  Turtles
//
//  Created by Dylan Elliott on 26/9/21.
//

import SwiftUI

@main
struct TurtlesApp: App {
    init() {
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListList(database: Database())
                .onAppear {
                  NotificationHandler.shared.requestPermission()
               }
            }
        }
    }
}
