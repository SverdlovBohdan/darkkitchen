//
//  CategoryView.swift
//  DarkKitchen
//
//  Created by Bohdan Sverdlov on 22.11.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductsView: View {
    @EnvironmentObject var appState: AppState
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0),
                                            count: 2)

    let category: ProductCategory

    var body: some View {
        ZStack {
            Color("MainPink")
                .ignoresSafeArea()

            makeProductsView()
        }
    }
}

private extension ProductsView {
    @ViewBuilder func makeProductsView() -> some View {
        if appState.fullMenuState.isIdle {
            Text("Самая быстрая рука на диком западе. Мы еще запрос не отправили")
        } else if appState.fullMenuState.isLoading {
            ProgressView()
        } else if let products = appState.fullMenuState.resource {
            ProductsContentView(title: category.name,
                                products: products.filter { $0.category.id == category.id },
                                columns: columns)
        } else {
            Text("Опаньки. Произошла ошибка")
        }
    }
}

private struct ProductPreviewView: View {
    var product: Product
    var isBorderNeeded: Bool
    var corners: UIRectCorner = []

    var body: some View {
        VStack {
            WebImage(url: URL(string: product.main_image.url), isAnimating: .constant(true))
                .resizable()
//                 .placeholder {
//                     Image(systemName: "photo")
//                 }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()

            Text("\(product.price)₴")
                .font(.title)
                .bold()
            Text(product.name)
                .font(.subheadline)
        }
        .padding()
        .background(RoundedCornersShape(corners: corners, radius: 30)
                        .stroke(Color("MainBlue"), lineWidth: 1))
    }
}

private struct ProductsContentView: View {
    let title: String
    let products: Products
    let columns: [GridItem]

    var body: some View {
        ScrollView {
            HStack {
                Text(title)
                    .font(.system(size: 45, weight: .bold, design: .default))

                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach((0..<products.count), id: \.self) { idx in
                    if idx == 0 {
                        ProductPreviewView(product: products[idx],
                                           isBorderNeeded: false,
                                           corners: [.topLeft])
                    } else if idx == 1 {
                        ProductPreviewView(product: products[idx],
                                           isBorderNeeded: true,
                                           corners: [.topRight])
                    } else {
                        ProductPreviewView(product: products[idx],
                                           isBorderNeeded: Int.random(in: 0..<100) < 33)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var appState: AppState = {
        let appState = AppState()
        GlobalObjectsContainer.injectDevelopmentEnvironment(appState: appState)
        InjectedValues[\.tokenRepository].setToken("test token")
        return appState
    }()

    static var previews: some View {
        ProductsView(category: ProductCategory(id: 1, name: "category1"))
            .environmentObject(appState)
    }
}
