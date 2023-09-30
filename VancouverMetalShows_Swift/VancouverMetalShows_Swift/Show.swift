//
//  Show.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-17.
//

import Foundation

struct ShowRoot: Codable
{
    let shows: [Show]
}

struct Show: Codable
{
    var id: String
    var artist: String
    var date: String
    var venue: String
    var supporting_artists: String
    var tickets: String
    var image: String
    var favourite: String


    init(id: String?, artist: String?, date: String?, venue: String?, supporting_artists: String?, tickets: String?, image: String?, favourite: String?)
    {
    self.id = id ?? "x"
    self.artist = artist ?? ""
    self.date = date ?? ""
    self.venue = venue ?? ""
    self.supporting_artists = supporting_artists ?? ""
    self.tickets = tickets ?? ""
    self.image = image ?? ""
    self.favourite = favourite ?? ""
}

}
