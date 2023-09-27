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
    private var favShowsArray: [ShowItem]?
    private var showView: ShowView?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .black
        self.title = "Favs"
        
        getAllItems()
        
        print("favShowsArray size: ", favShowsArray?.count)
        configureCollectionView()
    }
    
    private func configureCollectionView()
    {
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 140, height: 170)
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .clear
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "celly")
        collectionView?.delegate = self
        collectionView?.dataSource = self
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
        showView?.layer.borderColor = CustomColor.darkRed.cgColor
        showView?.layer.borderWidth = 2
        showView?.backgroundColor = .clear
        
        showView?.dateLabel?.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 20)
        showView?.artistLabel?.frame = CGRect(x: 10, y: 20, width:100, height: 50)
        showView?.venueLabel?.frame = CGRect(x: 10, y: 60, width:150, height: 50)
        showView?.suppArtistLabel?.frame = CGRect(x: 10, y: 100, width: 100, height: 50)
        let show = favShowsArray?[indexPath.row]
        
        showView?.artistLabel?.text = show?.artist
        showView?.dateLabel?.text = show?.date
        showView?.venueLabel?.text = show?.venue
        showView?.suppArtistLabel?.text = show?.supporting_artists

        cell.addSubview(showView ?? UIView())
        initLongPressGesture()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
           print("User tapped on item \(indexPath.row)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
             return 10;
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 10;
        }
    
    
    //MARK: Long Press Gesture
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
        
        CoreData_.deleteItem(show: self.favShowsArray?[indexPath?.row ?? 0] ?? ShowItem())
        print("Item deleted")
        self.favShowsArray?.remove(at: indexPath?.row ?? 0)
        print("favShowsArray count: ", favShowsArray?.count)
        self.collectionView?.reloadData()
        
        
    }
    
    //MARK: Get Favs from CoreData
    
    private func getAllItems() -> Void
        {
            do
            {
                self.favShowsArray = try context.fetch(ShowItem.fetchRequest())
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


}
