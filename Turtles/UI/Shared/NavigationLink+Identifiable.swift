//
//  NavigationLink+Identifiable.swift Go to file  .swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import SwiftUI

extension NavigationLink where Label == EmptyView {
  public init?<V: Identifiable>(
    item: Binding<V?>,
    destination: @escaping (V) -> Destination
  ) {
    if let value = item.wrappedValue {
      let isActive: Binding<Bool> = Binding(
        get: { item.wrappedValue != nil },
        set: { value in
          if !value {
            item.wrappedValue = nil
          }
        }
      )

      self.init(
        destination: destination(value),
        isActive: isActive,
        label: EmptyView.init
      )
    } else {
      return nil
    }
  }
}

extension View {
  func navigation<V: Identifiable, Destination: View>(
    item: Binding<V?>,
    destination: @escaping (V) -> Destination
  ) -> some View {
    background(NavigationLink(item: item, destination: destination))
  }
}
