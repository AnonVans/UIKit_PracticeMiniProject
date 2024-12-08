//
//  RecipesListView.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 03/12/24.
//

import UIKit
import Combine

class RecipesListView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    private let recipeVM = RecipeViewModel.shared
    
    private let filter = UIScrollView()
    private let labelMessage = UILabel()
    private let layout = UICollectionViewFlowLayout()
    private var list: UICollectionView!
    
    private var cancleables = [AnyCancellable]()
    private var data = [MealEntity]()
    private var filterTag = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Choose Your Menu"
        self.navigationItem.largeTitleDisplayMode = .inline
        
        bindData()
        bindtag()
        setUpUI()
    }
    
    deinit {
        cancleables.forEach {$0.cancel()}
        cancleables.removeAll()
    }
    
    func bindData() {
        recipeVM.$displayRecipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.data = result
                
                DispatchQueue.main.async {
                    self.list.collectionViewLayout.collectionView?.reloadData()
                }
            }
            .store(in: &cancleables)
    }
    
    func bindtag() {
        recipeVM.$retrievedRecipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.filterTag = result.getOrigins()
                
                DispatchQueue.main.async {
                    self.resetFilter()
                    self.setUpFilter()
                }
            }
            .store(in: &cancleables)
    }
    
    func setUpUI() {
        setUpLayout()
        let searchBar = setUpSearchBar()
        setUpCollectionView()
        
        view.backgroundColor = UIColor.systemGray4
        view.addSubview(searchBar)
        view.addSubview(filter)
        
        if data.isEmpty && filterTag.isEmpty {
            setUpMessage()
        }
        
        view.addSubview(list)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            searchBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            filter.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            filter.bottomAnchor.constraint(equalTo: list.topAnchor, constant: -16),
            filter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            filter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            
            list.topAnchor.constraint(equalTo: filter.bottomAnchor, constant: 16),
            list.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            list.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            list.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            list.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
    }
    
    func setUpSearchBar() -> UIView {
        let searchBar = UIView()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 10
        
        let img = UIImageView()
        img.image = UIImage(systemName: "magnifyingglass")!
        img.tintColor = .systemGray3
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        searchBar.addSubview(img)
        
        let textField = UITextField()
        textField.placeholder = "Enter recipe name..."
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        searchBar.addSubview(textField)
        
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 8),
            img.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -8),
            img.widthAnchor.constraint(equalTo: searchBar.heightAnchor, multiplier: 0.75),
            img.heightAnchor.constraint(equalTo: searchBar.heightAnchor, multiplier: 0.75),
            img.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            
            textField.topAnchor.constraint(equalTo: searchBar.topAnchor),
            textField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -8)
        ])
        
        return searchBar
    }
    
    func setUpFilter() {
        filter.isScrollEnabled = true
        filter.alwaysBounceHorizontal = false
        filter.showsHorizontalScrollIndicator = false
        filter.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        for area in filterTag {
            let tag = ReusableTag(labelText: area, disable: false, size: 14)
            stack.addArrangedSubview(tag)
            
            NSLayoutConstraint.activate([
                tag.heightAnchor.constraint(equalTo: stack.heightAnchor),
                tag.centerYAnchor.constraint(equalTo: stack.centerYAnchor)
            ])
        }
        
        filter.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: filter.topAnchor),
            stack.bottomAnchor.constraint(equalTo: filter.bottomAnchor),
            stack.centerYAnchor.constraint(equalTo: filter.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: filter.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: filter.trailingAnchor)
        ])
    }
    
    func setUpMessage() {
        labelMessage.text = "Start Searching For Recipes\nby Inputing Search Bar."
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        labelMessage.textAlignment = .center
        labelMessage.numberOfLines = 2
        
        view.addSubview(labelMessage)
        
        NSLayoutConstraint.activate([
            labelMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setUpLayout() {
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
    }
    
    func setUpCollectionView() {
        list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.dataSource = self
        list.delegate = self
        list.backgroundColor = .clear
        list.register(CardItemCell.self, forCellWithReuseIdentifier: "Cell")
        list.showsVerticalScrollIndicator = false
        list.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.itemSize = CGSize(width: (list.frame.width - 12) / 2, height: list.frame.height * 0.3)
        list.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardItemCell {
            cell.configure(with: data[indexPath.row])
            returnCell = cell
        }
        return returnCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(RecipeDetailView.create(recipe: data[indexPath.row]), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        view.endEditing(true)
        Task {
            do {
                try await recipeVM.populateData(name: text)
                self.labelMessage.removeFromSuperview()
            } catch {
                self.recipeVM.resetData()
                self.setUpMessage()
                self.labelMessage.text = "No Data Found\nTry Searching Another Recipe."
            }
        }
        
        return true
    }
    
    func resetFilter() {
        filter.subviews.forEach { $0.removeFromSuperview() }
    }
}

#Preview {
    RecipesListView()
}
