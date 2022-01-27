//
//  SearchingViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 02.01.2022.
//

import UIKit

class SearchingViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchingTextField: UITextField!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // private properties
    private var images: [WallpaperImage] = []
    private let converter: CodableConverter = CodableConverter()
    private let networkService: NetworkService = NetworkService()
    private var numberOfNotifications = 0
    private let countCells = 3
    private let offsetCells: CGFloat = 2.0
    private var page = 1
    private var searchingImage: String?
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
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
    
    // private functions
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    private func loadImages() {
        let spinner = createSpinnerFooter()
        
        DispatchQueue.main.async {
            self.view.addSubview(spinner)
        }
        
        networkService.loadImages(searchingImage: searchingImage!, page: page) { [weak self] response, error in
            if let response = response {
                
                for hit in response.hits {
                    let wallpaperImage: WallpaperImage = (self?.converter.convertToImage(hit: hit))!
                    self?.images.append(wallpaperImage)
                }
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    spinner.removeFromSuperview()
                }
                
                self?.isLoading = false
            } else {
                print(error as Any)
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 375, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    // objc functions
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
        guard let searchingText: String = searchingTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        images = []
        searchingImage = searchingText
        loadImages()
        searchingTextField.resignFirstResponder()
    }
}

// MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SearchingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchingCell", for: indexPath) as! SearchingCollectionViewCell
        
        let url = URL(string: (images[indexPath.row].fullUrl))
        if let data = try? Data(contentsOf: url!) {
            let image = UIImage(data: data)
            cell.configure(with: image!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier:  "DetailImageViewController") as? DetailImageViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.wallpaperImage = images[indexPath.row]
        
        present(viewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameCollectionView = collectionView.frame
        let cellWidth = frameCollectionView.width / CGFloat(countCells)
        let cellHeight = CGFloat(250)
        let spacing = CGFloat(countCells - 1) * offsetCells / CGFloat(countCells)
        
        return CGSize(width: cellWidth - spacing, height: cellHeight - offsetCells)
    }
}

// MARK:- UIScrollViewDelegate
extension SearchingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if (position > (scrollView.contentSize.height - scrollView.frame.size.height)) && !isLoading {
            isLoading = true
            page += 1
            loadImages()
        }
    }
}
