//
//  NetworkServiceManager.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 02/12/24.
//

import Foundation

class NetworkServiceManager {
    static let shared = NetworkServiceManager()
    
    func fetchMealRecipes(containing: String) async throws -> MealsDTO {
        var request = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=" + containing)!)
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let retrievedData = try decoder.decode(MealsDTO.self, from: data)
            
            if retrievedData.meals.isEmpty {
                throw ErrorMessage.NoData
            } else {
                return retrievedData
            }
        } catch {
            throw ErrorMessage.ActionFailure
        }
    }
}
