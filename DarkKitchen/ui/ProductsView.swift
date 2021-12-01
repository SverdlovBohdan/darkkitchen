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
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 2),
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

    @ViewBuilder
    var body: some View {
        if isBorderNeeded {
            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(Color("MainPink"))
                    .shadow(radius: 7)

                VStack {
                    WebImage(url: URL(string: product.main_image.url), isAnimating: .constant(true))
                        .resizable()
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
            }
        } else {
            VStack {
                WebImage(url: URL(string: product.main_image.url), isAnimating: .constant(true))
                    .resizable()
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
        }
    }
}

private struct ProductsContentView: View {
    let title: String
    let products: Products
    let columns: [GridItem]

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach((0..<products.count), id: \.self) { idx in
                    if idx == 0 || idx == 3 {
                        ProductPreviewView(product: products[idx],
                                           isBorderNeeded: false)
                    } else if idx == 1 {
                        ProductPreviewView(product: products[idx],
                                           isBorderNeeded: true)
                    } else {
                        ProductPreviewView(product: products[idx],
                                           isBorderNeeded: true)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(Text(title))
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
