//
//  UIApplication+IsTest.swift
//  Listomania
//
//  Created by Dylan Elliott on 17/12/2022.
//

import UIKit

extension UIApplication {
    
    /// Checks the command line arguments for the current process to see if a UI test is running.
    public static var isUITest: Bool {
        return CommandLine.arguments.contains("-ui_testing")
    }
}
