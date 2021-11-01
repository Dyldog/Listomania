//
//  String+MapEmpty.swift
//  Listomania
//
//  Created by Dylan Elliott on 1/11/21.
//

import Foundation

extension String {
    func mapEmptyToNil() -> String? {
        return isEmpty ? nil : self
    }
}
