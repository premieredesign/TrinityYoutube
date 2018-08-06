//
//  FeedCell.swift
//  YouTube
//
//  Created by Clinton Johnson on 10/13/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let videoCellId = "videoCellId"
    var artistData: [artistData]?
    
    //MARK: - Create a collection View
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Override the setupViews()
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        addContraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
        
        fetchVideos()
        
    }
    var timer: Timer?
    func fetchVideos() {
        APIService.shared.fetchSongs(month: "July") { (fromAPI: API) in
            self.timer?.invalidate()
            self.artistData = fromAPI.songData![0].songs
            self.collectionView.reloadData()
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
        
       cell.video = artistData?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSize(width: frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        let videoCell = VideoCell()
        
        videoLauncher.showSongDetailsWindow()
        
        let songTitle = artistData![indexPath.row].SONG
        let songArtist = artistData![indexPath.row].ARTIST
        let songProfile = artistData![indexPath.row].PROFILE
        let songToPlay = artistData![indexPath.row].VIDEO
        
        videoLauncher.songCellData = artistData?[indexPath.row]
        videoLauncher.setupNowPlayingInfo(title: songTitle, artist: songArtist)
        videoLauncher.playSong(song: songToPlay)
    }
}
