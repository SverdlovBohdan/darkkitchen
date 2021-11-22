//
//  MenuView.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 20.11.2021.
//

import SwiftUI

private struct MenuRow: View {
    let category: ProductCategory
    let isLeftShifted: Bool

    var body: some View {
        HStack {
            if !isLeftShifted {
                Spacer()
            }

            NavigationLink {
                ProductsView(category: category)
            } label: {
                Text(category.name)
                    .font(.system(size: 50, weight: .bold, design: .default))
            }

            if isLeftShifted {
                Spacer()
            }
        }
    }
}

struct MenuView: View {
    private let categories: ProductCategories
    private let error: String?

    init(categories: ProductCategories) {
        self.categories = categories
        self.error = nil
    }

    init(error: String) {
        self.categories = .init()
        self.error = error
    }

    var body: some View {
        ZStack {
            Color("MainPink")
                .ignoresSafeArea()

            if let error = error {
                Text(error)
            } else {
                ScrollView {
                    ForEach((0..<categories.count), id: \.self) { idx in
                        MenuRow(category: categories[idx],
                                isLeftShifted: getRingIndex(idx: idx, total: 6) < 3)
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
        }
    }
}

private extension MenuView {
    func getRingIndex(idx: Int, total: Int) -> Int {
        return idx % total
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuView(categories: [ProductCategory(id: 1, name: "category1"),
                                  ProductCategory(id: 2, name: "category2"),
                                  ProductCategory(id: 3, name: "category3"),
                                  ProductCategory(id: 4, name: "category4"),
                                  ProductCategory(id: 5, name: "category5")])
        }
    }
}
