//
//  Show.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-17.
//

import Foundation

struct ShowRoot: Codable, Hashable
{
    let shows: [Show]
}

struct Show: Codable, Hashable
{
    var id: String = ""
    var artist: String = ""
    var date: String = ""
    var venue: String = ""
    var supporting_artists: String = ""
    var tickets: String = ""
    var image: String = ""
    var favourite: String = ""


    init(_ id: String?, _ artist: String?,_ date: String?,_ venue: String?,_ supporting_artists: String?,_ tickets: String?,_ image: String?,_ favourite: String?)
    {
        self.id = id ?? ""
        self.artist = artist ?? ""
        self.date = date ?? ""
        self.venue = venue ?? ""
        self.supporting_artists = supporting_artists ?? ""
        self.tickets = tickets ?? ""
        self.image = image ?? ""
        self.favourite = favourite ?? ""
}
    
    init(){}
    
//    func sortObjectsByDate(shows: [Show]) -> [Show]
//    {
//        for show in shows
//        {
//            let dateFormatter = DateFormatter()
//            let date = dateFormatter.date(from: show.date)
//             
//            
//        }
//    }

}
