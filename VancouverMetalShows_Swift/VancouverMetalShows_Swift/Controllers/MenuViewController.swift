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
    private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()

        
    }
    
    private func configureView()
    {
        self.view.backgroundColor = .lightGray
        
       // self.view.layer.opacity = 0.5
        
        self.tableView = UITableView(frame: CGRect(x:0,y:view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height))
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.backgroundColor = CustomColor.darkGrayNew
        self.tableView?.separatorStyle = .none
    
      
        self.view.addSubview(self.tableView ?? UITableView())
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //self.tableView?.frame = CGRect(x:0,y:view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = CustomColor.ninjaGreen
        //cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.backgroundColor = CustomColor.darkGrayNew
        
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
    
}
