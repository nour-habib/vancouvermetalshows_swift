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
    private var showsDict: [String: [Show]]?

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
        
    }

    //MARK: CollectionView Configuration
    
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

    
    //MARK: Delete collectionView item
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
            print("Update error")
        }
        
        var snapshot = dataSource.snapshot()
        guard let section = snapshot.sectionIdentifier(containingItem: show)else {return}
        guard var showsInSection = showsDict[section.month] else {return}
        
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
        return  dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        initLongPressGesture()
    }
    
}

//MARK: Diffable DataSource

private extension FavouritesViewController
{
    func initDataSource() -> UICollectionViewDiffableDataSource<MonthSection, Show>
    {
       return UICollectionViewDiffableDataSource(collectionView: collectionView ,cellProvider: makeCellRegistration().cellProvider)
    }
}

private extension FavouritesViewController
{
    func showsListDidLoad(_ dict: [String: [Show]] )
    {
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

//MARK: CollectionView Cell

private extension FavouritesViewController
{
    func makeCellRegistration() -> UICollectionView.CellRegistration<FavShowCollectionViewCell, Show>
    {
        UICollectionView.CellRegistration<FavShowCollectionViewCell, Show> { cell, indexPath, show in
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

//MARK: CollectionView Cell Registration

extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> FavShowCollectionViewCell
    {
        return { collectionView, indexPath, show in
            collectionView.dequeueConfiguredReusableCell(
                using: self,
                for: indexPath,
                item: show
            ) as! FavShowCollectionViewCell
        }
    }
}

//MARK: CollectionView Layout Section

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
        
        group.edgeSpacing =  NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

//MARK: CollectionView Compositional Layout

private extension FavouritesViewController
{
    func makeCollectionViewLayout() -> UICollectionViewLayout
    {
        return UICollectionViewCompositionalLayout
        {
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

//MARK: CollectionView Section Header

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
        self.showsDict = loadData()
        showsListDidLoad(showsDict ?? [String:[Show]]())
        configureCollectionView()
        configureSectionHeader()
    }
    
}
