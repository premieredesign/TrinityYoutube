//
//  MenuBar.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/23/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

//MARK: - Super MenuBar
class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //MARK: - Collection View for MenuBar
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 22, green: 75, blue: 136)
        cv.dataSource = self
        cv.delegate = self 
        return cv
    }()
    
    var homeController: HomeController?
    var collectionVC: CollectionViewController?
    let CellId = "CellId"
    let imageNames = ["music_library", "trending", "subscriptions", "account"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: CellId)
        
        addSubview(collectionView)
        addContraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        
        setupHorizontalBar()

    }
    
    var greenBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let greenBar = UIView()
        greenBar.backgroundColor = UIColor.rgb(red: 158, green: 203, blue: 37)
        greenBar.translatesAutoresizingMaskIntoConstraints = false
        greenBar.layer.cornerRadius = 2
        addSubview(greenBar)
        
        
        //The proper way for laying out Views
        // Need x, y, width, height constraints
        greenBarLeftAnchorConstraint = greenBar.leftAnchor.constraint(equalTo: self.leftAnchor)
            greenBarLeftAnchorConstraint?.isActive = true // this is X
        greenBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true // this is Y
        greenBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        greenBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! MenuCell
        let menuBarIcons = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        
        cell.imageView.image = menuBarIcons
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionVC?.scrollToMenuIndex(menuIndex: indexPath.item)

//        homeController?.scrollToMenuIndex(menuIndex: indexPath.item) // This will get the index path to the item selected || take you to the item selected.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












