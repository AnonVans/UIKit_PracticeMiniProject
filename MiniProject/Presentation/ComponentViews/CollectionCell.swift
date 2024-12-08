//
//  CollectionCell.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 04/12/24.
//

import UIKit

class CardItemCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(with item: MealEntity) {
        let cardItem = MenuCardItem(cardData: item, frame: self.bounds)
        cardItem.translatesAutoresizingMaskIntoConstraints = false
        cardItem.layer.cornerRadius = 10
        
        self.isUserInteractionEnabled = true
        self.addSubview(cardItem)
        
        NSLayoutConstraint.activate([
            cardItem.topAnchor.constraint(equalTo: self.topAnchor),
            cardItem.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardItem.widthAnchor.constraint(equalTo: self.widthAnchor),
            cardItem.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
