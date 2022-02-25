//
//  DetailImageViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 25.01.2022.
//

import UIKit
import Purchases

class DetailImageViewController: UIViewController {
    
    // Outlet properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
    // Public properties
    public var wallpaperImage: WallpaperImage?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - Button actions
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        Purchases.shared.purchaserInfo { info, error in
            guard let info = info, error == nil else { return }

            if info.entitlements["allaccess"]?.isActive == true {

                if let image = self.imageView.image {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.savingCompleted(image:error:contextInfo:)), nil)
                } else {
                    self.downloadButton.isEnabled = false
                }

            } else {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier:  "PurchaseViewController") as? PurchaseViewController else { return }
                viewController.modalPresentationStyle = .fullScreen

                self.present(viewController, animated: true, completion: nil)
            }
        }
        
//        if let image = imageView.image {
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(savingCompleted(image:error:contextInfo:)), nil)
//        } else {
//            downloadButton.isEnabled = false
//        }
    }
    
    // Private functions
    private func configure() {
        let url = URL(string: (wallpaperImage?.fullUrl)!)
        
        if let data = try? Data(contentsOf: url!) {
            let image = UIImage(data: data)
            imageView.image = image
        }
    }
    
    // Objc functions
    @objc private func savingCompleted(image: UIImage?, error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        showAlert(title: NSLocalizedString("Завершено", comment: ""), body: NSLocalizedString("Изображение успешно скачено!", comment: ""), button: "ОК", actions: nil)
    }
}
