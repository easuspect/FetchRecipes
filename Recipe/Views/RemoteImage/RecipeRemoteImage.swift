//
//  RecipeRemoteImage.swift
//  Recipe
//
//  Created by Tolga Telseren on 12/12/24.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    @MainActor
    func load(fromURLString urlString: String) async {
        guard let uiImage = await NetworkManager.shared.downloadImage(fromURLString: urlString) else { return }
        self.image = Image(uiImage: uiImage)
    }
}

struct RemoteImage: View {
    
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image("food-placeholder").resizable()
    }
}


struct RecipeRemoteImage: View {
    
    @StateObject var imageLoader = ImageLoader()
    
    let urlString: String
    
    var body: some View {
        RemoteImage(image: imageLoader.image)
        .task {
            await imageLoader.load(fromURLString: urlString)
            
        }
    }
}

