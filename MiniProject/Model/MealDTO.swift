//
//  MealDTO.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 02/12/24.
//

import Foundation

struct MealEntity {
    let mealName: String?
    let category: String?
    let origin: String?
    let instruction: String?
    let thumbnail: String?
    let ytTutorial: String?
    let ingredients: [String]?
    let referenceSource: String?
    
    func generateCleanInstructions() -> String {
        guard
            let instruction = self.instruction
        else {
            return self.instruction ?? ""
        }
        
        if instruction.contains("0.\t") {
            return cleanOrderNumber(pattern: "\\d+\\.\\t")
        } else {
            return cleanNoNumber()
        }
    }
    
    func cleanOrderNumber(pattern: String) -> String {
        var newInstructions = self.instruction ?? ""
        let regexPattern = pattern
        
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else { return newInstructions }
        
        let range = NSRange(newInstructions.startIndex..., in: newInstructions)
        regex.enumerateMatches(in: newInstructions, range: range) { match, _, _ in
            guard
                let matchRange = match?.range,
                let stringRange = Range(matchRange, in: newInstructions),
                let orderString = newInstructions[stringRange].first
            else {
                return
            }
            
            let instructionOrder = Int(String(orderString)) ?? 0
            newInstructions.replaceSubrange(stringRange, with: "\(instructionOrder + 1). ")
        }
        
        return newInstructions
    }
    
    func cleanNoNumber() -> String {
        let newInstructions = self.instruction ?? ""
        return "•  " + newInstructions.replacingOccurrences(of: ".\r\n", with: ".\r\n•  ")
    }
}

extension [MealEntity] {
    func getOrigins() -> [String] {
        var origins = [String]()
        
        for meal in self {
            guard let origin = meal.origin else { continue }
            if !origins.contains(origin) {
                origins.append(origin)
            }
        }
        
        return origins
    }
}

struct MealsDTO: Codable {
    var meals: [[String: String?]]
}

extension MealsDTO {
    func mapMeals() -> [MealEntity] {
        var mappedMeals = [MealEntity]()
        
        for meal in self.meals {
            var ingredients = [String]()
            
            for i in 1...20 {
                let ingredientKey = JSONCodingKey.ingredients.rawValue + "\(i)"
                let measurementKey = JSONCodingKey.measurement.rawValue + "\(i)"
                
                guard
                    let ingredient = meal[ingredientKey] ?? nil,
                    let measurement = meal[measurementKey] ?? nil
                else {
                    continue
                }
                
                if !ingredient.isEmpty && !measurement.isEmpty {
                    ingredients.append("•  " + ingredient + " " + measurement)
                }
            }
            
            mappedMeals.append(
                MealEntity(
                    mealName: meal[JSONCodingKey.mealName.rawValue] ?? nil,
                    category: meal[JSONCodingKey.category.rawValue] ?? nil,
                    origin: meal[JSONCodingKey.origin.rawValue] ?? nil,
                    instruction: meal[JSONCodingKey.instructions.rawValue] ?? nil,
                    thumbnail: meal[JSONCodingKey.thumbnail.rawValue] ?? nil,
                    ytTutorial: meal[JSONCodingKey.tutorial.rawValue] ?? nil,
                    ingredients: ingredients,
                    referenceSource: meal[JSONCodingKey.reference.rawValue] ?? nil
                )
            )
        }
        
        return mappedMeals
    }
}
