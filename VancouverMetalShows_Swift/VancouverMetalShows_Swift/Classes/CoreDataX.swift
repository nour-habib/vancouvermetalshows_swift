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
    case updateError
}

class CoreDataX
{
    init(){}

    func saveItem(show: Show) throws
    {
        let value = try? recordExists(show: show)
        
        if(value == false)
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
                throw CoreDataError.saveError
            }
        }
        else
        {
            throw CoreDataError.saveError
        }

    }

    func deleteItem(show: Show) throws
    {
        let newShow = ShowItem(context: context)
        newShow.id = show.id
        newShow.artist = show.artist
        newShow.date = show.date
        newShow.venue = show.venue
        newShow.supporting_artists = show.supporting_artists
        newShow.tickets = show.tickets
        newShow.image = show.image
        
        context.delete(newShow)
        do
        {
            try context.save()
        }
        catch
        {
            throw CoreDataError.deleteError
        }
    
    }
    
    func existsInTable(show: Show) -> Bool
    {
        let value = try? recordExists(show: show)
        if(value != nil)
        {
            return true
        }
        return false
    }
    
    private func recordExists(show: Show) throws -> Bool
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
                return true
            }
            else
            {
                return false
            }
        }
        catch
        {
            throw CoreDataError.searchError
        }
    }
    
    func clearAllItems(entityName: String)
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: entityName)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        let batchDelete = try? context.execute(batchDeleteRequest) as? NSBatchDeleteResult
        
      
        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else {return}
        
        let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deleteResult]
        
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [context])
        
    }
    
    func batchLoad(array: [Show])
    {
        if(array.count == 0)
        {
            return
        }
        
        for show in array
        {
            try? saveItem(show: show)
        }
    }
    
    func loadItems() -> [Show]
    {
        var showsArray = [ShowItem]()
        
        do
        {
            showsArray = try context.fetch(ShowItem.fetchRequest())
        }
        catch
        {
            //throw exception
            print("getAllItems: Error")
        }
        
        return convertArray(array: showsArray)
    }
    
    func updateItem(show: Show, newValue: String) throws
    {
        let fetchRequest: NSFetchRequest<ShowItem>
        fetchRequest = ShowItem.fetchRequest()
        
        let idPredicate = NSPredicate(format: "id LIKE %@", show.id)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        
        do
        {
            let objects = try context.fetch(fetchRequest)
            if (objects.count > 0)
            {
                let show = objects.first
                show?.favourite = newValue
                try context.save()
                
            }
            else
            {
                try saveItem(show: show)
            }
        }
        catch
        {
            throw CoreDataError.searchError
        }
    }
    
    private func convertArray(array: [ShowItem]) -> [Show]
    {
        var showArray = [Show]()
        
        for item in array
        {
            let show = convertItem(item: item)
            showArray.append(show)
                
        }
        
        return showArray
    }
    
    private func convertItem(item: ShowItem) -> Show
    {
        let show = Show(item.id, item.artist, item.date, item.venue, item.supporting_artists, item.tickets, item.image, item.favourite)
        
        return show
    }
}
