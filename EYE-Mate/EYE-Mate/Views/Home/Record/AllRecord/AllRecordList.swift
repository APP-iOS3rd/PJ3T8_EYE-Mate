//
//  AllRecordList.swift
//  EYE-Mate
//
//  Created by seongjun on 2/15/24.
//

import SwiftUI

struct AllRecordList: View {
    @State private var items = ["Item 1", "Item 2", "Item 3"]

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: deleteItem)
            }
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

#Preview {
    AllRecordList()
}
