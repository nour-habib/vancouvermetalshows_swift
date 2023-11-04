//
//  Show.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-17.
//

import Foundation

class Show: Decodable, Hashable
{
    var id: String
    var artist: String
    var date: String
    var venue:String
    var supporting_artists: String
    var tickets: String
    var image: String
    var favourite: String
    
   init(_ id: String?=nil, _ artist:String?=nil, _ date:String?=nil, _ venue: String?=nil, _ supporting_artists: String?=nil, _ tickets: String?=nil, _ image: String?=nil, _ favourite: String?=nil)
   {
       self.id = id ?? "-1"
       self.artist = artist ?? ""
       self.date = date ?? ""
       self.venue = venue ?? ""
       self.supporting_artists = supporting_artists ?? ""
       self.tickets = tickets ?? ""
       self.image = image ?? ""
       self.favourite = favourite ?? ""
   }
    
    static func == (lhs: Show, rhs: Show) -> Bool
    {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
    
    
    static func sortShows(shows: [Show]) -> [Show]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let sorted = shows
            .map { return ($0, dateFormatter.date(from: $0.date)!) }
            .sorted { $0.1 < $1.1 }
            .map(\.0)

        return sorted
    }
    
}
