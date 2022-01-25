//
//  DetailImageViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 25.01.2022.
//

import UIKit

class DetailImageViewController: UIViewController {
    // outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
    // public properties
    public var wallpaperImage: WallpaperImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        } else {
            downloadButton.isEnabled = false
        }
    }
    
    // private functions
    private func configure() {
        let url = URL(string: (wallpaperImage?.fullUrl)!)
        
        if let data = try? Data(contentsOf: url!) {
            let image = UIImage(data: data)
            imageView.image = image
        }
    }
}
