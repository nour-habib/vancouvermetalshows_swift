//
//  FavouritesViewController.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-20.
//

import UIKit

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate
{
    
    private var collectionView: UICollectionView?
    private var showsArray: [ShowItem]?
    private var favShowsArray: [Show]?
    private var showView: ShowView?
    private var cellWidth = 0
    private var cellHeight = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "Favs"
        
        print("Screen width: ", UIScreen.main.bounds.width)
        print("Screen height: ", UIScreen.main.bounds.height)
        
        //CoreData_.clearAllItems(entityName: "ShowItem")
        
        getAllItems()
        self.favShowsArray = convertArray(array: showsArray ?? [])
        print("favShowsArray size: ", favShowsArray?.count)
        
        guard let favShowsArray = favShowsArray else {
            return
        }
        
        
 
        
        print("showsArray size: ", showsArray?.count)
        configureCollectionView()
//        configureShowView()
    }
    
    private func configureCollectionView()
    {
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 26, bottom: 26, right: 0)
        self.cellWidth = 156
        self.cellHeight = 201
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        self.collectionView = UICollectionView(frame: CGRect(x:0,y:90,width:self.view.frame.width,height:self.view.frame.height), collectionViewLayout: layout)
        collectionView?.backgroundColor = .black
        collectionView?.register(FavShowCollectionViewCell.self, forCellWithReuseIdentifier: "celly")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.largeContentTitle = "Favs"
        collectionView?.isScrollEnabled = true
        collectionView?.isUserInteractionEnabled = true
        collectionView?.alwaysBounceVertical = true
        collectionView?.reloadData()
        
        
        
        view.addSubview(collectionView ?? UICollectionView())
    }

    
    //MARK: CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return favShowsArray?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celly", for: indexPath) as! FavShowCollectionViewCell
        //cell.clipsToBounds = true
        
        let show = favShowsArray?[indexPath.row]
        cell.showView?.artistLabel?.text = show?.artist
        
        let formattedDate = Date.shared.formatDate(dateString: show?.date ?? "000", format: "MMM dd,yyy")
        cell.showView?.dateLabel?.text = formattedDate
        
        let textSize = CGFloat(14)
        let fontType = "HelveticaNeue"
        
        cell.showView?.ticketsLabel?.text = show?.tickets
        cell.showView?.ticketsLabel?.font = UIFont(name: fontType, size: textSize)
        cell.showView?.venueLabel?.text = show?.venue
        cell.showView?.venueLabel?.font = UIFont(name: fontType, size: textSize)
        cell.showView?.suppArtistLabel?.text = show?.supporting_artists
        cell.showView?.suppArtistLabel?.font = UIFont(name: fontType, size: textSize)
        cell.showView?.imageView?.image = UIImage(named: show?.image ?? "")
        cell.showView?.imageView?.alpha = 0.6
        cell.showView?.imageView?.layer.zPosition = -1
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        initLongPressGesture()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        print("numOFSectiions")
        return 1
    }
    
    //MARK: Long Press Gesture to Delete Item
    private func initLongPressGesture()
    {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        gesture.minimumPressDuration = 2
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        
        self.collectionView?.addGestureRecognizer(gesture)
        
    }
    
    @objc func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer)
    {
        guard gestureRecognizer.state != .began else{return}
        let point = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
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
        
        self.collectionView?.deleteItems(at: [indexPath])
        
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
                self.collectionView?.reloadData()
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

}
