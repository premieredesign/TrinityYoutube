//
//  MenuCell.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/24/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

//MARK: - MenuCell
class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "music_library")
        iv.tintColor = .black
        
        
        return iv
    }()
    
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.rgb(153, 194, 85) : .black
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? .white : .black
        }
    }

    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addContraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addContraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

