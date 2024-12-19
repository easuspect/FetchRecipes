//
//  ContentView.swift
//  Recipe
//
//  Created by Tolga Telseren on 12/12/24.
//

import SwiftUI

struct RecipeCell: View {
    
    let recipe: Recipe
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2){
            RecipeRemoteImage(urlString: recipe.photoURLLarge)
            .aspectRatio(contentMode: .fit)
            .frame(width: 160, height: 160)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.name)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(recipe.cuisine)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
                .padding(4)
        }
        .frame(width: 160, height: 200)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct RecipeCell_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCell(recipe: MockData.sampleRecipe)
    }
}
