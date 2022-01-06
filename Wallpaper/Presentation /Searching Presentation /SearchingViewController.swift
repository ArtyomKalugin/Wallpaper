//
//  SearchingViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 02.01.2022.
//

import UIKit

class SearchingViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchingTextField: UITextField!
    @IBOutlet weak var searchLabel: UILabel!
    
    // private properties
    private var images: [WallpaperImage] = []
    private let converter: CodableConverter = CodableConverter()
    private let networkService: NetworkService = NetworkService()
    private var numberOfNotifications = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureKeyboard()
        configureShift()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureShift() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureKeyboard() {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let searchButton = UIBarButtonItem(title: "Найти", style: .done, target: self, action: #selector(didTapSearch))
        toolBar.items = [flexibleSpace, searchButton]
        toolBar.sizeToFit()
        
        searchingTextField.inputAccessoryView = toolBar
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        if let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            if numberOfNotifications < 1 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchLabel.alpha = 0
                    self.backButton.alpha = 0
                    self.backButton.isEnabled = false
                })
                
                self.view.frame.origin.y -= searchingTextField.frame.origin.y
                numberOfNotifications += 1
            }
        }
    }
    
    @objc private func keyboardWillDisappear() {
        UIView.animate(withDuration: 0.1, animations: {
            self.searchLabel.alpha = 1
            self.backButton.alpha = 1
            self.backButton.isEnabled = true
        })
        
        self.view.frame.origin.y = 0
        numberOfNotifications = 0
    }
    
    @objc private func didTapSearch() {
        guard let searchingImage: String = searchingTextField.text?.trimmingCharacters(in: .whitespaces) else { return }

        networkService.loadImages(searchingImage: searchingImage) { [weak self] response, error in
            if let response = response {
                self?.images = []
                
                for hit in response.hits {
                    let wallpaperImage: WallpaperImage = (self?.converter.convertToImage(hit: hit))!
                    self?.images.append(wallpaperImage)
                }
                
                let url = URL(string: (self?.images[0].fullUrl)!)
                
                if let data = try? Data(contentsOf: url!) {
                    print((self?.images[0].fullUrl)!)
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            } else {
                print(error)
            }
        }
            
        searchingTextField.resignFirstResponder()
    }
}
