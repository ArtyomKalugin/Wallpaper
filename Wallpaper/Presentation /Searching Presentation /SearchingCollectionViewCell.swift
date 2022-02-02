//
//  SearchingCollectionViewCell.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.01.2022.
//

import UIKit
import SDWebImage

class SearchingCollectionViewCell: UICollectionViewCell {
    // outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // public functions
    public func configure(stringUrl: String) {
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        let url = URL(string: stringUrl)
        imageView.sd_setImage(with: url, completed: nil)
    }
}
