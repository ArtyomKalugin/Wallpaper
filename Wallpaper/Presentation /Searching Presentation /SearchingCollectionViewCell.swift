//
//  SearchingCollectionViewCell.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.01.2022.
//

import UIKit

class SearchingCollectionViewCell: UICollectionViewCell {
    // outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // public functions
    public func configure(with image: UIImage) {
        imageView.image = image
    }
}
