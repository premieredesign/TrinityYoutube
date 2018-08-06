//
//  Anchors.swift
//  TrinityWorship
//
//  Created by Clinton Johnson on 5/9/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//


import UIKit



//MARK:- UIColor
extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


//MARK:- Add Visual Constraints
extension UIView {
    func addVisualConstraints(format: String, views: UIView...) {
        var dictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            dictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: dictionary))
    }
    
    func addingBlurEffect(above uView: UIView, at: Int) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = uView.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        uView.insertSubview(blurEffectView, aboveSubview: uView)
//        uView.insertSubview(blurEffectView, belowSubview: uView)
    }
}


//MARK:- Custom Image View
let imgCache = NSCache<AnyObject, AnyObject>()

//class CustomImageView: UIImageView {
//
//    var imageUrlString: String?
//
//    func downloaderFrom(url: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
//        contentMode = mode
//
//        guard let urlString = URL(string: url) else {return}
//
//        imageUrlString = url
//
//        image = nil
//
//        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
//
//        URLSession.shared.dataTask(with: urlString) { (data, res, err) in
//            guard
//                let httpUrlRes = res as? HTTPURLResponse, httpUrlRes.statusCode == 200,
//                let mimeType = res?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, err == nil,
//                let image = UIImage(data: data)
//                else {return}
//            DispatchQueue.main.async {
//                let imageToCache = image
//
//                if self.imageUrlString == url {
//                    self.image = imageToCache
//                }
//
//                imageCache.setObject(imageToCache, forKey: url as AnyObject)
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        downloaderFrom(url: link, contentMode: mode)
//    }
//}


//MARK:- Custom Button
class CustomButton: UIButton {
    
    var imageUrlString: String?
    
    func downloaderFrom(url: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        guard let urlString = URL(string: url) else {return}
        imageUrlString = url
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let dataImage = imageFromCache
            self.setImage(dataImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        URLSession.shared.dataTask(with: urlString) { (data, res, error) in
            if error != nil {
                print(error)
                return
            }
            
            // Makes it load faster by telling it to get back to Main UI
            DispatchQueue.main.async {
                guard
                    let data = data,
                    let image = UIImage(data: data)
                    else {return}
                
                let imageToCache = image
                
                if self.imageUrlString == url {
                    let dataImage = imageToCache
                    self.setImage(dataImage.withRenderingMode(.alwaysOriginal), for: .normal)
                }
                imageCache.setObject(imageToCache, forKey: url as AnyObject)
            }
            }.resume()
    }
}

//MARK:- Load Images Using UrlString
extension UIImageView {
    func loadImagesUsingUrlString(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            
            guard let data = data else { return print("There was an Issue retriving image Data")}
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

//MARK:- Visual Format & Anchors
extension UIView {
    func visualFormat(format: String, views: UIView...) {
        var dictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "c\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            dictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: dictionary))
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let right = trailing {
            trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = leading {
            leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}




