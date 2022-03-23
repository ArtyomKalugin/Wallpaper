//
//  MenuViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit

// MARK: - MenuViewControllerProtocol
protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController {
    
    // Public properties
    public weak var delegate: MenuViewControllerDelegate?
    
    // Enums
    enum MenuOptions: String, CaseIterable {
        case termsOfUse = "Terms of use"
        case popular = "Popular wallpaper"
        case sea = "Sea sea+water"
        case white = "White white"
        case cities = "Cities cities"
        case summer = "Summer summer"
        case macro = "Macro macro"
        case nature = "Nature nature+wallpaper"
        case other = "Other other"
        case textures = "Textures textures"
        case dark = "Dark dark"
        case predators = "Predators predators"
        case flowers = "Flowers flowers"
        case black = "Black black"
    }
    
    // Private properties
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = nil
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureTableView()
    }
    
    // Private functions 
    private func configureTableView() {
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    private func configure() {
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let stringArray: [String] = MenuOptions.allCases[indexPath.row].rawValue.components(separatedBy: " ")
        cell.textLabel?.text = stringArray[0]
        
        if stringArray[0] == "Terms" {
            cell.textLabel?.text = stringArray[0] + " " + stringArray[1] + " " + stringArray[2]
        } else {
            cell.textLabel?.text = stringArray[0]
        }
        
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            cellToDeSelect.contentView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        
        if indexPath.row == 0 {
            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            delegate?.didSelect(menuItem: item)
        }
    }
}

