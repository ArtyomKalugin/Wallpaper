//
//  MainScreenViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    var delegate: MainScreenViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func menuButtonAction(_ sender: UIButton) {
        delegate?.toggleMenu()
    }
}
