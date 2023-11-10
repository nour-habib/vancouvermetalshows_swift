//
//  IntroView.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-11-09.
//

import UIKit

class IntroView: UIView
{
    lazy var logoImageView: UIImageView =
    {
        let logoImageView = UIImageView(image: UIImage(named: "vms_logo"))
        return logoImageView
        
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        applyConstraints()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints()
    {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        //logoImageView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        
    }
    

}
