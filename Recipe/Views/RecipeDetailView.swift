//
//  RecipeDetailView.swift
//  Recipe
//
//  Created by Tolga Telseren on 12/14/24.
//

import SwiftUI

struct RecipeDetailView: View {
    
    var recipe: Recipe
    
    var body: some View {
        
        
        VStack {
            RecipeRemoteImage(urlString: recipe.photoURLLarge)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
                .padding()
            
            Text(recipe.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            Text("\(recipe.cuisine)")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.bottom, 16)
            
            
            
            if let youtubeURL = recipe.youtubeURL, let url = URL(string: youtubeURL) {
                Button(action: { UIApplication.shared.open(url) }) {
                    Text("Watch on YouTube")
                        .foregroundColor(.blue)
                        .underline()
                }
            }
        }
        .padding()
    }
}
    
