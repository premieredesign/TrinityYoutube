//
//  Controller.swift
//  TrinityWorship
//
//  Created by Clinton Johnson on 5/10/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit

extension UIViewController {
    public func CreateCustomCell(for tableView: UITableView, with indexPath: IndexPath, identifier: String) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        return cell
    }
}
