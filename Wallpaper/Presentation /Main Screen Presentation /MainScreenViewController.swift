//
//  MainScreenViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit
import SDWebImage
import Purchases

// MARK: - MainScreenViewControllerDelegate
protocol MainScreenViewControllerDelegate: AnyObject {
    func toggleMenu()
}

class MainScreenViewController: UIViewController {
    
    // Outlet properties
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Public properties
    public weak var delegate: MainScreenViewControllerDelegate?
    public var condition = 0
    
    // Private properties
    private var images: [WallpaperImage] = []
    private let converter: CodableConverter = CodableConverter()
    private let networkService: NetworkService = NetworkService()
    private var numberOfNotifications = 0
    private let countCells = 3
    private let offsetCells: CGFloat = 2.0
    private var page = 1
    private var searchingImage = "wallpaper"
    private var isLoading = false
    private var spinner = UIView()
    private var isSubscriptionAppeared = false
    
    // MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if images.isEmpty {
            makeRequest(request: searchingImage)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier:  "DetailImageViewController") as? DetailImageViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)
        
//        if !isSubscriptionAppeared {
//            checkSubscription()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        congirureGestureRecognizer()
    }
    
    // Private functions
    private func checkSubscription() {
        
        isSubscriptionAppeared = true
        
        Purchases.shared.purchaserInfo { info, error in
            guard let info = info, error == nil else { return }

            if info.entitlements["allaccess"]?.isActive == true {
                return
            } else {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier:  "PurchaseViewController") as? PurchaseViewController else { return }
                viewController.modalPresentationStyle = .fullScreen

                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    private func makeRequest(request: String, perPage: Int = 18) {
        images = []
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
        searchingImage = StringHelper.convertToAPIString(string: request)
        loadImages(perPage: perPage, isPagination: false)
    }
    
    private func configureView() {
        view.backgroundColor = #colorLiteral(red: 0.0539104268, green: 0.05571329594, blue: 0.07271655649, alpha: 1)
        collectionView.backgroundColor = #colorLiteral(red: 0.06370870024, green: 0.06764560193, blue: 0.09045111388, alpha: 1)
    }
    
    private func congirureGestureRecognizer() {
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
        swipeRightRecognizer.direction = .right
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
        swipeLeftRecognizer.direction = .left
        
        view.addGestureRecognizer(swipeRightRecognizer)
        view.addGestureRecognizer(swipeLeftRecognizer)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: (UserDevice.height / 2) - 50, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func loadImages(perPage: Int, isPagination: Bool) {
    
        DispatchQueue.main.async {
            self.spinner.removeFromSuperview()
            self.spinner = self.createSpinnerFooter()
            self.view.addSubview(self.spinner)
        }
        
        networkService.loadImages(searchingImage: searchingImage, page: page, perPage: perPage) { [weak self] response, error in
     
            if let response = response {
                
                if response.hits.count != 0 {
                    
                    for hit in response.hits {
                        guard let wallpaperImage: WallpaperImage = (self?.converter.convertToImage(hit: hit)) else {
                            continue
                        }
                        
                        self?.images.append(wallpaperImage)
                    }
                }
                
                if response.hits.count == 0 && !isPagination {
                    
                    DispatchQueue.main.async {
                        self?.showAlert(title: NSLocalizedString("Error", comment: ""), body: NSLocalizedString("No results were found for your request!", comment: ""), button: "ОК", actions: nil)
                        
                        self?.spinner.removeFromSuperview()
                    }
                }
                
            }
            
            if response == nil && !isPagination {
                
                DispatchQueue.main.async {
                    self?.showAlert(title: NSLocalizedString("Error", comment: ""), body: NSLocalizedString("No results were found for your request!", comment: ""), button: "ОК", actions: nil)
                    
                    self?.spinner.removeFromSuperview()
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
    
    // Public functions
    public func changeCategory(category: String, russianCategory: String) {
        categoryLabel.text = russianCategory
        page = 1
        spinner.removeFromSuperview()
        makeRequest(request: category)
    }
    
    // Objc functions
    @objc private func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            if condition == 1 {
                delegate?.toggleMenu()
                condition = 0
            }
        case .right:
            if condition == 0 {
                delegate?.toggleMenu()
                condition = 1
            }
            
        default:
            print("wrong swipe")
        }
        
    }
    
    // MARK: - Button actions 
    @IBAction func menuButtonAction(_ sender: UIButton) {
        delegate?.toggleMenu()
        
        if condition == 0 {
            condition = 1
        } else {
            condition = 0
        }
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier:  "SearchingViewController") as? SearchingViewController else { return }
        
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
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
extension MainScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if (position > (scrollView.contentSize.height - scrollView.frame.size.height - 500)) && !isLoading {
            isLoading = true
            page += 1
            loadImages(perPage: 18, isPagination: true)
        }
    }
}
