//
//  TagLabel.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 03/12/24.
//

import UIKit

class ReusableTag: UIButton {
    private var recipeVM = RecipeViewModel.shared
    var labelText: String
    var disable: Bool
    var isTapped: Bool = false
    
    init(labelText: String, disable: Bool, size: CGFloat) {
        self.labelText = labelText
        self.disable = disable
        
        super.init(frame: .zero)
        self.setTitle(self.labelText, for: .normal)
        self.contentHorizontalAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: size)
        self.backgroundColor = UIColor.systemGray2
        self.layer.cornerRadius = size * 0.7
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.black.cgColor
        
        self.addTarget(self, action: #selector(didTap), for: .touchDown)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: self.intrinsicContentSize.width + 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTap() {
        if !self.disable {
            if isTapped {
                self.layer.borderWidth = 0
                self.backgroundColor = .systemGray2
                isTapped = false
                recipeVM.removeFilter(filter: self.labelText)
            } else {
                self.layer.borderWidth = 1
                self.backgroundColor = .systemGray6
                isTapped = true
                recipeVM.addFilter(filter: self.labelText)
            }
        }
    }
}

#Preview {
    ReusableTag(labelText: "Moroccan", disable: true, size: 24)
}
