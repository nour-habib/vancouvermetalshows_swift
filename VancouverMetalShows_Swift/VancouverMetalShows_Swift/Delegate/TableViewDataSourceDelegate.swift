//
//  DataSource.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-11-04.
//

import Foundation
import UIKit

class TableViewDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate
{
    private var showsArray: [Show]
    
    init(shows:[Show])
    {
        self.showsArray = shows
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return showsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ShowTableViewCell
        cell.selectionStyle = .none
        
        let show = showsArray[indexPath.row]
        
        cell.showView?.artistLabel?.text = show.artist
        cell.showView?.venueLabel?.text = show.venue
        
        let formattedDate = Date.shared.formatDate(dateString: show.date, currentFormat: "yyy-MM-dd", format: "MMM d, yyyy")
        
        cell.showView?.dateLabel?.text = formattedDate.uppercased()
        cell.showView?.imageView?.image =  UIImage(named: show.image)

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .small)
        let heartIcon = UIImage(systemName: "heart.square.fill", withConfiguration:symbolConfig)
        
        if(show.favourite == "1")
        {
            cell.favButton?.setImage(heartIcon, for: .normal)
            cell.favButton?.backgroundColor = CustomColor.ninjaGreen
            cell.favButton?.addAction(UIAction{_ in
                cell.favButton?.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.favButton?.backgroundColor = .clear
                try? CoreData_.updateItem(show: show, newValue: "0")
                self.showsArray = Show.sortShows(shows: CoreData_.loadItems())
            }, for: .touchUpInside)
        }
        else
        {
            cell.favButton?.setImage(UIImage(systemName: "heart", withConfiguration: symbolConfig), for: .normal)
            cell.favButton?.addAction(UIAction{_ in
                try? CoreData_.updateItem(show: show, newValue: "1")
                self.showsArray = Show.sortShows(shows: CoreData_.loadItems())
                cell.favButton?.setImage(UIImage(systemName: "heart.square.fill", withConfiguration: symbolConfig), for: .normal)
                cell.favButton?.backgroundColor = CustomColor.ninjaGreen
            }, for: .touchUpInside)
        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let show = showsArray[indexPath.row]
        let detailView = DetailView(frame: CGRect(x:60,y:200,width:(0.7)*UIScreen.main.bounds.width, height:300), show: show)
       
        UIView.animate(withDuration: 1,delay:0, options: .curveEaseInOut,animations:{
            detailView.alpha = 0.9
            tableView.addSubview(detailView)
            
        })
    }
}
