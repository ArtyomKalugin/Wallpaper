//
//  MenuViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 24.12.2021.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        case popular = "Популярное wallpaper"
        case threed = "3D 3D+wallpaper"
        case abstraction = "Абстракция abstraction"
        case anime = "Аниме anime"
        case art = "Арт art+wallpaper"
        case white = "Белый white+wallpaper"
        case vector = "Вектор vector+wallpaper"
        case cities = "Города cities+wallpaper"
        case women = "Девушки women+wallpaper"
        case food = "Еда food+wallpaper"
        case animals = "Животные animals+wallpaper"
        case winter = "Зима winter+wallpaper"
        case space = "Космос space+wallpaper"
        case summer = "Лето summer+wallpaper"
        case love = "Любовь love+wallpaper"
        case macro = "Макро macro+wallpaper"
        case cars = "Машины cars+wallpaper"
        case minimalism = "Минимализм minimalism+wallpaper"
        case motorcycles = "Мотоциклы motorcycles+wallpaper"
        case men = "Мужчины men+wallpaper"
        case music = "Музыка music+wallpaper"
        case neon = "Неон neon"
        case loneliness = "Одиночество loneliness+wallpaper"
        case holidays = "Праздники holidays+wallpaper"
        case nature = "Природа nature+wallpaper"
        case other = "Разное other+wallpaper"
        case words = "Слова words+wallpaper"
        case smilies = "Смайлы smilies+wallpaper"
        case sport = "Спорт sport+wallpaper"
        case textures = "Текстуры textures+wallpaper"
        case dark = "Темные dark+wallpaper"
        case technologies = "Технологии technologies+wallpaper"
        case fantasy = "Фэнтези fantasy+wallpaper"
        case predators = "Хищники predators+wallpaper"
        case flowers = "Цветы flowers+wallpaper"
        case black = "Черный black+wallpaper"
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = nil
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureTableView()
    }
    
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

