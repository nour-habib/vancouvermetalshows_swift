//
//  Date.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-28.
//

import Foundation

class Date
{
    static let shared = Date()
    
    func formatDate(dateString: String, format: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
    
        guard let date = dateFormatter.date(from: dateString) else { return "none" }
        
        let newDateFormatter = DateFormatter()
        //EEEE, MMM d, yyyy
        newDateFormatter.dateFormat = format
        let newDateString = newDateFormatter.string(from: date)

        return newDateString
        
    }
    

    
    
}
