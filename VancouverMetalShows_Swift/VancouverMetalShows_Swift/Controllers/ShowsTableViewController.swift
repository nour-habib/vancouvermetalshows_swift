//
//  ShowsTableViewController.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-17.
//

import UIKit

protocol ShowsTableViewControllerDelegate: AnyObject
{
    func didTapMenuButton()
}

class ShowsTableViewController: UIViewController, UIGestureRecognizerDelegate
{
    weak var delegate: ShowsTableViewControllerDelegate?
    
    private lazy var showsTableView: UITableView =
    {
        let showsTableView = UITableView()
        showsTableView.register(ShowTableViewCell.self, forCellReuseIdentifier: "cellId")
        showsTableView.showsVerticalScrollIndicator = false
        return showsTableView
        
    }()
    
    private var tableViewDataSourceDelgate: TableViewDataSourceDelegate?
    {
     didSet
        {
            showsTableView.delegate = tableViewDataSourceDelgate
            showsTableView.dataSource = tableViewDataSourceDelgate
            showsTableView.reloadData()
        }
        
    }
    private var showsArray: [Show]?
    private var overlayView: UIView?
    let defaults = UserDefaults.standard

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Shows"
        view.backgroundColor = .white
        
        //CoreData_.clearAllItems(entityName: "ShowItem")
    
        //defaults.set(true, forKey: "InitialLaunch")
        if (defaults.bool(forKey: "InitialLaunch") == true)
        {
            //Load data from CoreData
            self.showsArray = Show.sortShows(shows: CoreData_.loadItems())
            defaults.set(true, forKey: "InitialLaunch")
            
        }
        else
        {
            //Load data from local JSON file
            self.showsArray = Show.sortShows(shows: getShowsData())
            guard let showsArray = showsArray else {return}
            CoreData_.batchLoad(array: showsArray)
            defaults.set(true, forKey: "InitialLaunch")
        }
        
        guard let showsArray = showsArray else {return}
        self.tableViewDataSourceDelgate = TableViewDataSourceDelegate(shows: showsArray)
        
        configureNavigation()
        configureTableView()
    }
    
    // MARK: TableView Configuration
    
    private func configureTableView()
    {
        showsTableView.backgroundColor = CustomColor.offWhite
        view.addSubview(showsTableView)
        
        showsTableView.translatesAutoresizingMaskIntoConstraints = false
        showsTableView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        showsTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        showsTableView.rightAnchor.constraint(equalTo:view.rightAnchor, constant: 0).isActive = true
        showsTableView.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 0).isActive = true
        showsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        showsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func configureNavigation()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))
    }
    
    @objc func didTapMenuButton()
    {
        delegate?.didTapMenuButton()
    }
    
    // MARK: Json Parsing
    
    private func getShowsData() -> [Show]
    {
        var showsArray = [Show]()
        
        do
        {
           if let path = Bundle.main.path(forResource: "jsonData", ofType: "json")
            {
               let fileURL = URL(fileURLWithPath: path)
               let data = try Data(contentsOf: fileURL)
               let showsJSON = try JSONDecoder().decode([Show].self, from: data)
               showsArray.append(contentsOf: showsJSON)
           }
            
        }
        catch
        {
            print("error: \(error)")
        }
      
        return showsArray
    }
}

extension ShowsTableViewController: DetailViewDelegate
{
    func didCloseView()
    {
        UIView.animate(withDuration: 1.0, delay:0, options: .curveEaseInOut, animations: {
            self.overlayView?.alpha = 0.0
       })
        
        self.overlayView?.removeFromSuperview()
    }
}

extension ShowsTableViewController: ContainerViewDelegateTB
{
    func updateTableView()
    {
        showsArray = CoreData_.loadItems()
        showsTableView.reloadData()
    }
}


