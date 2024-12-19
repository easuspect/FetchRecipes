//
//  RecipeListView.swift
//  Recipe
//
//  Created by Tolga Telseren on 12/12/24.
//
import SwiftUI

struct RecipeListView: View {
    
    @State private var searchText = ""
    @StateObject var viewModel = RecipeListViewModel()
    @State private var selectedRecipe: Recipe? 
    @State private var isShowingPopup = false
    
    @State private var sortValue: SortValue = .recipeAZ
    
    private enum SortValue {
        case recipeAZ, recipeZA, cuisineAZ, cuisineZA
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredRecipes: [Recipe] {
        
        let recipes = viewModel.recipes.sorted {
            switch sortValue {
            case .recipeAZ:
                $0.name < $1.name
            case .recipeZA:
                $0.name > $1.name
            case .cuisineAZ:
                $0.cuisine < $1.cuisine
            case .cuisineZA:
                
                $0.cuisine > $1.cuisine
            }
        }
        
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { recipe in
                recipe.name.lowercased().contains(searchText.lowercased()) ||
                recipe.cuisine.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if viewModel.recipes.isEmpty {
                VStack {
                    Text("No Recipes")
                        .foregroundStyle(.secondary)
                        .font(.title3)
                    Image("food-placeholder")
                        .resizable()
                        .frame(width: 150, height: 150)
                    
                    Button("Reload") {
                        Task {
                            await viewModel.getRecipes()
                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filteredRecipes) { recipe in
                            RecipeCell(recipe: recipe)
                                .onTapGesture {
                                    selectedRecipe = recipe
                                    withAnimation(.easeInOut(duration: 0.5)) { // Smooth animation
                                        isShowingPopup = true
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle("Recipes")
                    .refreshable {
                        await viewModel.getRecipes()
                    }
                    .sheet(item: $selectedRecipe) { recipe in
                        RecipeDetailView(recipe: recipe)
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Menu("", systemImage: "arrow.up.arrow.down") {
                            Button("Recipe A->Z", action: { sortValue = .recipeAZ })
                            Button("Recipe Z->A", action: { sortValue = .recipeZA })
                            Button("Cusine A->Z", action: { sortValue = .cuisineAZ })
                            Button("Cusine Z->A", action: { sortValue = .cuisineZA })
                        }
                    }
                }
            }
            
        }
        .task {
            await viewModel.getRecipes()
        }
        .searchable(text: $searchText, prompt: "Search by name or cuisine")
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
    
    func sortPressed() {
        print("Sort Pressed")
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}

