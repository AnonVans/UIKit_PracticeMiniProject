//
//  UITextView + Extension.swift
//  MiniProject
//
//  Created by Stevans Calvin Candra on 03/12/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadDetailImage(srclink: String) {
        self.image = UIImage(systemName: "photo.fill")!
        self.tintColor = .systemGray
        
        guard let url = URL(string: srclink) else { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard
                let self,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                self.tintColor = .clear
                
                NSLayoutConstraint.activate([
                    self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: image.size.height / image.size.width)
                ])
            }
        }
    }
    
    func loadCardImage(srclink: String) {
        self.image = UIImage(systemName: "photo.fill")!
        self.tintColor = .systemGray
        
        guard let url = URL(string: srclink) else { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard
                let self,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                self.tintColor = .clear
            }
        }
    }
}
