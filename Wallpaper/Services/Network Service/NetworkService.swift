//
//  NetworkService.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 31.12.2021.
//

import Foundation

class NetworkService {
    // private properties
    private let configuration = URLSessionConfiguration.default
    private let decoder = JSONDecoder()
    private let baseUrl: String = "https://pixabay.com/api/?key="
    private let pixabayApiKey: String = "25051487-c2de62bd493694276c9cb9dc7"

    // MARK: - Public functions
    func loadImages(searchingImage: String, completion: @escaping (SearchCodable?, Error?) -> Void) {

        let operationQueue = OperationQueue()

        operationQueue.addOperation {
            let session = URLSession(configuration: self.configuration)
            let urlString = self.baseUrl + self.pixabayApiKey + "&q=\(searchingImage)" + "&page=2" + "&per_page=5"
            guard let imageURL = URL(string: urlString) else {
                completion(nil, nil)

                return
            }

            var request = URLRequest(url: imageURL)
            request.cachePolicy = .reloadIgnoringLocalCacheData
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
        }
    }
}
