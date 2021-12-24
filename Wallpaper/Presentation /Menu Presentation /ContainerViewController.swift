//
//  ContainerViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var controller: UIViewController!
    var menuViewController: UIViewController!
    var isMoving = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMainScreenViewController()
    }
    
    func configureMainScreenViewController() {
        let mainScreenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainScreenViewController
        mainScreenViewController.delegate = self
        controller = mainScreenViewController
        view.addSubview(mainScreenViewController.view)
        addChild(mainScreenViewController)
    }
    
    func configureMenuViewController() {
        if menuViewController == nil {
            menuViewController = MenuViewController()
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
        }
    }
    
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            UIView.animate(withDuration: 0.5 ,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.view.frame.origin.x = self.controller.view.frame.width - 140
            } completion: { (finished) in
        
            }

        } else {
            UIView.animate(withDuration: 0.5 ,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.view.frame.origin.x = 0
            } completion: { (finished) in
                
            }
        }
        
    }
}

// MARK: MainScreenViewControllerDelegate
extension ContainerViewController: MainScreenViewControllerDelegate {
    func toggleMenu() {
        isMoving = !isMoving
        configureMenuViewController()
        showMenuViewController(shouldMove: isMoving)
    }
}
