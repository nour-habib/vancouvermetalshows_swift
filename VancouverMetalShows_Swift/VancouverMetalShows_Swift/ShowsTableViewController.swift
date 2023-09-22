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

class ShowsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    weak var delegate: ShowsTableViewControllerDelegate?
    
    private var detailView: DetailView?
    private var showsTableView: ShowsTableView?
    private var showsArray = [Show]()

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
        self.showsTableView?.register(ShowTableViewCell.self, forCellReuseIdentifier: "cellId")
        self.showsTableView?.delegate = self
        self.showsTableView?.dataSource = self
        self.view.addSubview(self.showsTableView!)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissDetailView))
//                tapGesture.cancelsTouchesInView = false
//                self.showsTableView?.addGestureRecognizer(tapGesture)
        
    }
    
//    @objc func dismissDetailView()
//    {
//        UIView.animate(withDuration: 1.0, animations: {
//            self.detailView?.alpha = 0.0
//            self.detailView?.isHidden = true
//       })
//    }
    
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
        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        cell.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
//        tap.numberOfTapsRequired = 2
//        cell.addGestureRecognizer(tap)
        
        let show = showsArray[indexPath.row]
        
        cell.showView?.artistLabel?.text = show.artist
        cell.showView?.venueLabel?.text = show.venue
        cell.showView?.dateLabel?.text = show.date
        cell.showView?.imageView?.image =  UIImage(named: show.image)
       
        
    
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("row is clicked")
        let show = showsArray[indexPath.row]
        self.detailView = DetailView(frame: CGRect(x:50,y:200,width:(0.7)*UIScreen.main.bounds.width, height:300), show: show)
        
        UIView.animate(withDuration: 1,delay:0, options: .curveEaseInOut,animations:{
            self.detailView?.alpha = 1
            self.view.addSubview(self.detailView ?? UIView())
            
        })
        
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        // 1
//        let headerView = UIView()
//        // 2
//        headerView.backgroundColor = view.backgroundColor
//        // 3
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, titleForFooterInSection
//                                section: Int) -> String? {
//       return "Footer \(section)"
//    }
    


}

