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

/*
    static let cellWidth = 130.0
    static let cellHeight = 195.0
    
    static let groupWidth = UIScreen.main.bounds.width
    static let groupHeight = cellHeight + 20
 */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Favs"
        
       // CoreData_.clearAllItems(entityName: "ShowItem")
        self.showsDict = loadData()
        showsListDidLoad(showsDict ?? [String:[Show]]())
        
        configureCollectionView()
        
        configureSectionHeader()
        
//        let ids = dataSource.snapshot().sectionIdentifiers
//        print("snapshot section ids: ", ids)
//        print("ids count: ", ids.count)
        
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
        collectionView.bounces = true
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        
        collectionView.reloadData()
        
        view.addSubview(collectionView)
    }

    
    //MARK: Long Press Gesture to Delete Item
    private func initLongPressGesture()
    {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        gesture.minimumPressDuration = 2
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        
        collectionView.addGestureRecognizer(gesture)
        
    }
    
    @objc func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer)
    {
        guard gestureRecognizer.state != .began else{return}
        
        
        let point = gestureRecognizer.location(in: collectionView)
        
        let alertController = UIAlertController(title: "Are you sure you want to delete?", message: "", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { UIAlertAction in
            self.deleteCollectionViewItem(point: point)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
       
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
//        let alertController = UIAlertController(title: "Confirm delete", message: "Are you sure you would like to delete?", preferredStyle: .alert)
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { UIAlertAction in
//                self?.deleteCollectionViewItem(point: point)
//            }))
//            self?.present(alertController, animated: true)
//           }
//
//           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func deleteCollectionViewItem(point: CGPoint)
    {
        let indexPath = collectionView.indexPathForItem(at: point)
        print("indexPath: ", indexPath)
        
        if let index = indexPath
        {
            print(index.row)
        }
        else
        {
            print("Could not find index path)")
        }
        
        guard let indexPath = indexPath, let showsDict = showsDict else {return}
        
        guard let show = dataSource.itemIdentifier(for: indexPath) else {return}
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([show])
        dataSource.apply(snapshot)
        
        guard let section = snapshot.sectionIdentifier(containingItem: show)else {return}
        let numberOfItemsInSection = snapshot.numberOfItems(inSection: section)
        
        if(numberOfItemsInSection == 0)
        {
            snapshot.deleteSections([section])
            dataSource.apply(snapshot)
        }
        
        
        do
        {
            try CoreData_.updateItem(show: show, newValue: "0")
        }
        catch
        {
            //insert errror
        }
    }
    
    //MARK: Fetch and Process Data
    
    private func loadData() -> [String:[Show]]
    {
        let allShows = CoreData_.loadItems()
        let favShowsArray = filterFavShows(array: allShows)
        let dict = groupShowsByMonth(array: favShowsArray)
        
        return dict
    }
    
    private func filterFavShows(array: [Show]) -> [Show]
    {
        var favShows = [Show]()
        for show in array
        {
            if(show.favourite == "1")
            {
                favShows.append(show)
            }
        }
        
        return favShows
    }
    
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

//MARK: CollectionView Methods

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
        
        let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
        
        print("didSelectItemAt()")
        print("show: ", section.shows[indexPath.row])
        print("User tapped on item \(indexPath.row)")
        print("section: ", indexPath.section)
        print("cell frame: ", collectionView.cellForItem(at: indexPath)?.layer.frame)
//        print(dataSource.snapshot().numberOfItems(inSection: FavouritesViewController.Section(rawValue: indexPath.section)!))
        //guard let show = dataSource.itemIdentifier(for: indexPath) else {return}
        initLongPressGesture()
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
    typealias Cell = FavShowCollectionViewCell
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Show>

    func makeCellRegistration() -> CellRegistration
    {
        CellRegistration { cell, indexPath, show in
            cell.showView?.artistLabel?.text = show.artist
            let formattedDate = Date.shared.formatDate(dateString: show.date , currentFormat: "yyy-MM-dd", format: "MMM d, yyyy")
            cell.showView?.dateLabel?.text = formattedDate
            cell.showView?.ticketsLabel?.text = show.tickets
            cell.showView?.venueLabel?.text = show.venue
            cell.showView?.suppArtistLabel?.text = show.supporting_artists
            cell.showView?.imageView?.image = UIImage(named: show.image )
            self.initLongPressGesture()
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
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)
        ))
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/4)
        ), subitems: [item])
        //group.interItemSpacing = .fixed(itemSpacing)
        
        group.edgeSpacing =  NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
        
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        //sectionHeader.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
        
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
            let month = Date.shared.formatDate(dateString: section.month, currentFormat: "M", format: "MMMM")
            header.headerTitle?.text = month

            return header
        }
    }
    
}

private extension FavouritesViewController
{
    struct MonthSection: Hashable
    {
       var month: String
       var shows: [Show]
    }
    
}

extension FavouritesViewController: ContainerViewDelegateCV
{
    func updateCollectionView()
    {
        print("updateCollectionView()")
        self.showsDict = loadData()
        showsListDidLoad(showsDict ?? [String:[Show]]())
        configureCollectionView()
        configureSectionHeader()
    }
    
}
