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
    var favButton: UIButton?
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showView = ShowView(frame: self.frame)
        self.favButton = UIButton()
        
        configureCell()
        configureHeartButton()
        configureConstraints()
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
        backgroundColor = .black
        addSubview(showView ?? ShowView())
        
        autoresizingMask = .flexibleWidth
        layoutIfNeeded()
    }
    
    private func configureConstraints()
    {
        guard let imageView = showView?.imageView else {return}
        guard let artistLabel = showView?.artistLabel else {return}
        guard let venueLabel = showView?.venueLabel else {return}
        guard let dateLabel = showView?.dateLabel else {return}
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10).isActive = true
        artistLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        artistLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        artistLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        venueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 15).isActive = true
        venueLabel.topAnchor.constraint(equalTo: artistLabel.centerYAnchor, constant: 10).isActive = true
        venueLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        venueLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
    }
    
    private func configureHeartButton()
    {
        guard let favButton = favButton else {return}
        addSubview(favButton)
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favButton.rightAnchor.constraint(equalTo:contentView.rightAnchor, constant: -30).isActive = true
        favButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
    
    }
    
    
    
//    func didTapHeartButton()
//    {
//
//    }
}

