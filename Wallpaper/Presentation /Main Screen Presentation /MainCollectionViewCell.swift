//
//  MainCollectionViewCell.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 31.01.2022.
//

import UIKit
import SDWebImage

class MainCollectionViewCell: UICollectionViewCell {
    
    // Outlet properties
    @IBOutlet weak var imageView: UIImageView!
    
    // Public functions 
    public func configure(stringUrl: String) {
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        let url = URL(string: stringUrl)
        imageView.sd_setImage(with: url, completed: nil)
    }
}
