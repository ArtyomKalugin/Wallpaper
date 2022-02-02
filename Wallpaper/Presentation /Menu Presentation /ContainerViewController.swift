//
//  ContainerViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    // private properties
    private var menuState: MenuState = .closed
    private let menuViewController = MenuViewController()
    private var mainScreenViewController = MainScreenViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMenuScreen()
        addMainScreen()
    }
    
    // private functions
    private func addMenuScreen() {
        menuViewController.delegate = self
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
    }
    
    private func addMainScreen() {
        let mainScreenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        self.mainScreenViewController = mainScreenViewController
        self.mainScreenViewController.delegate = self
        addChild(mainScreenViewController)
        view.addSubview(mainScreenViewController.view)
        mainScreenViewController.didMove(toParent: self)
    }
}

// MARK: - MainScreenViewControllerDelegate
extension ContainerViewController: MainScreenViewControllerDelegate {
    func toggleMenu() {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8 , initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.mainScreenViewController.view.frame.origin.x = self.mainScreenViewController .view.frame.width - 90
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }

        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8 , initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.mainScreenViewController.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
        }
    }
}


// MARK: - MenuViewControllerDelegate
extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        let stringArray: [String] = menuItem.rawValue.components(separatedBy: " ")
        mainScreenViewController.changeCategory(category: stringArray[1], russianCategory: stringArray[0])
        toggleMenu()
    }
}
