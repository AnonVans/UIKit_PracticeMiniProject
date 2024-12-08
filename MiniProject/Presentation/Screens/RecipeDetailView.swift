//
//  RecipeDetailView.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 03/12/24.
//

import UIKit

class RecipeDetailView: UIViewController {
    var recipe: MealEntity!
    
    static func create(recipe: MealEntity) -> RecipeDetailView {
        let viewController = RecipeDetailView()
        viewController.recipe = recipe
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray4
        title = recipe.mealName ?? ""
        navigationItem.largeTitleDisplayMode = .inline
        setUpUI()
    }
    
    func setUpUI() {
        let thumbnail = setUpThumbnailImage()
        let areaTag = ReusableTag(labelText: recipe.origin ?? "", disable: true, size: 24)
        let ingredientsList = setUpIngredients()
        let stepByStep = setUpInstruction()
        let tutorial = setUpTutorial()
        
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(thumbnail)
        scrollView.addSubview(areaTag)
        scrollView.addSubview(ingredientsList)
        scrollView.addSubview(stepByStep)
        scrollView.addSubview(tutorial)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            thumbnail.topAnchor.constraint(equalTo: scrollView.topAnchor),
            thumbnail.bottomAnchor.constraint(equalTo: areaTag.topAnchor, constant: -16),
            thumbnail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            areaTag.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 16),
            areaTag.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            areaTag.bottomAnchor.constraint(equalTo: ingredientsList.topAnchor, constant: -16),
            
            ingredientsList.topAnchor.constraint(equalTo: areaTag.bottomAnchor, constant: 16),
            ingredientsList.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            ingredientsList.bottomAnchor.constraint(equalTo: stepByStep.topAnchor, constant: -16),
            
            stepByStep.topAnchor.constraint(equalTo: ingredientsList.bottomAnchor, constant: 16),
            stepByStep.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stepByStep.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stepByStep.bottomAnchor.constraint(equalTo: tutorial.topAnchor, constant: -16),
            
            tutorial.topAnchor.constraint(equalTo: stepByStep.bottomAnchor, constant: 16),
            tutorial.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            tutorial.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func setUpThumbnailImage() -> UIImageView {
        let thumbnail = UIImageView()
        thumbnail.loadDetailImage(srclink: recipe.thumbnail ?? "")
        thumbnail.contentMode = .scaleAspectFit
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        
        return thumbnail
    }
    
    func setUpIngredients() -> UIStackView {
        let ingredientsStack = UIStackView()
        ingredientsStack.axis = .vertical
        ingredientsStack.spacing = 4
        ingredientsStack.alignment = .leading
        ingredientsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Ingredients:"
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.textColor = .black
        title.textAlignment = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        ingredientsStack.addArrangedSubview(title)
        
        for ingredient in recipe.ingredients ?? [] {
            let ingredientLabel = UILabel()
            ingredientLabel.text = ingredient
            ingredientLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            ingredientLabel.textColor = .black
            ingredientLabel.textAlignment = .left
            ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
            
            ingredientsStack.addArrangedSubview(ingredientLabel)
        }
        
        return ingredientsStack
    }
    
    func setUpInstruction() -> UIStackView {
        let instructionStack = UIStackView()
        instructionStack.axis = .vertical
        instructionStack.spacing = 4
        instructionStack.alignment = .leading
        instructionStack.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Instructions:"
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.textColor = .black
        title.textAlignment = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        instructionStack.addArrangedSubview(title)
        
        let instructions = UITextView()
        instructions.text = recipe.generateCleanInstructions()
        instructions.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        instructions.textColor = .black
        instructions.translatesAutoresizingMaskIntoConstraints = false
        instructions.isEditable = false
        instructions.backgroundColor = .clear
        instructions.isScrollEnabled = false
        instructionStack.addArrangedSubview(instructions)
        
        return instructionStack
    }
    
    func setUpTutorial() -> UIStackView {
        let tutorialStack = UIStackView()
        tutorialStack.axis = .horizontal
        tutorialStack.spacing = 10
        tutorialStack.alignment = .leading
        tutorialStack.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Available on Youtube:"
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.textColor = .black
        title.textAlignment = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        tutorialStack.addArrangedSubview(title)
        
        let tutorialButton = UIButton()
        tutorialButton.backgroundColor = .red
        tutorialButton.layer.cornerRadius = 5
        tutorialButton.addTarget(self, action: #selector(openTutorial), for: .touchDown)
        
        let image = UIImageView()
        image.image = UIImage(systemName: "play.rectangle.fill")
        image.tintColor = UIColor.white
        image.translatesAutoresizingMaskIntoConstraints = false
        
        tutorialButton.addSubview(image)
        tutorialStack.addArrangedSubview(tutorialButton)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: tutorialButton.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: tutorialButton.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: (tutorialButton.intrinsicContentSize.width - 4)),
            
            tutorialButton.heightAnchor.constraint(equalTo: title.heightAnchor),
            tutorialButton.widthAnchor.constraint(equalTo: title.heightAnchor)
        ])
        
        return tutorialStack
    }
    
    @objc func openTutorial() {
        guard let url = URL(string: recipe.ytTutorial ?? "") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    RecipeDetailView.create(
        recipe: MealEntity(
            mealName: "Test", category: "Test", origin: "Test", instruction: "Test", thumbnail: "Test", ytTutorial: "Test", ingredients: ["Test", "Test", "Test"], referenceSource: "Test"
        )
    )
}
