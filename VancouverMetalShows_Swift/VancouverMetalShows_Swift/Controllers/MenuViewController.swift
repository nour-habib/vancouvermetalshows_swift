//
//  MenuViewController.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-20.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject
{
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    weak var delegate: MenuViewControllerDelegate?
    private var tableView: UITableView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView()
    {
        view.backgroundColor = .lightGray
        self.tableView = UITableView(frame: CGRect(x:0,y:view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height))
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = CustomColor.darkGrayNew
        tableView?.separatorStyle = .none
    
        view.addSubview(self.tableView ?? UITableView())
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: Menu TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        cell.backgroundColor = CustomColor.darkGrayNew
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .light, scale: .medium)
        let iconImage = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName, withConfiguration: symbolConfig)
        
        cell.imageView?.image = iconImage?.withTintColor(CustomColor.ninjaGreen)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
    
    enum MenuOptions: String, CaseIterable
    {
        case shows = "Shows"
        case favs = "Favs"


        var imageName: String
        {
            switch self
            {
            case .shows:
                return "music.mic.circle.fill"
            case .favs:
                return "heart.circle.fill"
            }
        }
    }
    
}
