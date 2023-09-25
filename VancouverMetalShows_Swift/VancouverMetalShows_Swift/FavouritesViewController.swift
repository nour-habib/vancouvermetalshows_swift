//
//  FavouritesViewController.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-20.
//

import UIKit

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    private var collectionView: UICollectionView?
    private var favShowsArray: [ShowItem]?
    private var showView: ShowView?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = CustomColor.offWhite
        self.title = "Favs"
        
        getAllItems()
        
        print("favShowsArray size: ", favShowsArray?.count)
        configureCollectionView()
    }
    
    private func configureCollectionView()
    {
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 160, height: 160)
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "celly")
        collectionView?.backgroundColor = .black
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
        print("cell size: ", cell.frame)
        self.showView = ShowView(frame: cell.frame)
        showView?.dateLabel?.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 20)
        showView?.backgroundColor = .yellow
        let show = favShowsArray?[indexPath.row]
        
        showView?.artistLabel?.text = show?.artist
        showView?.dateLabel?.text = show?.date
        showView?.venueLabel?.text = show?.venue
        showView?.suppArtistLabel?.text = show?.supporting_artists

        cell.addSubview(showView ?? UIView())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
           print("User tapped on item \(indexPath.row)")
        
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
