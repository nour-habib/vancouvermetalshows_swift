//
//  CoreDataX.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-21.
//

import Foundation
import CoreData

enum CoreDataError: Error
{
    case saveError
    case deleteError
    case searchError
}

class CoreDataX
{
    static let shared = CoreDataX()
    
    init(){}

    func createItem(show: Show)
    {
        let newShow = ShowItem(context: context)
        newShow.id = show.id
        newShow.artist = show.artist
        newShow.date = show.date
        newShow.venue = show.venue
        newShow.supporting_artists = show.supporting_artists
        newShow.tickets = show.tickets
        newShow.image = show.image

        do
        {
            try context.save()
        }
        catch
        {
            print("save error")
        }

    }

    func deleteItem(show: ShowItem)
    {
        context.delete(show)
        do
        {
            try context.save()
        }
        catch
        {
            print("delete error")
        }
    }
}
