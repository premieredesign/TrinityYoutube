//
//  CellConfiguration.swift
//  YouTube
//
//  Created by Clinton Johnson on 7/13/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
   
    func configure(data: DataType)
    
}

protocol ArrayConfigurableCell {
     associatedtype ArrayDataType
    
     func configureArrayData(data: [ArrayDataType])
    
}


protocol CellConfigurator {
    static var reuseId: String {get}
    func configure(cell: UIView)
}


class CollectionCellConfigurator<T: ConfigurableCell, U>: CellConfigurator where T.DataType == U, T: UICollectionViewCell {
    // Comes from Protocol CellConfigurator
    static var reuseId: String {return String(describing: T.self)}
    
    let item: U
    init(item: U) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! T).configure(data: item)
    }
}

class DataCellConfigurator<T: ArrayConfigurableCell, U>: CellConfigurator where T.ArrayDataType == U, T: UICollectionViewCell {
    static var reuseId: String {return String(describing: T.self)}
    
    let data: [U]
    init(data: [U]) {
        self.data = data
    }
    
    func configure(cell: UIView) {
        (cell as! T).configureArrayData(data: data)
    }
    
    
}
