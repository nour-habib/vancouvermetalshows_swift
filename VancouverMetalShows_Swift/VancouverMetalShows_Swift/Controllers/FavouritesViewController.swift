//
//  FavouritesViewController.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-20.
//

import UIKit

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UIGestureRecognizerDelegate
{
    private lazy var dataSource = initDataSource()
    private lazy var collectionView = makeCollectionView()
    private var showsArray: [ShowItem]?
    private var favShowsArray: [Show]?
    private var showView: ShowView?
    private var showsDict: [String: [Show]]?
    
    static let cellWidth = 156.0
    static let cellHeight = 201.0
    
    static let groupWidth = UIScreen.main.bounds.width-50
    static let groupHeight = cellHeight + 5
    
    //private lazy var dataSource = initDataSource()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "Favs"
        
        //CoreData_.clearAllItems(entityName: "ShowItem")
        
        getAllItems()
        self.favShowsArray = convertArray(array: showsArray ?? [])
        print("favShowsArray size: ", favShowsArray?.count)
        
        guard let favShowsArray = favShowsArray else {
            return
        }
        
        self.showsDict = groupShowsByMonth(array: favShowsArray)
        print("group: ", showsDict)
        
        print("showsArray size: ", showsArray?.count)
        
        configureCollectionView()
        
        showsListDidLoad(showsDict ?? [String:[Show]]())
        configureSectionHeader()
        
        let ids = dataSource.snapshot().sectionIdentifiers
        print("snapshot section ids: ", ids)
        print("ids count: ", ids.count)
        
    }
    
    private func configureCollectionView()
    {
        
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.largeContentTitle = "Favs"
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true
        //collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        
        
        collectionView.reloadData()
        
        view.addSubview(collectionView ?? UICollectionView())
        
    
    }

    
    //MARK: CollectionView Methods
    
    //MARK: Long Press Gesture to Delete Item
    private func initLongPressGesture()
    {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        gesture.minimumPressDuration = 2
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        
        self.collectionView.addGestureRecognizer(gesture)
        
    }
    
    @objc func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer)
    {
        guard gestureRecognizer.state != .began else{return}
        let point = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if let index = indexPath
        {
            print(index.row)
        }
        else
        {
            print("Could not finid index path)")
        }
        
        guard let indexPath = indexPath else {return}
        
        guard let show = self.favShowsArray?[indexPath.row] else {return}
        
        self.collectionView.deleteItems(at: [indexPath])
        
        CoreData_.deleteItem(show: show)
        print("Item deleted")
        self.favShowsArray?.remove(at: indexPath.row)
        print("favShowsArray count: ", favShowsArray?.count)
        //self.collectionView?.reloadData()
        
    }
    
    //MARK: Get Favs from CoreData
    
    private func getAllItems() -> Void
    {
        do
        {
            self.showsArray = try context.fetch(ShowItem.fetchRequest())
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        }
        catch
        {
            //throw exception
            print("getAllItems: Error")
        }
            
    }
    
    //MARK: Convert ShowItem to Show
    
    private func convertItem(item: ShowItem) -> Show
    {
        let show = Show(item.id, item.artist, item.date, item.venue, item.supporting_artists, item.tickets, item.image, item.favourite)
        
        return show
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
    
    //MARK: Display Alert
    
//    private func displayAlert()
//    {
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
//               let alertController = UIAlertController(title: "Confirm delete", message: "Are you sure you would like to delete?", preferredStyle: .alert)
//
//            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: nil)) // temp nil for now
//            self?.present(alertController, animated: true)
//           }
//
//           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//           // Add all the actions to acMain
//           acMain.addAction(renameAction)
//           acMain.addAction(deleteAction)
//           acMain.addAction(cancelAction)
//           present(acMain, animated: true)
//    }
    
    private func groupShowsByMonth(array: [Show]) -> [String: [Show]]
    {
        var dict: [String: [Show]] = [:]
        

        if(array.count == 0)
        {
            return dict
        }

        for show in array
        {
            let month = Date.shared.formatDate(dateString: show.date, currentFormat: "yyy-MM-dd",format: "M")
            print("month: " , month)
            if (dict.keys.contains(month))
            {
                var arr = dict[month]
                arr?.append(show)
                dict.updateValue(arr ?? [], forKey: month)
            }
            else
            {
                var arr: [Show] = []
                arr.append(show)
                dict.updateValue(arr, forKey: month)
            }
        }
        
        


        return dict
    }

}

extension FavouritesViewController: UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("numberOfItemsInSection()")
        return  dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print("cellForItemAt()")
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("didSelectItemAt()")
        print("User tapped on item \(indexPath.row)")
        print("section: ", indexPath.section)
//        print(dataSource.snapshot().numberOfItems(inSection: FavouritesViewController.Section(rawValue: indexPath.section)!))
        //guard let show = dataSource.itemIdentifier(for: indexPath) else {return}
        //initLongPressGesture()
    }
    
}


private extension FavouritesViewController
{
    func initDataSource() -> UICollectionViewDiffableDataSource<MonthSection, Show>
    {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView ,
                    cellProvider: makeCellRegistration().cellProvider
                )
    }
}

private extension FavouritesViewController
{
    func showsListDidLoad(_ dict: [String: [Show]] )
    {
        print("showsListDidLoad()")
        //var snapshot = NSDiffableDataSourceSnapshot<MonthSection, Show>()

//        Section.allCases.forEach { snapshot.appendSections([$0]) }
//        dict.forEach { (key: String, value: [Show]) in
//            snapshot.appendItems(value, toSection: Section.init(rawValue: (Int(key) ?? 0) ))
//
//        }
      
        //dataSource.apply(snapshot)
        var snapshot = NSDiffableDataSourceSnapshot<MonthSection, Show>()
        
        var sectionArray = [MonthSection]()
        dict.forEach { (key: String, value: [Show]) in
            let section = MonthSection(month: key, shows: value)
            sectionArray.append(section)
        }
        
        sectionArray.forEach { MonthSection
            in
            snapshot.appendSections([MonthSection])
            snapshot.appendItems(MonthSection.shows, toSection: MonthSection)
            
        }
        dataSource.apply(snapshot, animatingDifferences: false)
        
        
    }
}

private extension FavouritesViewController
{
    func applySnapshot(_ shows: [Show], month: String, snapshot: NSDiffableDataSourceSnapshot<MonthSection, Show> )
    {
        var snapshot = snapshot
        //var snapshot = NSDiffableDataSourceSnapshot<MonthSection, Show>()
        let section = MonthSection(month: month, shows: shows)
        snapshot.appendSections([section])
        dataSource.apply(snapshot, animatingDifferences: false)
        snapshot.appendItems(shows, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
}


private extension FavouritesViewController
{
    typealias Cell = FavShowCollectionViewCell
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Show>

    func makeCellRegistration() -> CellRegistration
    {
        CellRegistration { cell, indexPath, show in
            cell.showView?.artistLabel?.text = show.artist
            let formattedDate = Date.shared.formatDate(dateString: show.date , currentFormat: "yyy-MM-dd", format: "EEE, MMM d, yyyy")
            cell.showView?.dateLabel?.text = formattedDate
            
            cell.showView?.ticketsLabel?.text = show.tickets
            cell.showView?.venueLabel?.text = show.venue
            cell.showView?.suppArtistLabel?.text = show.supporting_artists
            cell.showView?.imageView?.image = UIImage(named: show.image )
    
        }
    }
}

extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        return { collectionView, indexPath, show in
            collectionView.dequeueConfiguredReusableCell(
                using: self,
                for: indexPath,
                item: show
            )
        }
    }
}


private extension FavouritesViewController {
    func makeLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .estimated(1/2),
            heightDimension: .estimated(1/2)
        ))
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(2), top: .fixed(2), trailing: .fixed(2), bottom: .fixed(2))
        
        //let numOfSecs = dataSource.numberOfSections(in: collectionView)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalHeight(0.55)
        ), subitems: [item]
        )
        
        
       // group.interItemSpacing = .flexible(4)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
       // section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(25))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
       // sectionHeader.zIndex = 5
        
        return section
    }
}

private extension FavouritesViewController{
    func makeCollectionViewLayout() -> UICollectionViewLayout
    {
        UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, _ in
            
            return self?.makeLayoutSection()
        }
    }
}

private extension FavouritesViewController
{
    func makeCollectionView() -> UICollectionView
    {
        UICollectionView(
            frame: CGRect(x:0,y:90,width:self.view.frame.width,height:self.view.frame.height),
            collectionViewLayout: makeCollectionViewLayout()
        )
    }
}

private extension FavouritesViewController
{
    func configureSectionHeader()
    {
        print("confiigureSecHeader()")
        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView in
            
            
            let header: SectionHeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,for: indexPath) as! SectionHeaderReusableView
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
           // header.headerTitle?.text = "\(section)"
            header.headerTitle?.text = section.month
            
            
            print("titleLabel: ")
            print("\(section)")
            
            
            //assert(false, "invalid element type")
            return header
           
            
            
        }
    }
    
}


private extension FavouritesViewController
{
    enum Section: Int, CaseIterable,Hashable
    {
        static var allCases: [FavouritesViewController.Section]
        {
            return [.Jan,.Feb,.Mar,.Apr, .Jun, .Jul, .Aug, .Sep, .Oct, .Nov, .Dec]
        }
        
        case Jan = 1
        case Feb = 2
        case Mar = 3
        case Apr = 4
        case May = 5
        case Jun = 6
        case Jul = 7
        case Aug = 8
        case Sep = 9
        case Oct = 10
        case Nov = 11
        case Dec = 12
        
        @available(*, unavailable)
           case all
    }
    
    struct MonthSection: Hashable
    {
       var month: String
       var shows: [Show]
    }
    
}
