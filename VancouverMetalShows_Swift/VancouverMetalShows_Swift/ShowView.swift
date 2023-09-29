//
//  ShowView.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-18.
//

import UIKit

class ShowView: UIView
{
    var artistLabel: UILabel?
    var venueLabel: UILabel?
    var suppArtistLabel: UILabel?
    var ticketsLabel: UILabel?
    var dateLabel: UILabel?
    var imageView: UIImageView?
   
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.artistLabel = UILabel(frame: CGRect(x: 130, y: 25, width: 100, height: 50))
        self.venueLabel = UILabel(frame: CGRect(x: 130, y: 60, width: 150, height: 50))
        self.suppArtistLabel = UILabel(frame: CGRect(x: 130, y: 120, width: 100, height: 50))
        self.ticketsLabel = UILabel(frame: CGRect(x: 130, y: 160, width: 100, height: 50))
        self.dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        self.imageView = UIImageView(frame: CGRect(x:18,y:25,width:80,height:80))
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView()
    {
      
        let textAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15) ]

        
        artistLabel?.textColor = .white
        artistLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        venueLabel?.textColor = .white
        venueLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        suppArtistLabel?.textColor = .white
        ticketsLabel?.textColor = .white
        dateLabel?.textColor = .white
        dateLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        dateLabel?.backgroundColor = .lightGray
        dateLabel?.textAlignment = .center
        
        imageView?.contentMode = .scaleAspectFit
        
        addSubview(artistLabel ?? UILabel())
        addSubview(venueLabel ?? UILabel())
        addSubview(suppArtistLabel ?? UILabel())
        addSubview(ticketsLabel ?? UILabel())
        addSubview(dateLabel ?? UILabel())
        addSubview(imageView ?? UIImageView())
       
        
    }

    
}
