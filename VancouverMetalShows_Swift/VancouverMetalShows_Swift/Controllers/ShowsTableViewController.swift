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

class ShowsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    weak var delegate: ShowsTableViewControllerDelegate?
    
    private var detailView: DetailView?
    private var showsTableView: ShowsTableView?
    private var showsArray = [Show]()
    
    private var overlayView: UIView?
    private var show: Show?

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        self.title = "Shows"
        self.view.backgroundColor = .white
        
        let showsDataArray = getShowsData()
        for show in showsDataArray
        {
            print(show.artist)
        }
       
        configureNavigation()
        configureTableView()
    }
    
    // MARK: View Configuration
    
    private func configureTableView()
    {
        self.showsTableView = ShowsTableView(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height),style: UITableView.Style.plain)
        showsTableView?.register(ShowTableViewCell.self, forCellReuseIdentifier: "cellId")
        showsTableView?.delegate = self
        showsTableView?.dataSource = self
        showsTableView?.showsVerticalScrollIndicator = false
        self.view.addSubview(self.showsTableView!)
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
        print("getshowsData()")
        
        do
        {
           if let path = Bundle.main.path(forResource: "jsonData", ofType: "json")
            {
               let fileURL = URL(fileURLWithPath: path)
               let data = try Data(contentsOf: fileURL)
               let showsJSON = try JSONDecoder().decode(ShowRoot.self, from: data)
               showsArray.append(contentsOf: showsJSON.shows)
               return showsArray
           }
            
        }
        catch
        {
            print("error: \(error)")
        }
      
        return []
    }
    
    // MARK: TableView Protocol Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return showsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
       let cell = showsTableView?.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ShowTableViewCell
        //cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        //cell.layer.cornerRadius = 10
        //cell.contentView.clipsToBounds = true
        cell.selectionStyle = .none
        
        let show = showsArray[indexPath.row]
        
        cell.showView?.artistLabel?.text = show.artist
        cell.showView?.venueLabel?.text = show.venue
        
        let formattedDate = Date.shared.formatDate(dateString: show.date, format: "EEEE, MMM d, yyyy")
        //print("formattedDate: ", formattedDate)
        
        cell.showView?.dateLabel?.text = formattedDate.uppercased()
        cell.showView?.imageView?.image =  UIImage(named: show.image)
        
        let favButton = UIButton(frame: CGRect(x:320,y:60,width:20,height:20))
        
        print("fav status: ", show.favourite)
        print("current show: ", show.artist)
        
        if(CoreData_.existsInTable(show: show))
        {
            favButton.setImage(UIImage(systemName: "heart.square.fill"), for: .normal)
            favButton.backgroundColor = .blue
            favButton.addAction(UIAction{_ in
                favButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favButton.backgroundColor = .none
                self.removeItemFromFavs(show: show)
            }, for: .touchUpInside)
        }
        else
        {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favButton.addAction(UIAction{_ in
                self.addToFavs(show: show)
                favButton.setImage(UIImage(systemName: "heart.square.fill"), for: .normal)
                favButton.backgroundColor = .blue
            }, for: .touchUpInside)
        }
        
        cell.addSubview(favButton)
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("row is clicked")
        self.show = showsArray[indexPath.row]
        self.detailView = DetailView(frame: CGRect(x:50,y:200,width:(0.7)*UIScreen.main.bounds.width, height:300), show: self.show ?? Show())
        self.detailView?.delegate = self
        
        self.overlayView = UIView(frame: self.view.frame)
        self.overlayView?.backgroundColor = .black
        self.overlayView?.alpha = 0.5
        self.view.addSubview(self.overlayView ?? UIView())
        
        UIView.animate(withDuration: 1,delay:0, options: .curveEaseInOut,animations:{
            self.detailView?.alpha = 0.9
            self.view.addSubview(self.detailView ?? UIView())
            
        })
    }
    
    // MARK: Favourite Button
    private func addToFavs(show: Show)
    {
        print("addTOFavs")
        var show = show
        
        show.favourite = "1"
        CoreData_.createItem(show: show)
        //self.showsTableView?.reloadData()
    }
    
    private func removeItemFromFavs(show: Show)
    {
        print("removeItemFromFavs()")
        var show = show
        show.favourite = "0"
        CoreData_.deleteItem(show: show)
        //self.showsTableView?.reloadData()
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

