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
    
    func formatDate(dateString: String, currentFormat: String, format: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
    
        guard let date = dateFormatter.date(from: dateString) else { return "none" }
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = format
        let newDateString = newDateFormatter.string(from: date)

        return newDateString
        
    }
    

    
    
}
