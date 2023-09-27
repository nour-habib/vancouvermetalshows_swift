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
        if(!recordExists(show: show))
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
    
    private func recordExists(show: Show) -> Bool
    {
        let fetchRequest: NSFetchRequest<ShowItem>
        fetchRequest = ShowItem.fetchRequest()
        
        let artistPredicate = NSPredicate(format: "artist LIKE %@", show.artist)
        let datePredicate = NSPredicate(format: "date LIKE %@", show.date)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [artistPredicate, datePredicate])
        
        do
        {
            let objects = try context.fetch(fetchRequest)
            if (objects.count > 0)
            {
                print("Record exists")
                return true
            }
            else
            {
                return false
            }
        }
        catch
        {
            print("Fetch request error")
        }
        
        return false
        
    }
}
