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

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = CustomColor.offWhite
        self.title = "Favs"
    }
    
    private func configureCollectionView()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 80, height: 80)
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "celly")
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
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
        let show = favShowsArray?[indexPath.row]
        
        
        
        return cell
        
    }
    
    //MARK: Get Data from CoreData
    
    func getAllItems() -> Void
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
