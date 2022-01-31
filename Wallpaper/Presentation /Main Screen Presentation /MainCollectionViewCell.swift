//
//  MainCollectionViewCell.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 31.01.2022.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    // outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // private properties
    private var dataTask: URLSessionDataTask?
    
    // public properties
    public var imageURLString: String? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.backgroundColor = .lightGray.withAlphaComponent(0.1)
            }
            
            DispatchQueue.global().async { [weak self] in
                guard self?.imageURLString    != "",
                      let imageURLString = self?.imageURLString,
                      let imageURL       = URL(string: imageURLString) else {
                          DispatchQueue.main.async {
                              self?.imageView.image = nil
                          }
                          
                          return
                      }

                self?.loadImage(imageURL: imageURL)
            }
        }
    }
    
    // private functions
    private func loadImage(imageURL: URL)  {
        dataTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { data, response, error in
            
            if let data = data,
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = nil
                }
            }
        })
        
        dataTask?.resume()
    }

    // override functions
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
        imageView.image = nil
    }

}
