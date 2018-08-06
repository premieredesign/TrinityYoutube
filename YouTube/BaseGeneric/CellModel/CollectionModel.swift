//
//  CollectionModel.swift
//  YouTube
//
//  Created by Clinton Johnson on 7/13/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit

typealias FeedCellConfiguration = CollectionCellConfigurator<FeedBaseCell, String>
typealias TrendingCellConfiguration = CollectionCellConfigurator<TrendingBaseCell,String>
typealias SubscriptionCellConfiguration = CollectionCellConfigurator<SubscriptionBaseCell, String>
typealias AccountCellConfiguration = CollectionCellConfigurator<AccountBaseCell, String>

class CollectiomModel {
    let items: [CellConfigurator] = [FeedCellConfiguration.init(item: "Hello"),
                                     TrendingCellConfiguration.init(item: "GoodBye"),
                                     SubscriptionCellConfiguration.init(item: "Good Morning"),
                                     AccountCellConfiguration.init(item: "New")]
}

