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
        configureCell()
        

        
        //configureTapGesture()
        
        
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
        self.addSubview(showView!)
//        self.contentView.clipsToBounds = true
        self.backgroundColor = .black
        self.layoutMargins.left = 10
        //self.layoutMargins.top = 20
        
    }
    
//    private func configureTapGesture()
//   {
//       let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
//       tap.numberOfTapsRequired = 2
//       addGestureRecognizer(tap)
//   }
//   
//   @objc func doubleTap()
//   {
//       //add show to favs
//   }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

