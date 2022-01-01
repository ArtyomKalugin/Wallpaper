//
//  Codable.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 31.12.2021.
//

import Foundation

struct SearchCodable: Codable {
  let hits: [HitCodable]
}

struct HitCodable: Codable {
  let largeImageURL: String?
  let webformatURL: String?
  let pageURL: String?
  let user: String?
  
  let likes: Int?
  let favorites: Int?
  let views: Int?
}
