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
        //self.artistLabel = UILabel(frame: CGRect(x: 130, y: 25, width: 100, height: 50))
        self.artistLabel = UILabel()
        
        //self.venueLabel = UILabel(frame: CGRect(x: 130, y: 60, width: 150, height: 50))
        self.venueLabel = UILabel()
        //self.suppArtistLabel = UILabel(frame: CGRect(x: 130, y: 120, width: 100, height: 50))
        self.suppArtistLabel = UILabel()
        self.ticketsLabel = UILabel()
        //self.ticketsLabel = UILabel(frame: CGRect(x: 130, y: 160, width: 100, height: 50))
        //self.dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 16))
        self.dateLabel = UILabel()
        
        //self.imageView = UIImageView(frame: CGRect(x:18,y:25,width:80,height:80))
        self.imageView = UIImageView()
        
        configureView()
        
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView()
    {
        
        let textColor = CustomColor.ninjaGreen
        let textSize = CGFloat(17)
        //let fontType = "Helvetica-Bold"
        let fontType = "HelveticaNeue-Bold"
        
        artistLabel?.textColor = textColor
        artistLabel?.font = UIFont(name: fontType, size: textSize)
        
        venueLabel?.textColor = textColor
        venueLabel?.font = UIFont(name: fontType, size: textSize)
        
        suppArtistLabel?.textColor = textColor
        suppArtistLabel?.font = UIFont(name: fontType, size: textSize)
        
        ticketsLabel?.textColor = textColor
        ticketsLabel?.font = UIFont(name: fontType, size: textSize)
        
        dateLabel?.textColor = .white
        dateLabel?.backgroundColor = CustomColor.ninjaGreen
        dateLabel?.textAlignment = .center
        dateLabel?.font = UIFont(name: "CourierNewPSMT", size: 14)
       
        
        imageView?.contentMode = .scaleAspectFit
        
        addSubview(artistLabel ?? UILabel())
        addSubview(venueLabel ?? UILabel())
        addSubview(suppArtistLabel ?? UILabel())
        addSubview(ticketsLabel ?? UILabel())
        addSubview(dateLabel ?? UILabel())
        addSubview(imageView ?? UIImageView())
       
        
    }

    
}
