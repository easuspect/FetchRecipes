//
//  RecipeListViewModel.swift
//  Recipe
//
//  Created by Tolga Telseren on 12/12/24.
//

import SwiftUI

final class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    
    @MainActor
    func getRecipes() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            recipes = try await NetworkManager.shared.getRecipes()
        } catch {
            switch error {
            case RecipeError.invalidURL:
                alertItem = AlertContext.invalidURL
            case RecipeError.invalidResponse:
                alertItem = AlertContext.invalidResponse
            case RecipeError.invalidData:
                alertItem = AlertContext.InvalidData
            case RecipeError.unableToComplete:
                alertItem = AlertContext.unableToComplete
            default:
                break
            }
        }
    }
}
