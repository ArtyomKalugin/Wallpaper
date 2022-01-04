//
//  WallpaperImage .swift
//  Wallpaper
//
//  Created by Artem Kalugin on 04.01.2022.
//

import Foundation
import UIKit

class WallpaperImage {
    let fullUrl: String
    let previewUrl: String
    let pageUrl: String
    let user: String
    let likes: Int
    let views: Int
    
    var image: UIImage?
    
    init(fullUrl: String,
         previewUrl: String,
         pageUrl: String,
         user: String,
         likes: Int,
         views: Int) {
        
        self.fullUrl = fullUrl
        self.previewUrl = previewUrl
        self.pageUrl = pageUrl
        self.user = user
        self.likes = likes
        self.views = views
    }
}

