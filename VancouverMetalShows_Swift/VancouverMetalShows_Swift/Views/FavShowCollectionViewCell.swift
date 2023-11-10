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
        self.showView = ShowView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        //autoresizingMask = .flexibleWidth
        //layoutIfNeeded()
        
        configureView()
        applyConstraints()
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView()
    {
        let textSize = CGFloat(14)
        let fontType = "HelveticaNeue"
        
        guard let showView = showView else {return}

        showView.ticketsLabel?.font = UIFont(name: fontType, size: textSize)
        showView.venueLabel?.font = UIFont(name: fontType, size: textSize)
        showView.suppArtistLabel?.font = UIFont(name: fontType, size: textSize)
        
        showView.layer.borderColor = UIColor.lightGray.cgColor
        showView.layer.borderWidth = 0.9
        showView.backgroundColor = .black
        showView.suppArtistLabel?.numberOfLines = 3

        contentView.addSubview(showView)
    }
    
    private func applyConstraints()
    {
        guard let artistLabel = showView?.artistLabel,
              let dateLabel = showView?.dateLabel,
              let venueLabel = showView?.venueLabel,
              let ticketsLabel = showView?.ticketsLabel,
              let imageView = showView?.imageView else {return}
        
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        
        ticketsLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 65).isActive = true
        ticketsLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 5).isActive = true
        ticketsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ticketsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 35).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        artistLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        artistLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        artistLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true

        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        venueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        venueLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: -15).isActive = true
        venueLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        venueLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
    
}
