//
//  ViewController.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/22/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    //MARK: "let's"
    let titles = ["Praise Team Music", "Trending", "Subscription", "Account"]
    let homeCellId = "homeCellId"
    let feedCellId = "feedCellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"

  
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height)) // This creates a label a puts it on the left.
        titleLabel.text = "  Praise Team Music"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .lightGray
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
   
    }
    
   
    
    //MARK: - CollectionView Setup
    func setupCollectionView() {
        
        // Changes scroll direction
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.rgb(red: 127, green: 110, blue: 92)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        
        
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView?.isPagingEnabled = true // make page snap in place
    }
    
    //MARK: - Setup for Menu Bar
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addContraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    //MARK: - SetupNavBarButtons
    func setupNavBarButtons() {

        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let navMoreImage = UIImage(named: "navMore")?.withRenderingMode(.alwaysOriginal)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
       
        let moreButton = UIBarButtonItem(image: navMoreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
    }
    
    //MARK: - Setting  settingsLauncher as a delegate
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        
        return launcher
    }()
    
    //MARK: - Setting  settingsLauncher as a delegate
    lazy var videoLauncher: VideoLauncher = {
        let launcher = VideoLauncher()
        launcher.homeController = self
        
        return launcher
    }()
    
    //MARK: - Setting  searchLauncher as a delegate
    lazy var searchLauncher: SearchLauncher = {
        let launcher = SearchLauncher()
        launcher.homeController = self
        
        return launcher
    }()
    
    var feedCell: FeedCell?
    
    @objc func handleSearch() {
       searchLauncher.showSearch()
//        self.collectionView.isUserInteractionEnabled = false
//        searchLauncher.songDetailsTopKeyWindow.isUserInteractionEnabled = true
    }
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
 
    
    
    func showControllerForSetting(setting: Setting) {
        let dummyVC = UIViewController()
        dummyVC.navigationItem.title = setting.name.rawValue
        dummyVC.view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(dummyVC, animated: true)
    }
    
    
    //MARK: - Setting  MenuBar as a delegate
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    //MARK: - Scroll to Menu
    func scrollToMenuIndex(menuIndex: Int) {
        
        let indexPath = NSIndexPath(item: menuIndex, section: 0) // This takes a number and makes it into an Index Path that can determine where something is.
        
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
        setTitleForIndex(index: menuIndex)
    }
    

    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.greenBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4 // Means the Green bar will follow where you scroll
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        
        setTitleForIndex(index: Int(index))
    }
    
    //MARK: - Collection Views
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let identifier: String

        if indexPath.item == 1 {
            identifier = trendingCellId
        } else if indexPath.item == 2 {
            identifier = subscriptionCellId
        } else {
            identifier = feedCellId
        }
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }

}

