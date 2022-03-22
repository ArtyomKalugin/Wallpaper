//
//  NetworkService.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 31.12.2021.
//

import Foundation

class NetworkService {
    
    // Private properties
    private let configuration = URLSessionConfiguration.default
    private let decoder = JSONDecoder()
    private let baseUrl: String = "https://pixabay.com/api/?lang=ru&orientation=vertical&key="
    private let pixabayApiKey: String = "25051487-c2de62bd493694276c9cb9dc7"

    // MARK: - Public functions
    func loadImages(searchingImage: String, page: Int, perPage: Int = 18, completion: @escaping (SearchCodable?, Error?) -> Void) {
        
        let session = URLSession(configuration: self.configuration)
        
        let urlString = self.baseUrl + self.pixabayApiKey + "&q=\(searchingImage)" + "&page=\(page)" + "&per_page=\(perPage)" + "&min_width=750" + "&min_height=1334" + "&safesearch=true"
        
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: urlString) {
            
            var request = URLRequest(url: imageURL)
            request.cachePolicy = .returnCacheDataElseLoad
            request.httpMethod = "GET"

            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    let searchingCodable = try? JSONDecoder().decode(SearchCodable.self, from: data)
                    completion(searchingCodable, error)
                } else {
                    completion(nil, error)
                }
            }

            dataTask.resume()
        } else {
            completion(nil, nil)

            return
        }
    }
}
