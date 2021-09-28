//
//  SearchView.swift
//  Turtles
//
//  Created by Dylan Elliott on 28/9/21.
//

import SwiftUI

protocol SearchItem {
    var title: String { get }
}

struct SearchView<Item: SearchItem>: View {
    let title: String
    let items: [Item]
    let completion: (Item, String) -> Void
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List(filteredItems(), id: \.title) { item in
                    Button {
                        completion(item, searchText)
                    } label: {
                        HStack {
                            Text(item.title)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle(title)
        }
    }
    
    func filteredItems() -> [Item] {
        guard searchText.isEmpty == false else { return items }
        
        func sanitise(text: String) -> String {
            return text.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .joined()
        }
        
        return items.filter { item in
            return sanitise(text: item.title).contains(sanitise(text: searchText))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    struct PreviewSearchItem: SearchItem {
        let t: String
        var title: String { t }
        
    }
    static var previews: some View {
        SearchView(
            title: "Add Blueprint",
            items: [PreviewSearchItem(t: "Hey")],
            completion: { _,_ in }
        )
    }
}
