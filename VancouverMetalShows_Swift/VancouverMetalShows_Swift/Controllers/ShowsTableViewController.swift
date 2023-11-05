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
    
    private var tableViewDataSourceDelgate: TableViewDataSourceDelegate?
    
    lazy var showsTableView: ShowsTableView =
    {
        let showsTableView = ShowsTableView(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height),style: UITableView.Style.plain)
        showsTableView.register(ShowTableViewCell.self, forCellReuseIdentifier: "cellId")
        showsTableView.delegate = tableViewDataSourceDelgate
        showsTableView.dataSource = tableViewDataSourceDelgate
        showsTableView.showsVerticalScrollIndicator = false
        return showsTableView
        
    }()
    
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
    
        defaults.set(true, forKey: "InitialLaunch")
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
    
        for show in showsArray
        {
            print("artist: ", show.artist)
            print("fav: ", show.favourite)
        }
        
        configureNavigation()
        configureTableView()
    }
    
    // MARK: View Configuration
    
    private func configureTableView()
    {
        view.addSubview(showsTableView)
    }
    
    private func configureNavigation()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))
    }
    
    @objc func didTapMenuButton()
    {
        delegate?.didTapMenuButton()
    }
    
    // MARK: Favourite Button
    private func addToFavs(show: Show)
    {
        cellDelegate?.didTapHeartButton()
        
        print("addTOFavs")
        try? CoreData_.updateItem(show: show, newValue: "1")
        showsArray = CoreData_.loadItems()
        //showsTableView?.reloadData()
    }
    
    private func removeItemFromFavs(show: Show)
    {
        print("removeItemFromFavs()")
        try? CoreData_.updateItem(show: show, newValue: "0")
        showsArray = CoreData_.loadItems()
        //showsTableView?.reloadData()
    }
    
    // MARK: Json Parsing
    
    private func getShowsData() -> [Show]
    {
        print("getshowsData()")
        var showsArray = [Show]()
        
        do
        {
           if let path = Bundle.main.path(forResource: "jsonData", ofType: "json")
            {
               let fileURL = URL(fileURLWithPath: path)
               let data = try Data(contentsOf: fileURL)
               let showsJSON = try JSONDecoder().decode([Show].self, from: data)
               showsArray.append(contentsOf: showsJSON)
               //return showsArray
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

extension ShowsTableViewController: TableViewData
{
    func addToView(view: UIView)
    {
        self.view.addSubview(view)
    }
}




