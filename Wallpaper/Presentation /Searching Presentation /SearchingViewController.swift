//
//  SearchingViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 02.01.2022.
//

import UIKit

class SearchingViewController: UIViewController {
    @IBOutlet weak var searchingTextField: UITextField!
    
    // private properties
    private var images: [WallpaperImage] = []
    private let converter: CodableConverter = CodableConverter()
    
    private let networkService: NetworkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func configure() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let searchButton = UIBarButtonItem(title: "Найти", style: .done, target: self, action: #selector(didTapSearch))
        toolBar.items = [flexibleSpace, searchButton]
        toolBar.sizeToFit()
        
        searchingTextField.inputAccessoryView = toolBar
    }
    
    @objc private func didTapSearch() {
        guard let searchingImage: String = searchingTextField.text?.trimmingCharacters(in: .whitespaces) else { return }

        networkService.loadImages(searchingImage: searchingImage) { [weak self] response, error in
            if let response = response {
                for hit in response.hits {
                    var wallpaperImage: WallpaperImage = (self?.converter.convertToImage(hit: hit))!
                    self?.images.append(wallpaperImage)
                }
                
                print(self?.images)
            } else {
                print(error)
            }
        }
        
        searchingTextField.resignFirstResponder()
    }
}
