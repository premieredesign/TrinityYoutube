//
//  CollectionBase.swift
//  YouTube
//
//  Created by Clinton Johnson on 7/13/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    internal let collectionModel = CollectiomModel()
    
    let titles = ["Praise Team Music", "Trending", "Subscription", "Account"]
    
    //MARK: - Setting  MenuBar as a delegate
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.collectionVC = self
        return mb
    }()
    
    //MARK: - Setup for Menu Bar
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addContraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK: - Setting  searchLauncher as a delegate
    lazy var searchLauncher: SearchLauncher = {
        let launcher = SearchLauncher()
        launcher.collectionVC = self
        
        return launcher
    }()
    
    //MARK: - Setting  settingsLauncher as a delegate
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.collectionVC = self
        
        return launcher
    }()
    
    //MARK: - CollectionView Setup
    func setupCollectionView() {
        
        // Changes scroll direction
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.rgb(red: 127, green: 110, blue: 92)
        collectionView.register(FeedBaseCell.self, forCellWithReuseIdentifier: "FeedBaseCell")
        collectionView.register(TrendingBaseCell.self, forCellWithReuseIdentifier: "TrendingBaseCell")
        collectionView.register(SubscriptionBaseCell.self, forCellWithReuseIdentifier: "SubscriptionBaseCell")
        collectionView.register(AccountBaseCell.self, forCellWithReuseIdentifier: "AccountBaseCell")
        
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView?.isPagingEnabled = true // make page snap in place
    }
    
    //MARK: - SetupNavBarButtons
    func setupNavBarButtons() {
        
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let navMoreImage = UIImage(named: "navMore")?.withRenderingMode(.alwaysOriginal)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: navMoreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
    }
    
    @objc func handleSearch() {
        searchLauncher.showSearch()
        print("Search has been activated")
    }
    
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    
    //MARK: - Set title
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

    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        setupCollectionView()
        setupNavBarButtons()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height)) // This creates a label a puts it on the left.
        titleLabel.text = "  Praise Team Music"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .lightGray
        navigationItem.titleView = titleLabel
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return collectionModel.items.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let items = collectionModel.items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: items).reuseId, for: indexPath)
        print(type(of: items).reuseId)
        
        items.configure(cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = (collectionView.frame.width - 16 - 16) * 9 / 16
//        return CGSize(width: collectionView.frame.width, height: height + 16 + 88)
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        FeedBaseCell.thisIsTheIndex(index: indexPath.row)
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
