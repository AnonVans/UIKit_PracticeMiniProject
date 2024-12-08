//
//  RecipeViewModel.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 04/12/24.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    static let shared = RecipeViewModel()
    private var areas = [String]()
    @Published var retrievedRecipes = [MealEntity]()
    @Published var displayRecipes = [MealEntity]()
    
    private let networkManager = NetworkServiceManager.shared
    
    func populateData(name: String) async throws {
        do {
            let data = try await networkManager.fetchMealRecipes(containing: name)
            self.retrievedRecipes = data.mapMeals()
            self.areas = [String]()
            self.filterRecipe()
            
            if data.mapMeals().isEmpty {
                throw ErrorMessage.NoData
            }
        } catch {
            throw ErrorMessage.ActionFailure
        }
    }
    
    func filterRecipe() {
        if !areas.isEmpty {
            self.displayRecipes = retrievedRecipes.filter { self.areas.contains($0.origin ?? "") }
        } else {
            self.displayRecipes = retrievedRecipes
        }
    }
    
    func addFilter(filter area: String) {
        self.areas.append(area)
        self.filterRecipe()
    }
    
    func removeFilter(filter area: String) {
        self.areas.removeAll { $0 == area }
        self.filterRecipe()
    }
    
    func resetData() {
        self.retrievedRecipes.removeAll()
        self.displayRecipes.removeAll()
    }
}
