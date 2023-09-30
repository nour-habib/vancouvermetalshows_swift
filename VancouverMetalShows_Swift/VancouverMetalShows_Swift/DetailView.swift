//
//  DetailView.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-20.
//

import UIKit


protocol DetailViewDelegate: AnyObject
{
    func didCloseView()
}

class DetailView: UIView
{
    private var show: Show?
    private var showView: ShowView?
    
    weak var delegate: DetailViewDelegate?
    
    init(frame: CGRect,show: Show)
    {
        super.init(frame: frame)
        self.show = show
        self.showView = ShowView(frame:CGRect(x:0, y:0, width: frame.width, height: frame.height))
        
        configureView()
        configureTapGesture()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView()
    {
        
        backgroundColor = .lightGray
        isOpaque = false
        layer.cornerRadius = 10
        layer.borderColor = CustomColor.darkGray.cgColor
        layer.borderWidth = 2

        let textColor = UIColor.white
        let textSize = CGFloat(17)
        let fontType = "Helvetica-Bold"
    
        showView?.artistLabel?.text = "Artist: " + show!.artist
        showView?.artistLabel?.frame = CGRect(x: 20, y:140, width:130, height:30)
        showView?.artistLabel?.textColor = textColor
        
        let formattedDate = Date.shared.formatDate(dateString: show?.date ?? "000", format: "MMM dd,yyy")
        
        showView?.dateLabel?.text = formattedDate
        showView?.dateLabel?.backgroundColor = .clear
        showView?.dateLabel?.frame = CGRect (x:50, y:100, width: 200, height: 30)
        showView?.dateLabel?.textColor = textColor
        showView?.dateLabel?.font = UIFont(name: fontType, size: textSize)
        
        showView?.suppArtistLabel?.text = show?.supporting_artists
        showView?.suppArtistLabel?.frame = CGRect (x:20, y:200, width: 130, height: 30)
        showView?.suppArtistLabel?.textColor = textColor
        showView?.suppArtistLabel?.font = UIFont(name: fontType, size: textSize)
        
        showView?.venueLabel?.text = show?.venue
        showView?.venueLabel?.frame = CGRect (x:20, y:165, width: 130, height: 30)
        showView?.venueLabel?.textColor = textColor
        
        showView?.ticketsLabel?.text = show?.tickets
        showView?.ticketsLabel?.frame = CGRect (x:20, y:220, width: 130, height: 30)
        showView?.ticketsLabel?.textColor = textColor
        showView?.ticketsLabel?.font = UIFont(name: fontType, size: textSize)
        
        showView?.imageView?.image = UIImage(named: show?.image ?? "")
        showView?.imageView?.frame = CGRect(x:100,y:10,width:80,height:80)
        showView?.imageView?.backgroundColor = .black
        showView?.imageView?.layer.cornerRadius = 5
        showView?.imageView?.layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 4
        
        addSubview(showView ?? UIView())
    
    }
    
    private func configureTapGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    
    }
    
    @objc func closeView()
    {
        UIView.animate(withDuration: 1.0, delay:0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
            //self.isHidden = true
            self.delegate?.didCloseView()
            
       })
        
        
    }

}
