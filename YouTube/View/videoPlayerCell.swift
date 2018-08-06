//
//  TableViewCell.swift
//  TrinityWorship
//
//  Created by Clinton Johnson on 5/10/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class VideoPlayerCellView: BaseCell {
    static let shared = VideoPlayerCellView()
    var feedBaseCell: FeedBaseCell?
    var homeController: HomeController?
    var songUrl: String?
    
    var artistData: artistData? {
        didSet {
            guard let url = URL(string: artistData?.PROFILE ?? "") else {return}
            guard let name = artistData?.ARTIST else {return}
            guard let songName = artistData?.SONG else {return}
            guard let video = artistData?.VIDEO else {return}
            guard let service = artistData?.SERVICE else {return}
            guard let date = artistData?.DATE else {return}
            
            //            profileImageView.sd_setImage(with: url, completed: nil)
            //            profileNameLabel.text = name
            //            songNameLabel.text = "\"\(songName)\""
            songUrl = video
            //            dateLabel.text = date
            //            serviceLabel.text = service
        }
    }
    
    
    lazy var playButtonImageView: CustomButton = {
        let pbv = CustomButton()
        pbv.setImage(#imageLiteral(resourceName: "play-2"), for: .normal)
        pbv.clipsToBounds = true
        pbv.translatesAutoresizingMaskIntoConstraints = false
        pbv.layer.cornerRadius = 5
        pbv.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return pbv
    }()
    
    lazy var rewindButton: CustomButton = {
        let pbv = CustomButton()
        pbv.backgroundColor = .orange
        pbv.setImage(#imageLiteral(resourceName: "rewind15").withRenderingMode(.alwaysTemplate), for: .normal)
        pbv.tintColor = .white
        pbv.clipsToBounds = true
        pbv.translatesAutoresizingMaskIntoConstraints = false
        pbv.layer.cornerRadius = 5
        pbv.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        
        return pbv
    }()
    
    lazy var fastForwardButton: CustomButton = {
        let pbv = CustomButton()
        pbv.backgroundColor = .orange
        pbv.setImage(#imageLiteral(resourceName: "fastforward15").withRenderingMode(.alwaysTemplate), for: .normal)
        pbv.tintColor = .white
        pbv.clipsToBounds = true
        pbv.translatesAutoresizingMaskIntoConstraints = false
        pbv.layer.cornerRadius = 5
        pbv.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        
        return pbv
    }()
    
    
    func seekToCurrentTime(delta: Int64) {
        let fifteen = CMTime(value: delta, timescale: 1)
//        let seekTime = (homeController?.videoPlayer.player.currentTime())!.add(fifteen)
//        
//        homeController?.videoPlayer.player.seek(to: seekTime)
    }
    
    @objc func handleRewind() {
        seekToCurrentTime(delta: -15)
        print("Rewinding")
    }
    
    @objc func handleFastForward() {
        seekToCurrentTime(delta: 15)
    }
    
    //MARK:- Handles when user presses Play
    @objc func handlePlay() {
        
    }
    
    lazy var rewindBackgroundButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(handleRewind)))
        
        
        return view
    }()
    
    lazy var fastForwardBackgroundButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(handleFastForward)))
        
        return view
    }()
    
    func setup() {
        controlContainerView.addSubview(playButtonImageView)

        playButtonImageView.anchor(top: controlContainerView.topAnchor, trailing: nil, bottom: nil, leading: nil, paddingTop: 50, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 100, height: 100)
        NSLayoutConstraint.activate([
            playButtonImageView.centerXAnchor.constraint(equalTo: controlContainerView.centerXAnchor)
            ])
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
//        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    func playSong(song: String?) {
        print("Playing song")
        guard let song = song else {return}
        guard let url = URL(string: song) else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
    }
    
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    let redView = UIView()
    func setupPlayerView() {
        addSubview(controlContainerView)
        controlContainerView.frame = CGRect(x: 0, y: 0, width: frame.width + 55, height: 200)
        //        controlContainerView.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
        controlContainerView.clipsToBounds = true
        controlContainerView.translatesAutoresizingMaskIntoConstraints = true
        
        let playerLayer = AVPlayerLayer(player: player)
        controlContainerView.layer.addSublayer(playerLayer)
        playerLayer.frame = controlContainerView.frame
    }
    
    override func setupViews() {
        backgroundColor = UIColor.rgb(red: 23, green: 42, blue: 66)
        alpha = 0
        setup()
        setupPlayerView()
    }
}

