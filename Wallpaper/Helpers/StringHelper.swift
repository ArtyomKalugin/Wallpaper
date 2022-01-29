//
//  StringHelper.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 29.01.2022.
//

import Foundation

class StringHelper {
    
    // public functions
    public static func convertToAPIString(string: String) -> String {
        let stringArray: [String] = string.components(separatedBy: " ")
       
        return stringArray.joined(separator: "+")
    }
}
