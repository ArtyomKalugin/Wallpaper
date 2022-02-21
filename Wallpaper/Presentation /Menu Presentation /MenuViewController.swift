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
        case popular = "Популярное wallpaper"
        case threed = "3D 3D+wallpaper"
        case abstraction = "Абстракция abstraction"
        case anime = "Аниме anime"
        case art = "Арт art"
        case white = "Белый white"
        case vector = "Вектор vector"
        case cities = "Города cities"
        case women = "Девушки women"
        case food = "Еда food"
        case animals = "Животные animals"
        case winter = "Зима winter"
        case space = "Космос space"
        case summer = "Лето summer"
        case love = "Любовь love"
        case macro = "Макро macro"
        case cars = "Машины cars"
        case minimalism = "Минимализм minimalism+wallpaper"
        case motorcycles = "Мотоциклы motorcycles"
        case men = "Мужчины men"
        case music = "Музыка music"
        case neon = "Неон neon"
        case loneliness = "Одиночество loneliness"
        case holidays = "Праздники holidays"
        case nature = "Природа nature"
        case other = "Разное other"
        case words = "Слова words"
        case smilies = "Смайлы smilies"
        case sport = "Спорт sport"
        case textures = "Текстуры textures"
        case dark = "Темные dark"
        case technologies = "Технологии technologies"
        case fantasy = "Фэнтези fantasy"
        case predators = "Хищники predators"
        case flowers = "Цветы flowers"
        case black = "Черный black"
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
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
        delegate?.didSelect(menuItem: item)
    }
}

