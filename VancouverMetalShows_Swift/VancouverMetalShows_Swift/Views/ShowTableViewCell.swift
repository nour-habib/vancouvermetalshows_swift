//
//  ShowTableViewCell.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-18.
//

import UIKit

class ShowTableViewCell: UITableViewCell
{
    var showView: ShowView?
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showView = ShowView(frame: self.frame)
        //showView?.backgroundColor = .yellow
        
        configureCell()
    }

        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }
    
    private func configureCell()
    {
        addSubview(showView ?? ShowView())
//        self.contentView.clipsToBounds = true
        backgroundColor = .black
        //layoutMargins.left = 10
        //self.layoutMargins.top = 20
        
   
        
    }
}

