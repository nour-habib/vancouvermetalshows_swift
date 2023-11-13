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

protocol TableViewCellDelegate: AnyObject
{
    func didTapHeartButton()
}

class ShowsTableViewController: UIViewController, UIGestureRecognizerDelegate
{
    weak var delegate: ShowsTableViewControllerDelegate?
    weak var cellDelegate: TableViewCellDelegate?
    
    private lazy var showsTableView: ShowsTableView =
    {
        let showsTableView = ShowsTableView()
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
    
    private var detailView: DetailView?
    private var showsArray = [Show]()
    
    private var overlayView: UIView?
    private var show: Show?
    
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
            //Seecond+ launch: load from CoreData
            print("Second+ launch")
            self.showsArray = Show.sortShows(shows: CoreData_.loadItems())
            defaults.set(true, forKey: "InitialLaunch")
            
        }
        else
        {
            print("First launch")
            //First launch, load from JSON
            self.showsArray = Show.sortShows(shows: getShowsData())
            CoreData_.batchLoad(array: showsArray)
            defaults.set(true, forKey: "InitialLaunch")
        }
        
        self.tableViewDataSourceDelgate = TableViewDataSourceDelegate(shows: showsArray)
        
        configureNavigation()
        configureTableView()
    }
    
    // MARK: View Configuration
    
    private func configureTableView()
    {
        showsTableView.refreshControl = UIRefreshControl()
        showsTableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
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
    
    @objc func refreshTable()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0){
            self.showsTableView.refreshControl?.endRefreshing()
            self.showsArray = Show.sortShows(shows: CoreData_.loadItems())
            self.showsTableView.reloadData()
        };
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
        print("didCloseView()")
        UIView.animate(withDuration: 1.0, delay:0, options: .curveEaseInOut, animations: {
            self.overlayView?.alpha = 0.0
       })
        
        self.overlayView?.removeFromSuperview()
        
    }
}

extension ShowsTableViewController: TableViewCellDelegate
{
    func didTapHeartButton()
    {
        //do
    }
}

extension ShowsTableViewController: ContainerViewDelegateTB
{
    func updateTableView()
    {
        print("updateTableView")
        showsArray = CoreData_.loadItems()
        showsTableView.reloadData()
    }
    
}


