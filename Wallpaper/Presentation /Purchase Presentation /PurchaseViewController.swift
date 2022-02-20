//
//  PurchaseViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 20.02.2022.
//

import UIKit

class PurchaseViewController: UIViewController {
    // outlest
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // private functions
    private func configure() {
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
    }
}
