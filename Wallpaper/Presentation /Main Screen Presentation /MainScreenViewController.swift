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
    weak var delegate: MainScreenViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
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
