//
//  TableBaseCell.swift
//  TrinityWorship
//
//  Created by Clinton Johnson on 5/12/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit

class TableBaseCell: UITableViewCell {
    
    func OO() {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        OO()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
