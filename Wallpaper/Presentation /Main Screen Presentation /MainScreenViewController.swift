//
//  MainScreenViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit

protocol MainScreenViewControllerDelegate: AnyObject {
    func toggleMenu()
}

class MainScreenViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: MainScreenViewControllerDelegate?
    
    private let networkService: NetworkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func menuButtonAction(_ sender: UIButton) {
        delegate?.toggleMenu()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        guard let searchingImage: String = textField.text else { return }
        
        networkService.loadImages(searchingImage: searchingImage) { images, error in
            if images != nil {
                print(images)
            } else {
                print(error)
            }
        }
    }
}
