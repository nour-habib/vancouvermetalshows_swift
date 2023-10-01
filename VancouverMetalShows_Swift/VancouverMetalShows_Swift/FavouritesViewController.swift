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

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "Favs"
        
        getAllItems()
        self.favShowsArray = convertArray(array: showsArray ?? [])
        print("favShowsArray size: ", favShowsArray?.count)
        
        print("showsArray size: ", showsArray?.count)
        configureCollectionView()
    }
    
    private func configureCollectionView()
    {
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 140, height: 170)
        self.collectionView = UICollectionView(frame: CGRect(x:0,y:90,width:self.view.frame.width,height:self.view.frame.height), collectionViewLayout: layout)
        collectionView?.backgroundColor = .black
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "celly")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.largeContentTitle = "Favs"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celly", for: indexPath)
        //cell.clipsToBounds = true

        self.showView = ShowView(frame: cell.frame)
        showView?.layer.borderColor = UIColor.lightGray.cgColor
        showView?.layer.borderWidth = 0.8
        showView?.backgroundColor = .clear
        
        showView?.dateLabel?.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 20)
        showView?.artistLabel?.frame = CGRect(x: 10, y: 65, width:100, height: 50)
        showView?.venueLabel?.frame = CGRect(x: 10, y: 80, width:150, height: 50)
        showView?.suppArtistLabel?.frame = CGRect(x: 10, y: 100, width: 100, height: 50)
        showView?.ticketsLabel?.frame = CGRect(x: 110, y: 8, width: 100, height: 50)
        showView?.imageView?.frame = CGRect(x: 35, y: 30, width: 80, height: 80)
        
        let show = favShowsArray?[indexPath.row]
        
        
        showView?.artistLabel?.text = show?.artist
        
        let formattedDate = Date.shared.formatDate(dateString: show?.date ?? "000", format: "MMM dd,yyy")
        showView?.dateLabel?.text = formattedDate
        
        let textSize = CGFloat(14)
        let fontType = "HelveticaNeue"
        
        showView?.ticketsLabel?.text = show?.tickets
        showView?.ticketsLabel?.font = UIFont(name: fontType, size: textSize)
        showView?.venueLabel?.text = show?.venue
        showView?.venueLabel?.font = UIFont(name: fontType, size: textSize)
        showView?.suppArtistLabel?.text = show?.supporting_artists
        showView?.suppArtistLabel?.font = UIFont(name: fontType, size: textSize)
        showView?.imageView?.image = UIImage(named: show?.image ?? "")
        showView?.imageView?.alpha = 0.6
        showView?.imageView?.layer.zPosition = -1
        
        showView?.artistLabel?.removeFromSuperview()

        cell.addSubview(showView ?? UIView())
        initLongPressGesture()
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
           print("User tapped on item \(indexPath.row)")
        
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
        self.collectionView?.reloadData()
        
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

}
