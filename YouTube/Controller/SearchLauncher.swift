//
//  SearchLauncher.swift
//  YouTube
//
//  Created by Clinton Johnson on 6/30/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer


//MARK: - Video Launcher Class
class SearchLauncher: NSObject {
    var homeController: HomeController?
    var collectionVC: CollectionViewController?
    
    //MARK: @TODO Move these into properties
    let superWindow = UIApplication.shared.keyWindow
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    let songDetailsTopKeyWindow = UIView()
    
    var blackView: UIView = {
        let bk = UIView()
        bk.translatesAutoresizingMaskIntoConstraints = false
        bk.backgroundColor = .clear
        return bk
    }()
    
    func showSearch() {
        superWindow?.addSubview(songDetailsTopKeyWindow);
        
        
        // Set Key Window Frames
        songDetailsTopKeyWindow.frame = CGRect(x: (superWindow?.frame.origin.x)!, y: (superWindow?.frame.origin.y)! - 600, width: (superWindow?.frame.width)!, height: (superWindow?.frame.height)!)
    
        
        // Set Key Window Background Color
        songDetailsTopKeyWindow.backgroundColor = UIColor(white: 0, alpha: 0.8)
        songDetailsTopKeyWindow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
//        songDetailsTopKeyWindow.addingBlurEffect(above: songDetailsTopKeyWindow, at: 0)
        
        songDetailsTopKeyWindow.alpha = 0
        
        
        // Animate the screens in
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.songDetailsTopKeyWindow.alpha = 0.8
            self.songDetailsTopKeyWindow.transform = CGAffineTransform(translationX: 0, y: +600)
        
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.songDetailsTopKeyWindow.alpha = 1
            }, completion: { (true) in
//                self.setupTopKeyWidow()
            })
        }
    }
    
    var timer: Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchSongs(month: searchText) { (fromAPI: API) in
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                DispatchQueue.main.async {
                    self.homeController?.feedCell?.artistData = fromAPI.songData![0].songs
                    self.homeController?.collectionView.reloadData()
                }
            })
        
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.songDetailsTopKeyWindow.transform = .identity
            self.songDetailsTopKeyWindow.alpha = 0
        }) { (true) in
            // Will implemtent if necessary
        }
    }
    
    func setupTopKeyWidow() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false // Optional
        searchController.searchBar.delegate = homeController
        
//        searchBar(searchController.searchBar, textDidChange: "April")
    
        superWindow?.addSubview(blackView)
        blackView.anchor(top: superWindow?.topAnchor, trailing: superWindow?.trailingAnchor, bottom: nil, leading: superWindow?.leadingAnchor, paddingTop: 250, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 200, height: 200)
        
        blackView.addSubview(searchController.searchBar)
        searchController.searchBar.anchor(top: blackView.topAnchor, trailing: blackView.trailingAnchor, bottom: nil, leading: blackView.leadingAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 50, height: 50)
        searchController.searchBar.barStyle = .blackTranslucent
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.barTintColor = .clear
    }

}


