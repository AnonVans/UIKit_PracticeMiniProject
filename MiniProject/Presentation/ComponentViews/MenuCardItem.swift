//
//  MenuCardItem.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 03/12/24.
//

import UIKit

class MenuCardItem: UIView {
    private var cardData: MealEntity
    
    init(cardData: MealEntity, frame: CGRect) {
        self.cardData = cardData
        super.init(frame: frame)
        
        let thumbnail = UIImageView()
        thumbnail.loadCardImage(srclink: cardData.thumbnail ?? "")
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        thumbnail.layer.cornerRadius = 10
        thumbnail.clipsToBounds = true
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        
        let tagLabel = ReusableTag(labelText: cardData.origin ?? "", disable: true, size: 14)
        
        let titleLabel = UILabel()
        titleLabel.text = cardData.mealName ?? ""
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumbnail)
        self.addSubview(titleLabel)
        self.addSubview(tagLabel)
        
        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            thumbnail.topAnchor.constraint(equalTo: self.topAnchor),
            thumbnail.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            thumbnail.widthAnchor.constraint(equalToConstant: self.frame.width),
            thumbnail.heightAnchor.constraint(equalToConstant: self.frame.height - 56),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: tagLabel.topAnchor, constant: -4),
            
            tagLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            tagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            tagLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    MenuCardItem(
        cardData: MealEntity(mealName: "Test", category: "TestCat", origin: "Test", instruction: "Test", thumbnail: "https://www.themealdb.com/images/media/meals/pkopc31683207947.jpg", ytTutorial: "Test", ingredients: ["Test"], referenceSource: "Test"),
        frame: CGRect(x: 0, y: 0, width: 700, height: 600)
    )
}
