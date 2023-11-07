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
        configureConstraints()
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
        layer.borderColor = CustomColor.ninjaGreen.cgColor
        layer.borderWidth = 2

        let textColor = UIColor.white
        let textSize = CGFloat(17)
        let fontType = "HelveticaNeue-Bold"
        
        guard let show = show else {return}
        
        showView?.imageView?.image = UIImage(named: show.image)
        showView?.imageView?.backgroundColor = .black
        showView?.imageView?.layer.cornerRadius = 5
        showView?.imageView?.layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 4
        
        let formattedDate = Date.shared.formatDate(dateString: show.date,currentFormat: "yyy-MM-dd", format: "MMM dd, yyy")
        
        showView?.dateLabel?.text = "Date: " + formattedDate
        showView?.dateLabel?.backgroundColor = .clear
        showView?.dateLabel?.textAlignment = .left
        showView?.dateLabel?.textColor = textColor
        showView?.dateLabel?.font = UIFont(name: fontType, size: textSize)

        showView?.artistLabel?.text = "Artist: " + show.artist
        showView?.artistLabel?.textColor = textColor
        
        showView?.venueLabel?.text = "Venue: " + show.venue
        showView?.venueLabel?.textColor = textColor
        
        showView?.suppArtistLabel?.text = "With: " + show.supporting_artists
        showView?.suppArtistLabel?.textColor = textColor
        showView?.suppArtistLabel?.font = UIFont(name: fontType, size: textSize)
        showView?.suppArtistLabel?.numberOfLines = 3
        
        showView?.ticketsLabel?.text = "Tickets: " + show.tickets
        showView?.ticketsLabel?.textColor = textColor
        showView?.ticketsLabel?.font = UIFont(name: fontType, size: textSize)
        showView?.venueLabel?.numberOfLines = 3
        
        addSubview(showView ?? UIView())
    }
    
    private func configureConstraints()
    {
        guard let artistLabel = showView?.artistLabel,
              let dateLabel = showView?.dateLabel,
              let suppArtistsLabel = showView?.suppArtistLabel,
              let venueLabel = showView?.venueLabel,
              let ticketsLabel = showView?.ticketsLabel,
              let imageView = showView?.imageView else {return}
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 97).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        artistLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0).isActive = true
        artistLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        artistLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        venueLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        venueLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 0).isActive = true
        venueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        venueLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true

        ticketsLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        ticketsLabel.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 0).isActive = true
        ticketsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ticketsLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true

        suppArtistsLabel.translatesAutoresizingMaskIntoConstraints = false
        suppArtistsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        suppArtistsLabel.topAnchor.constraint(equalTo: ticketsLabel.bottomAnchor, constant: 0).isActive = true
        suppArtistsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        suppArtistsLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
    
    private func configureTapGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func closeView()
    {
        print("closeView()")
        UIView.animate(withDuration: 1.0, delay:0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
            //self.isHidden = true
            //self.delegate?.didCloseView()
            
       })
    }

}
