//
//  VideoLauncher.swift
//  YouTube
//
//  Created by Clinton Johnson on 10/19/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer


//MARK: - Video Launcher Class
class VideoLauncher: NSObject {
    //MARK: @TODO Move these into properties
    var homeController: HomeController?
    var feedBaseCell: FeedBaseCell?
    let superWindow = UIApplication.shared.keyWindow
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    let songDetailsTopKeyWindow = UIView()
    let songDetailsBottomKeyWindow = UIView()
    var songCellData: artistData? {
        didSet {
            guard let url = songCellData?.PROFILE else {return}
            guard let title = songCellData?.ARTIST else {return}
            guard let songLabel = songCellData?.SONG else {return}
            guard let video = songCellData?.VIDEO else {return}
            guard let service = songCellData?.SERVICE else {return}
            guard let date = songCellData?.DATE else {return}
            
            artistSongDetailsDateLabel.text = date
            artistSongDetailsNameLabel.text = title
            artistSongDetailSongNameLabel.text = "\"\(songLabel)\""
            artistSongDetailsServiceNameLabel.text = service
            artistSongDetailsProfileImageView.loadImagesFromBrowser(urlString: url)
            imageView.loadImagesFromBrowser(urlString: url)
//            songString = video
        }
    }
    
    let imageView: CustomImageView = {
       let iv = CustomImageView()
        
        return iv
    }()
    
    func setupNowPlayingInfo(title: String?, artist: String?) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        
        guard let image =  imageView.image else {return}
        let artwork = MPMediaItemArtwork(boundsSize: (image.size)) { (_) -> UIImage in
            return image
        }
        
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    lazy var artistSongDetailsCancelButtonImageView: CustomButton = {
        let iv = CustomButton()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        iv.backgroundColor = .orange
        iv.clipsToBounds = true
        iv.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        iv.alpha = 0.3
        iv.layer.zPosition = 8
        
        return iv
    }()
    
    lazy var dissmissLabel: CustomButton = {
        let label = CustomButton(type: UIButton.ButtonType.system)
        label.setTitle("Dismiss", for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)

        
        return label
    }()
    
    @objc func handleDismiss() {
        print("Dissmissing")
        player.pause()
        playSong(song: nil)
        UIView.animate(withDuration: 0.5) {
            self.songDetailsTopKeyWindow.alpha = 0
            self.songDetailsTopKeyWindow.transform = .identity

            self.songDetailsBottomKeyWindow.alpha = 0
            self.songDetailsBottomKeyWindow.transform = .identity
        }
    }
    
    let artistSongDetailsNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.textColor = UIColor.rgb(23, 42, 66) // Trinity Blue
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let artistSongDetailSongNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let artistSongDetailsServiceNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.textColor = .darkGray
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    let artistSongDetailsDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        
        return label
    }()
    
    
    //MARK: Artist Song Details
    let artistSongDetailsProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .orange
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 50 / 2
        iv.clipsToBounds = true
        
        return iv
    }()
    var panGesture: UIPanGestureRecognizer!
    
    //MARK: @TODO move this to properties
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = true
        
        return avPlayer
    }()
    
    func playSong(song: String?) {
        print("Playing song")
        guard let song = song else {return}
        guard let url = URL(string: song) else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    func showSongDetailsWindow() {
        if let window = UIApplication.shared.keyWindow {
            print("key window")
            window.addSubview(songDetailsTopKeyWindow)
            window.addSubview(songDetailsBottomKeyWindow)

            
//            let tap = UITapGestureRecognizer(target: self, action: #selector())
//            self.dissmissLabel.addGestureRecognizer(tap)
           
       
            //        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            //        self.songDetailsBottomKeyWindow.addGestureRecognizer(panGesture)
            
            // Set Key Window Frames
            songDetailsTopKeyWindow.frame = CGRect(x: (window.frame.origin.x), y: (window.frame.origin.y) - 300, width: (window.frame.width), height: (window.frame.width) / 1.5 + 50)
            
            songDetailsBottomKeyWindow.frame = CGRect(x: (window.frame.origin.x), y: (window.frame.origin.y) + 600, width: (window.frame.width), height: (window.frame.height) / 1.5)
            
            // Set Key Window Background Color
            songDetailsTopKeyWindow.backgroundColor = .black
            songDetailsTopKeyWindow.alpha = 1
            
            songDetailsBottomKeyWindow.backgroundColor = UIColor.rgb(255, 255, 255)
            songDetailsBottomKeyWindow.alpha = 1
            

            // Animate the screens in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {

                self.songDetailsTopKeyWindow.alpha = 0.8
                self.songDetailsTopKeyWindow.transform = CGAffineTransform(translationX: 0, y: +300)

                self.songDetailsBottomKeyWindow.alpha = 1
                self.songDetailsBottomKeyWindow.transform = CGAffineTransform(translationX: 0, y: -300)

//                self.setupCancelButtonInsideSongDetails()
//                self.setupDismiss()
    
                self.setupTopKeyWidow()
                self.setupBottonKeyWidow()
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    self.songDetailsTopKeyWindow.alpha = 1
                }, completion: { (true) in
                  

                })
            }
        }
    }
    
    func setupCancelButtonInsideSongDetails() {
        songDetailsBottomKeyWindow.addSubview(artistSongDetailsCancelButtonImageView)
        
        artistSongDetailsCancelButtonImageView.anchor(top: songDetailsBottomKeyWindow.topAnchor, trailing: songDetailsBottomKeyWindow.trailingAnchor, bottom: nil, leading: nil, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 50, height: 50)
    }
    
    func setupDismiss() {

        
    }
    
    func setupTopKeyWidow() {
        songDetailsTopKeyWindow.addSubview(controlContainerView)
        controlContainerView.alpha = 0
        controlContainerView.layer.opacity = 0
        controlContainerView.frame = CGRect(x: 0, y: 0, width: songDetailsTopKeyWindow.frame.width, height: songDetailsTopKeyWindow.frame.height)
        controlContainerView.clipsToBounds = true
        controlContainerView.translatesAutoresizingMaskIntoConstraints = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.opacity = 1
        playerLayer.backgroundColor = UIColor.clear.cgColor
        controlContainerView.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: controlContainerView.frame.width, height: 300)
        
        UIView.animate(withDuration: 1) {
            self.controlContainerView.alpha = 1
            self.controlContainerView.layer.opacity = 1
            playerLayer.opacity = 1
        }
    }
    
    func setupBottonKeyWidow() {
        songDetailsBottomKeyWindow.addSubview(artistSongDetailsDateLabel)
        songDetailsBottomKeyWindow.addSubview(artistSongDetailsNameLabel)
        songDetailsBottomKeyWindow.addSubview(artistSongDetailSongNameLabel)
        songDetailsBottomKeyWindow.addSubview(artistSongDetailsServiceNameLabel)
        songDetailsBottomKeyWindow.addSubview(artistSongDetailsProfileImageView)
        songDetailsBottomKeyWindow.addSubview(dissmissLabel)
        
        NSLayoutConstraint.activate([
            dissmissLabel.centerXAnchor.constraint(equalTo: songDetailsBottomKeyWindow.centerXAnchor),
            dissmissLabel.bottomAnchor.constraint(equalTo: songDetailsBottomKeyWindow.bottomAnchor, constant: -70),
            dissmissLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
       
        
        
        artistSongDetailsProfileImageView.anchor(top: songDetailsBottomKeyWindow.topAnchor, trailing: nil, bottom: nil, leading: nil, paddingTop: 10, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 50, height: 50)
        NSLayoutConstraint.activate([
            artistSongDetailsProfileImageView.centerXAnchor.constraint(equalTo: songDetailsBottomKeyWindow.centerXAnchor)
            ])

        
        artistSongDetailsNameLabel.anchor(top: artistSongDetailsProfileImageView.bottomAnchor, trailing: nil, bottom: nil, leading: nil, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 150, height: 20)
        NSLayoutConstraint.activate([
            artistSongDetailsNameLabel.centerXAnchor.constraint(equalTo: songDetailsBottomKeyWindow.centerXAnchor)
            ])
        
        artistSongDetailSongNameLabel.anchor(top: artistSongDetailsNameLabel.bottomAnchor, trailing: nil, bottom: nil, leading: nil, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 150, height: 20)
        NSLayoutConstraint.activate([
            artistSongDetailSongNameLabel.centerXAnchor.constraint(equalTo: songDetailsBottomKeyWindow.centerXAnchor)
            ])
        
        artistSongDetailsDateLabel.anchor(top: songDetailsBottomKeyWindow.topAnchor, trailing: artistSongDetailsProfileImageView.leadingAnchor, bottom: nil, leading: nil, paddingTop: 10, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 100, height: 20)
        
        artistSongDetailsServiceNameLabel.anchor(top: songDetailsBottomKeyWindow.topAnchor, trailing: nil, bottom: nil, leading: artistSongDetailsProfileImageView.trailingAnchor, paddingTop: 10, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 100, height: 20)
        
        
        UIView.animate(withDuration: 2, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
        }) { (true) in
            UIView.animate(withDuration: 4, animations: {
//                self.homeController?.videoPlayer.alpha = 1
            })
        }
    }
    
//    //MARK:- Move Pan Up
//    func PanUp(_ gesture: UIPanGestureRecognizer) {
//        func changeAlphaValues(to: Bool) {
//            if to {
//                self.miniViewPlayer.alpha = 1
//                self.maximizedStackView.alpha = 0
//            }
//            else {
//                self.miniViewPlayer.alpha = 0
//                self.maximizedStackView.alpha = 1
//            }
//        }
//
//        if gesture.state == .began {
//            print("beginning")
//        }
//        else if gesture.state == .changed {
//            let translation = gesture.translation(in: self.superview)
//            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
//
//            self.miniViewPlayer.alpha = 1 + translation.y / 200
//            self.maximizedStackView.alpha = -translation.y / 200
//        }
//        else if gesture.state == .ended {
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                let translation = gesture.translation(in: self.superview)
//                let velocity = gesture.velocity(in: self.superview)
//                self.transform = .identity
//
//                if translation.y < -200 || velocity.y < -500 {
//                    UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
//                }
//                else {
//                    changeAlphaValues(to: true)
//                }
//            })
//        }
//    }
    //MARK:- Pan Down
    func PanDown(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            print("beginning")
        }
        else if gesture.state == .changed {
            let translation = gesture.translation(in: self.superWindow)
            songDetailsBottomKeyWindow.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        else if gesture.state == .ended {
            let translation = gesture.translation(in: self.superWindow)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.songDetailsBottomKeyWindow.transform = .identity
                
                if translation.y > 50 {
//                    UIApplication.mainTabBarController()?.minimizePlayerDetails()
                }
            })
        }
        
//        if gesture.state == .began {
//            print("beginning")
//        }
//        else if gesture.state == .changed {
//            print("Changing")
//            let translation = gesture.translation(in: self.superWindow)
//            songDetailsBottomKeyWindow.transform = CGAffineTransform(translationX: 0, y: translation.y - 200)
//        }
//        else if gesture.state == .ended {
//            let translation = gesture.translation(in: self.superWindow)
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                self.songDetailsBottomKeyWindow.transform = .identity
//
//                if translation.y > 50 {
////                    UIApplication.mainTabBarController()?.minimizePlayerDetails()
//                }
//            })
//        }
    }
    
    func radius(_ radius: CGFloat) -> CGFloat {
        return (radius * .pi / 180)
    }
    
    //MARK: Handle Pan()
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
//        PanOut(gesture)
        PanDown(gesture)
    }
    
    func PanOut(_ gesture: UIPanGestureRecognizer) {
        func changeAlphaValues(to: Bool) {
            if to {
//                self.arrowBackgroundDetails.backgroundColor = UIColor(white: 0, alpha: 0.5)
            }
            else {
                
            }
        }
        
        if gesture.state == .began {
            print("beginning")
        }
        else if gesture.state == .changed {
            let translation = gesture.translation(in: self.superWindow)
            self.songDetailsBottomKeyWindow.transform = CGAffineTransform(translationX: translation.x, y: 0)
        }
        else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let translation = gesture.translation(in: self.superWindow)
                let velocity = gesture.velocity(in: self.superWindow)
                self.songDetailsBottomKeyWindow.transform = .identity
               
                if translation.x < -150 || velocity.x < -300 {
//                    self.expandSlideOutMenu()
                }
                else {
                    changeAlphaValues(to: true)
                }
            })
        }
    }
}

