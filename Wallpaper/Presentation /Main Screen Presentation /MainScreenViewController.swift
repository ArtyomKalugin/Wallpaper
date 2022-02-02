//
//  MainScreenViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit
import SDWebImage

protocol MainScreenViewControllerDelegate: AnyObject {
    func toggleMenu()
}

class MainScreenViewController: UIViewController {
    // outlets 
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // public properties
    public weak var delegate: MainScreenViewControllerDelegate?
    
    // private properties
    private var images: [WallpaperImage] = []
    private let converter: CodableConverter = CodableConverter()
    private let networkService: NetworkService = NetworkService()
    private var numberOfNotifications = 0
    private let countCells = 3
    private let offsetCells: CGFloat = 2.0
    private var page = 1
    private var searchingImage = "wallpaper"
    private var isLoading = false
    private var photos: [UIImage?] = []
    private var spinner = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if photos.isEmpty {
            makeRequest(request: searchingImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    // private functions
    private func makeRequest(request: String) {
        images = []
        photos = []
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
        searchingImage = StringHelper.convertToAPIString(string: request)
        loadImages()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 375, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func loadImages() {
        spinner = createSpinnerFooter()
        
        DispatchQueue.main.async {
            self.view.addSubview(self.spinner)
        }
        
        networkService.loadImages(searchingImage: searchingImage, page: page) { [weak self] response, error in
            if let response = response {
                
                for hit in response.hits {
                    guard let wallpaperImage: WallpaperImage = (self?.converter.convertToImage(hit: hit)) else {
                        continue
                    }
                    self?.images.append(wallpaperImage)
                    
                    let url = URL(string: wallpaperImage.fullUrl)
                    if let data = try? Data(contentsOf: url!) {
                        let image = UIImage(data: data)
                        self?.photos.append(image)
                    }
                }
                
                DispatchQueue.main.async {
                    if self?.images.count == 0 {
                        self?.showAlert(title: NSLocalizedString("Ошибка", comment: ""), body: NSLocalizedString("По вашему запросу ничего не найдено!", comment: ""), button: "ОК", actions: nil)
                    } else {
                        self?.collectionView.reloadData()
                    }
                    
                    self!.spinner.removeFromSuperview()
                }
                
                self?.isLoading = false
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: NSLocalizedString("Ошибка", comment: ""), body: NSLocalizedString("По вашему запросу ничего не найдено!", comment: ""), button: "ОК", actions: nil)
                    
                    self!.spinner.removeFromSuperview()
                }
            }
        }
    }
    
    // public functions
    public func changeCategory(category: String, russianCategory: String) {
        categoryLabel.text = russianCategory
        spinner.removeFromSuperview()
        makeRequest(request: category)
    }

    @IBAction func menuButtonAction(_ sender: UIButton) {
        delegate?.toggleMenu()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier:  "SearchingViewController") as? SearchingViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.configure(stringUrl: images[indexPath.row].previewUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async { [weak self] in
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier:  "DetailImageViewController") as? DetailImageViewController else { return }
            viewController.modalPresentationStyle = .fullScreen
            viewController.wallpaperImage = self?.images[indexPath.row]
            
            self?.present(viewController, animated: true, completion: nil)
        }
        
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
extension MainScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if (position > (scrollView.contentSize.height - scrollView.frame.size.height)) && !isLoading {
            isLoading = true
            page += 1
            loadImages()
        }
    }
}
