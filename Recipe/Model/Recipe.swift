//
//  Recipe.swift
//  Recipe
//
//  Created by Tolga Telseren on 12/12/24.
//

import Foundation

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable, Identifiable {
    var id: String { uuid }
    let cuisine: String
    let name: String
    let photoURLLarge: String
    let photoURLSmall: String
    let sourceURL: String?
    let uuid: String
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}


struct MockData {
    
    static let sampleRecipe = Recipe(
        cuisine: "Malaysian",
        name: "Apam Balik",
        photoURLLarge: "https://example.com/large.jpg",
        photoURLSmall: "https://example.com/small.jpg",
        sourceURL: "https://example.com",
        uuid: "1",
        youtubeURL: "https://youtube.com"
    )
    static let recipes = [sampleRecipe, sampleRecipe, sampleRecipe, sampleRecipe]
}




