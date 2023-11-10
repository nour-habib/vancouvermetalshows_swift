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
    //private var showView: ShowView?
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
    
//    override func viewWillLayoutSubviews()
//    {
//        super.viewWillLayoutSubviews()
//
//        guard let layout = collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout else {
//            return
//        }
//        layout.invalidateLayout()
//    }
//
    //MARK: CollectionView Configuratioin
    
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
        collectionView.refreshControl = UIRefreshControl()
        
        collectionView.reloadData()
        view.addSubview(collectionView)
        applyCollectionViewConstraints()
    }
    
    private func applyCollectionViewConstraints()
    {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
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
        
        guard let indexPath = indexPath, var showsDict = showsDict else {return}
        guard let show = dataSource.itemIdentifier(for: indexPath) else {return}
        
        do
        {
            try CoreData_.updateItem(show: show, newValue: "0")
        }
        catch
        {
            //insert errror
        }
        
        var snapshot = dataSource.snapshot()
        guard let section = snapshot.sectionIdentifier(containingItem: show)else {return}
        let numberOfItemsInSection = snapshot.numberOfItems(inSection: section)
        print("numberOfItems: ", numberOfItemsInSection)
        
        guard var showsInSection = showsDict[section.month] else {return}
        print("showsInSection count: ", showsInSection.count)
        
        showsInSection.remove(at: indexPath[1])
        
        if(showsInSection.count == 0)
        {
            snapshot.deleteSections([section])
            dataSource.apply(snapshot)
        }
        else
        {
            showsDict.updateValue(showsInSection, forKey: section.month)
            snapshot.deleteItems([show])
            dataSource.apply(snapshot)
        }
    }
    
    //MARK: Fetch and Process Data
    
    private func loadData() -> [String:[Show]]
    {
        let allShows = CoreData_.loadItems()
        let favShowsArray = Show.sortShows(shows: filterFavShows(array: allShows))
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
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/4)
        ), subitems: [item])
        //group.interItemSpacing = .fixed(itemSpacing)
        
        group.edgeSpacing =  NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
        
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 5
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
        return UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    }
}

private extension FavouritesViewController
{
    func configureSectionHeader()
    {
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
