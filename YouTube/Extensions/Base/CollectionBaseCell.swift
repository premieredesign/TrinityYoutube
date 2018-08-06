//
//  CollectionBaseCell.swift
//  TrinityWorship
//
//  Created by Clinton Johnson on 5/12/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    public func OO() {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        OO()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
