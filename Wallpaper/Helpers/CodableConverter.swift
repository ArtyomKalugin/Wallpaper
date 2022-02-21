//
//  SearchCodableConverter.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 04.01.2022.
//

import Foundation

class CodableConverter {
    
    // Public functions
    public func convertToImage(hit: HitCodable) -> WallpaperImage {
        let favorites: Int = hit.favorites ?? 0
        let likes: Int = hit.likes ?? 0
        
        return WallpaperImage(fullUrl: hit.largeImageURL ?? "",
                                     previewUrl: hit.webformatURL ?? "",
                                     pageUrl: hit.pageURL ?? "",
                                     user: hit.user ?? "",
                                     likes: favorites + likes,
                                     views: hit.views ?? 0)
    }
}
