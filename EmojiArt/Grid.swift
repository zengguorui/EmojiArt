//
//  Grid.swift
//  MemorizeDemo
//
//  Created by 曾国锐 on 2021/10/22.
//

import SwiftUI

extension Grid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \Item.id, viewForItem: viewForItem)
    }
}

struct Grid<Item, ID, ItemView>: View where Item: Identifiable, ID:Hashable, ItemView: View{
    private var items: [Item]
    private var id: KeyPath<Item, ID>
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], id: KeyPath<Item, ID>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(items, id: id) { item in
                body(for: item, in: GridLayout(itemCount: items.count, in: geometry.size))
            }
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id] })
        return  viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index!))
    }
}
