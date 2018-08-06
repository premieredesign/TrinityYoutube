//
//  SettingCell.swift
//  YouTube
//
//  Created by Clinton Johnson on 10/2/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    var setting: Setting? {
        didSet {
           nameLabel.text = setting?.name.rawValue
            
            if let imageName = setting?.imageName {
                iconImageVIew.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageVIew.tintColor = .darkGray
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .lightGray
            iconImageVIew.tintColor = isHighlighted ? .white : .darkGray
        }
    }
    
    
    //MARK: - Labels for Settings Cells
    
    //MARK: - Name Label
    let nameLabel: UILabel = {
      let label = UILabel()
        label.text = "Setting"
        
        return label 
    }()
    
    
    //MARK: - Icon Image
    let iconImageVIew: UIImageView = {
        let icons = UIImageView()
        icons.image = #imageLiteral(resourceName: "settings")
        icons.contentMode = .scaleAspectFill
        
        return icons
    }()
    
    
    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addSubview(iconImageVIew)
        
        addContraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageVIew, nameLabel)
      
        addContraintsWithFormat(format: "V:|[v0]|", views: nameLabel)

        addContraintsWithFormat(format: "V:[v0(30)]", views: iconImageVIew)
        
        addConstraint(NSLayoutConstraint(item: iconImageVIew, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

    }
    
}
