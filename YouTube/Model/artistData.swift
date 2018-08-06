//
//  Video.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/24/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

class artistData: NSObject {
    
    var title: String?
    var number_of_views: NSNumber?
    var thumbnail_image_name: String?
    var channel: Channel?
    var duration: NSNumber?
    
//    var uploadDate: NSData?
    override func setValue(_ value: Any?, forKey key: String) {
        
        let selector = NSSelectorFromString("setTitle:")
        let responds = self.responds(to: selector)

        if key == "channel" {
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String: AnyObject])
        } else {
//            super.setValue(value, forKey: key)
        }
    }

    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    



    class Channel: NSObject {
        var name: String?
        var profile_image_name: String?
    }
}
