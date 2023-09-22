//
//  ShowsTableView.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-18.
//

import UIKit

class ShowsTableView: UITableView
{

    override init(frame: CGRect, style: UITableView.Style)
    {
        super.init(frame: frame, style: style)
        configureTableView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView()
    {
       // self.separatorColor = .blue
        self.backgroundColor = CustomColor.offWhite
       
    }
    
    
    
}
