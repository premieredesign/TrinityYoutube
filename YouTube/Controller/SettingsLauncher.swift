//
//  SettingsLauncher.swift
//  YouTube
//
//  Created by Clinton Johnson on 9/30/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Cancel = "Cancel"
    case Settings = "Settings"
    case TermsPrivacy = "Terms & Privacy Policy"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
    case SendFeedback = "Send Feedback"
}

//MARK: - Settings Launcher Main Class
class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var homeController: HomeController?
    var collectionVC: CollectionViewController?
    let blackView = UIView()
    let settingsLauncherCellId = "settingsCellId"
    let cellHeight: CGFloat = 50
    
    
    let settingsCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        
        return cv
    }()
    

    let settings: [Setting] = {
        let settingsSetting = Setting(name: .Settings, imageName: "settings")
        let cancelSetting = Setting(name: .Cancel, imageName: "cancel")
        
        return [
            settingsSetting,
            Setting(name: .TermsPrivacy, imageName: "privacy"),
            Setting(name: .SendFeedback, imageName: "feedback"),
            Setting(name: .Help, imageName: "help"),
            Setting(name: .SwitchAccount, imageName: "switch_account"),
            cancelSetting
        ]
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingsLauncherCellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

   
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.layer.cornerRadius = 5
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(settingsCollectionView)
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            settingsCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.settingsCollectionView.frame = CGRect(x: 0, y: y, width: self.settingsCollectionView.frame.width, height: self.settingsCollectionView.frame.height)
            }, completion: nil)
        }
    }
    
    
    
    
    @objc func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
          self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.settingsCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.settingsCollectionView.frame.width, height: self.settingsCollectionView.frame.height)
                }
            }) { (completed: Bool) in
                if setting.name != .Cancel {
                    self.homeController?.showControllerForSetting(setting: setting)
                }
            }
    }
    
    override init() {
        super.init()
        
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
        settingsCollectionView.register(SettingCell.self, forCellWithReuseIdentifier: settingsLauncherCellId)
    }
    

    
    
    
    
}
