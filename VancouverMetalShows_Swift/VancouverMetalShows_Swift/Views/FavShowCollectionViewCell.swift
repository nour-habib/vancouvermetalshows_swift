//
//  FavShowCollectionViewCell.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-10-03.
//

import UIKit

class FavShowCollectionViewCell: UICollectionViewCell
{
    var showView: ShowView?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.showView = ShowView(frame: frame)
        
        configureView()

    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView()
    {
        let textSize = CGFloat(14)
        let fontType = "HelveticaNeue"
        
        showView?.ticketsLabel?.font = UIFont(name: fontType, size: textSize)
        showView?.venueLabel?.font = UIFont(name: fontType, size: textSize)
        showView?.suppArtistLabel?.font = UIFont(name: fontType, size: textSize)
        
        showView?.layer.borderColor = UIColor.lightGray.cgColor
        showView?.layer.borderWidth = 0.9
        showView?.backgroundColor = .yellow
        
        showView?.dateLabel?.frame = CGRect(x: 0, y: 0, width: frame.width, height: 20)
        showView?.artistLabel?.frame = CGRect(x: 10, y: 65, width:100, height: 50)
        showView?.venueLabel?.frame = CGRect(x: 10, y: 80, width:150, height: 50)
        showView?.suppArtistLabel?.frame = CGRect(x: 10, y: 100, width: 100, height: 50)
        showView?.ticketsLabel?.frame = CGRect(x: 110, y: 8, width: 100, height: 50)
        showView?.imageView?.frame = CGRect(x: 35, y: 30, width: 80, height: 80)
        
        
        
        contentView.addSubview(showView ?? ShowView())
    }
    
}
