//
//  NetworkManager.swift
//  Recipe
//
//  Created by Tolga Telseren on 12/12/24.
//

import UIKit
import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private var images: [String: UIImage] = [:]
    
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    private init() { }
    
    func getRecipes() async throws -> [Recipe] {
        
        guard let url = URL(string: baseURL) else {
            throw RecipeError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw RecipeError.invalidResponse
            }
            
            return try Self.parseData(data: data)
        } catch {
            throw RecipeError.unableToComplete
        }
    }
    
    static func parseData(data: Data) throws -> [Recipe] {
        let decoder = JSONDecoder()
        if let decodedResponse = try? decoder.decode(RecipeResponse.self, from: data) {
            return decodedResponse.recipes
        } else {
            throw RecipeError.invalidData
        }
    }
    
    func downloadImage(fromURLString urlString: String) async -> UIImage? {
        
        if let image = images[urlString] { return image }
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        print(urlString)
        
        let components = urlString.components(separatedBy: "/")
        guard components.count > 1 else { return nil }
        let id = components[components.count - 2]
        
        let fileURL = documentsDirectory.appendingPathComponent(id)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let image = UIImage(contentsOfFile: fileURL.path())
            await MainActor.run {
                images[urlString] = image
            }
            return image
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {

            let (data, _) = try await URLSession.shared.data(from: url)
        
            if let image = UIImage(data: data) {
                if let data = image.pngData() {
                    try? data.write(to: fileURL)
                }
                await MainActor.run {
                    images[urlString] = image
                }
                return image
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
