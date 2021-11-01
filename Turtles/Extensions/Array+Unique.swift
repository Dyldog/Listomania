//
//  Array+Unique.swift
//  Listomania
//
//  Created by Dylan Elliott on 1/11/21.
//

import Foundation

extension Array {
    func uniqueElements() -> [Element] where Element: Hashable {
        Array(Set(self))
    }
}
