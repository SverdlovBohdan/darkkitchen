//
//  MenuView.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 20.11.2021.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//private struct ProductPreviewView: View {
//    var category: ProductCategory
//    var isBorderNeeded: Bool
//
//    var body: some View {
//        Text(category.name)
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .background(RoundedCornersShape(corners: [.topLeft], radius: 15)
//                            .stroke(Color("MainBlue"), lineWidth: 1))
//    }
//}

//private struct CategoryView {
//    private let categories: ProductCategories
//    private var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0),
//                                            count: 2)
//
//    init(categories: ProductCategories) {
//        self.categories = categories
//    }
//
//    var body: some View {
//        ZStack {
//            Color("MainPink")
//                .ignoresSafeArea()
//
//            ScrollView {
//                LazyVGrid(columns: columns) {
//                    ForEach((0...20), id: \.self) { _ in
//                        ProductPreviewView(category: ProductCategory(id: 1, name: "category1"),
//                                           isBorderNeeded: true)
//                    }
//                }
//            }
//        }
//    }
//}

struct MenuRow: View {
    var category: ProductCategory
    var isLeftShifted: Bool

    var body: some View {
        HStack {
            if !isLeftShifted {
                Spacer()
            }

            NavigationLink {
                Text("Блюда для категории")
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
