//
//  ShowItem+CoreDataProperties.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-22.
//
//

import Foundation
import CoreData


extension ShowItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowItem> {
        return NSFetchRequest<ShowItem>(entityName: "ShowItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var artist: String?
    @NSManaged public var date: String?
    @NSManaged public var venue: String?
    @NSManaged public var supporting_artists: String?
    @NSManaged public var image: String?
    @NSManaged public var tickets: String?
    @NSManaged public var favourite: String?
}

extension ShowItem : Identifiable {

}
