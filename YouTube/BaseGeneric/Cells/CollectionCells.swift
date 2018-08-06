//
//  CollectionCells.swift
//  YouTube
//
//  Created by Clinton Johnson on 7/13/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit

//MARK: - FeedCell
class FeedBaseCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ConfigurableCell {
    var artistData: [artistData]?
    var video: artistData?
    var feedChildCell: FeedChildCell?
    let videoCellId = "videoCellId"
    
    //MARK: - Create a collection View
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Setting  settingsLauncher as a delegate
    lazy var videoPlayerController: VideoLauncher = {
        let launcher = VideoLauncher()
        launcher.feedBaseCell = self
        
        return launcher
    }()
    
    
    func configure(data message: String) {
        backgroundColor = .orange
        addSubview(collectionView)
        addContraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(FeedChildCell.self, forCellWithReuseIdentifier: "FeedChildCell")
        fetchVideos()
    }
    
    static func thisIsTheIndex(index: Int) {
        print("This is coming from the Parent", index)
    }
    
    //MARK: - Fetcher For API Data Videos
    var timer: Timer?
    func fetchVideos() {
        APIService.shared.fetchSongs(month: "August") { (fromAPI: API) in
            self.timer?.invalidate()
            self.artistData = fromAPI.songData![0].songs
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSize(width: frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedChildCell", for: indexPath) as! FeedChildCell
        
        cell.video = artistData?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("This is being selected from Child",indexPath.row)
        videoPlayerController.showSongDetailsWindow()
        let songTitle = artistData![indexPath.row].SONG
        let songArtist = artistData![indexPath.row].ARTIST
        let songProfile = artistData![indexPath.row].PROFILE
        let songToPlay = artistData![indexPath.row].VIDEO
        
        videoPlayerController.songCellData = artistData?[indexPath.row]
        videoPlayerController.setupNowPlayingInfo(title: songTitle, artist: songArtist)
        videoPlayerController.playSong(song: songToPlay)
    }
}
//MARK: - FeedChildCell
class FeedChildCell: BaseCell {
    
    var bullet: String = "\u{2022}"
    
    var video: artistData? {
        didSet {
            titleLabel.text = video?.ARTIST
            
            setupThumbnailImage()
            
            setupProfileImage()
            if let channelName = video?.ARTIST, let date = video?.DATE, let service = video?.SERVICE, let songName = video?.SONG {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let subtitleText = NSMutableAttributedString(string: "\"\(songName)\"", attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.rgb(23, 42, 66)])
                
                subtitleText.append(NSMutableAttributedString(string: " \(bullet) \(service) \(bullet) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
                
                subtitleText.append(NSMutableAttributedString(string: "\(date)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
                
                subtitleTextView.attributedText = subtitleText
            }
            
            //Measure Title Text
            if let title = video?.SONG {
                let size = CGSize(width: frame.width - 16 - 8 - 44 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimateRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimateRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    

    //MARK: - Grabs Thumbanil Images for Internet
    func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.PROFILE {
            thumbnailImageView.loadImagesFromBrowser(urlString: thumbnailImageUrl)
        }
    }
    
    //MARK: - Grabs Profile Images from Internet
    func setupProfileImage() {
        if let profileImageUrl = video?.PROFILE {
            userProfileImageView.loadImagesFromBrowser(urlString: profileImageUrl) // See Helper - Extensions
        }
    }
    
    
    
    
    //MARK: - Creating Thumbnails
    let thumbnailImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "sermon")
        image.layer.shadowOpacity = 0.4
        image.layer.shadowRadius = 4
        image.layer.shadowOffset = CGSize(width: 5, height: 10)
        
        image.clipsToBounds = false
        
        return image
    }()
    
    //MARK: - User Profile
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "Pastor")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 22
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        
        return image
        
    }()
    
    
    //MARK: - Separator Line(ligther)
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pastor R D. Wade - 'He Loves Me' "
        
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let bullet: String = "\u{2022}"
        text.text = "Trinity Christian CHurch \(bullet) 20330 Superior Rd, Taylor MI"
        text.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        text.textColor = .lightGray
        
        return text
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        print("this is video", video)
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        
        //Horizontal Constraints
        addContraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addContraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        //Vertical Constraints
        addContraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        addContraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        
        
        //Top Constraints : ThumbnailImageView
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 2))
        
        //Left Contstraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        //Right Constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        //Height Constraints
        titleLabelHeightConstraint = (NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44))
        addConstraint(titleLabelHeightConstraint!)
        
        
        //Top Constraints : SubtitleTextView
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0))
        
        //Left Contstraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 4))
        
        //Right Constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        //Height Constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
    
    }
}















//MARK: - TrendingCell
class TrendingBaseCell: UICollectionViewCell, ConfigurableCell {
    var artistData: [artistData]?
    
    func configure(data message: String) {
        backgroundColor = .blue
    }
}

//MARK: - SubscriptionCell
class SubscriptionBaseCell: UICollectionViewCell, ConfigurableCell {
    var artistData: [artistData]?
    
    func configure(data message: String) {
        backgroundColor = .yellow
    }
}

//MARK: - AccountCell
class AccountBaseCell: UICollectionViewCell, ConfigurableCell {
    var artistData: [artistData]?
    
    func configure(data message: String) {
        backgroundColor = .red
    }
}
