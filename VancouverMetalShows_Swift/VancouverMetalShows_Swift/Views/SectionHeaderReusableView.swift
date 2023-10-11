//
//  SectionHeaderReusableView.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-10-10.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView
{
    var headerTitle: UILabel?
    
    static var reuseIdentifier = "secView"
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.headerTitle = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        configureHeader()
        
    }
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeader()
    {
        headerTitle?.textColor = .white
        headerTitle?.font = UIFont(name: "CourierNewPSMT", size: 15)
        
        addSubview(headerTitle ?? UILabel())
        
    }
    
        
}
