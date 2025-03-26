//
//  ContentView.swift
//  Fetch Recipe
//
//  Created by Abdul Kalam Ansari on 11/03/25.
//

import SwiftUI

// Model to represent a Product
struct Product: Identifiable, Codable {
    let uuid: String
    var id: String { uuid }
    let name: String
    let cuisine: String
    let photo_url_small: String
}
struct ProductResponse: Codable {
    let recipes: [Product]
}

// ViewModel to handle API fetching
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    func fetchProducts() {
//        guard let url = URL(string: "https://api.example.com/products") else { return }
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data {
                print("Raw JSON response: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                
                do {
                    
                    let decodedResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.products = decodedResponse.recipes
                    }
                    
                    
//                    let decodedResponse = try JSONDecoder().decode([Product].self, from: data)
//                    DispatchQueue.main.async {
//                        self.products = decodedResponse.recipes
//                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()

//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                do {
//                    let decodedResponse = try JSONDecoder().decode([Product].self, from: data)
//                    DispatchQueue.main.async {
//                        self.products = decodedResponse
//                    }
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//        }.resume()
    }
}

// ProductRow View
struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.photo_url_small)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
//                Text("$\(product.price, specifier: "%.2f")")
                Text(product.cuisine)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
    }
}

// Main ContentView
struct ContentView: View {
    @StateObject var viewModel = ProductViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                ProductRow(product: product)
            }
            .navigationTitle("Products")
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}

#Preview {
    ContentView()
}
//This is the first screen

