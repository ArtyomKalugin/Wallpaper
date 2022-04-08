//
//  SearchingViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 02.01.2022.
//

import UIKit

class SearchingViewController: UIViewController {
    
    // Outlet properties
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchingTextField: UITextField!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Private properties
    private var images: [WallpaperImage] = []
    private let converter: CodableConverter = CodableConverter()
    private let networkService: NetworkService = NetworkService()
    private var numberOfNotifications = 0
    private let countCells = 3
    private let offsetCells: CGFloat = 2.0
    private var page = 1
    private var searchingImage: String?
    private var isLoading = false
    private var spinner = UIView()
    private var recognizer: UITapGestureRecognizer!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        configureKeyboard()
        configureShift()
        configureCollectionView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Button actions
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Private functions
    private func configureCollectionView() {
        view.backgroundColor = #colorLiteral(red: 0.06370870024, green: 0.06764560193, blue: 0.09045111388, alpha: 1)
        searchingTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        collectionView.backgroundColor = #colorLiteral(red: 0.06370870024, green: 0.06764560193, blue: 0.09045111388, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureShift() {
        self.view.addGestureRecognizer(recognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureKeyboard() {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let searchButton = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapSearch))
        toolBar.items = [flexibleSpace, searchButton]
        toolBar.sizeToFit()
        
        searchingTextField.inputAccessoryView = toolBar
    }
    
    private func loadImages(perPage: Int) {
        
        DispatchQueue.main.async {
            self.spinner.removeFromSuperview()
            self.spinner = self.createSpinnerFooter()
            self.view.addSubview(self.spinner)
        }
        
        networkService.loadImages(searchingImage: searchingImage ?? "wallpaper", page: page, perPage: perPage) { [weak self] response, error in
     
            if let response = response {
                
                if response.hits.count != 0 {
                    
                    for hit in response.hits {
                        guard let wallpaperImage: WallpaperImage = (self?.converter.convertToImage(hit: hit)) else {
                            continue
                        }
                        
                        self?.images.append(wallpaperImage)
                    }
                }
                
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    self?.showAlert(title: NSLocalizedString("Error", comment: ""), body: NSLocalizedString("No results were found for your request!", comment: ""), button: "ОК", actions: nil)
                    
                    self?.spinner.removeFromSuperview()
                }
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.spinner.removeFromSuperview()
            }
        
            self?.isLoading = false
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: (UserDevice.height / 2) - 50, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    // Objc functions
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
    
        if let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        
            self.view.addGestureRecognizer(recognizer)
            
            if numberOfNotifications < 1 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchLabel.alpha = 0
                    self.backButton.alpha = 0
                    self.backButton.isEnabled = false
                    self.collectionView.backgroundColor = #colorLiteral(red: 0.0539104268, green: 0.05571329594, blue: 0.07271655649, alpha: 1)
                    self.view.backgroundColor = #colorLiteral(red: 0.06370870024, green: 0.06764560193, blue: 0.09045111388, alpha: 1)
                })
                let window = UIApplication.shared.windows.first
                let topPadding = window?.safeAreaInsets.top
                
                self.view.frame.origin.y -= topPadding ?? 10
                numberOfNotifications += 1
            }
        }
    }
    
    @objc private func keyboardWillDisappear() {
        self.view.removeGestureRecognizer(recognizer)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.searchLabel.alpha = 1
            self.backButton.alpha = 1
            self.backButton.isEnabled = true
            self.collectionView.backgroundColor = #colorLiteral(red: 0.0539104268, green: 0.05571329594, blue: 0.07271655649, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.0539104268, green: 0.05571329594, blue: 0.07271655649, alpha: 1)
        })
        
        self.view.frame.origin.y = 0
        numberOfNotifications = 0
    }
    
    @objc private func didTapSearch() {
        
        searchingTextField.resignFirstResponder()
        images = []
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
        guard let searchingText: String = searchingTextField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        
        searchingImage = StringHelper.convertToAPIString(string: searchingText)
        loadImages(perPage: 18)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.collectionView.backgroundColor = #colorLiteral(red: 0.06370870024, green: 0.06764560193, blue: 0.09045111388, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.0539104268, green: 0.05571329594, blue: 0.07271655649, alpha: 1)
        })
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SearchingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchingCell", for: indexPath) as! SearchingCollectionViewCell
        cell.configure(stringUrl: images[indexPath.row].fullUrl)
        
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
        
        return CGSize(width: cellWidth - offsetCells, height: cellHeight - offsetCells)
    }
}

// MARK: - UIScrollViewDelegate
extension SearchingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if (position > (scrollView.contentSize.height - scrollView.frame.size.height - 500)) && !isLoading {
            isLoading = true
            page += 1
            loadImages(perPage: 18)
        }
    }
}
