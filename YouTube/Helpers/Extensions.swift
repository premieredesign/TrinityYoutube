//
//  Extensions.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/23/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//


import UIKit

//MARK: - Extension UIColor
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


//MARK: - Extension UIView
extension UIView {
    func addContraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

//MARK: - Remeber this, it will scale your image for you
extension UIImage {
    func scaleImage(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        let aspectWidth = newSize.width / size.width
        let aspectHeight = newSize.height / size.height
        
        let aspectRatio = max(aspectWidth, aspectHeight)
        scaledImageRect.size.width = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageURLString: String?
    
    func loadImagesFromBrowser(urlString: String) {
        
        imageURLString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as! AnyObject) {
            self.image = imageFromCache as! UIImage
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, res, error) in
            if error != nil {
                print(error)
                return
            }
            
            // Makes it load faster by telling it to get back to Main UI
            DispatchQueue.main.async {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageURLString == urlString {
                    self.image = UIImage(data: data!)
                    self.image?.scaleImage(newSize: CGSize(width: 200, height: 200))
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        }.resume()
    }
}
