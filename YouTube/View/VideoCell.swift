//
//  VideoCell.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/22/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//


import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class VideoCell: BaseCell {
    
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
    
    //MARK: - Setup Views
    override func setupViews() {
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
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        
        //Left Contstraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 4))
        
        //Right Constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        //Height Constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}




