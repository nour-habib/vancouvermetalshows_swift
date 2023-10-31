//
//  ContainerViewController.swift
//  VancouverMetalShows_Swift
//
//  Created by Nour Habib on 2023-09-20.
//

import UIKit

protocol ContainerViewDelegateTB: AnyObject
{
    func updateTableView()
}

protocol ContainerViewDelegateCV: AnyObject
{
    func updateCollectionView()
}

class ContainerViewController: UIViewController
{
    
    weak var delegate_tb: ContainerViewDelegateTB?
    weak var delegate_cv: ContainerViewDelegateCV?
    
    let menuViewController = MenuViewController()
    let showsViewController = ShowsTableViewController()
    let favsViewController = FavouritesViewController()
    var naviController: UINavigationController?
    
    enum MenuState
    {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.menuViewController.delegate = self
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        self.menuViewController.didMove(toParent: self)
        
        self.showsViewController.delegate = self
        let naviController = UINavigationController(rootViewController: showsViewController)
        addChild(naviController)
        view.addSubview(naviController.view)
        naviController.didMove(toParent: self)
        self.naviController = naviController
        

    }
    

}


extension ContainerViewController: ShowsTableViewControllerDelegate
{
    func didTapMenuButton()
    {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?)
    {
        switch menuState
        {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut)
            {
                self.naviController?.view.frame.origin.x = self.showsViewController.view.frame.size.width-100
            }
        completion: {
           [weak self] done in if done {
               self?.menuState = .opened
               DispatchQueue.main.async {
                   completion?()
               }
            }
        }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut)
            {
                self.naviController?.view.frame.origin.x = 0
            }
        completion: {
           [weak self] done in if done {
               self?.menuState = .closed
            }
            }
        }
        
    }
    
    
}

extension ContainerViewController: MenuViewControllerDelegate
{
    func didSelect(menuItem: MenuViewController.MenuOptions)
    {
        toggleMenu(completion: nil)
        switch menuItem
        {
        case .shows:
            self.resetToShows()
        case .favs:
            self.addFavs()
        }
    }
    
    func addFavs()
    {
        print("addFavs()")
        let favsVC = favsViewController
        showsViewController.addChild(favsVC)
        showsViewController.view.addSubview(favsVC.view)
        favsVC.view.frame = view.frame
        favsVC.didMove(toParent: showsViewController)
        showsViewController.title = favsVC.title
        delegate_cv?.updateCollectionView()
        
    }
    
    func resetToShows()
    {
        print("resetToShows()")
        favsViewController.view.removeFromSuperview()
        favsViewController.didMove(toParent: nil)
        showsViewController.title = "Shows"
        delegate_tb?.updateTableView()
        
    }
    
}
