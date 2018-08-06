//
//  BaseCell.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/24/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

//MARK: - Base Cell
class BaseCell: UICollectionViewCell {
    //MARK: - Setting up Cells using Base
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implement")
    }
}


