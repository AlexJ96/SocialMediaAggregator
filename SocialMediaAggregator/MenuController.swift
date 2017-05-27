//
//  MenuController.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 11/04/2017.
//  Copyright © 2017 Alex Johnson. All rights reserved.
//

import UIKit

class MenuButton: NSObject {
    
    let name: String
    let imageName: String
    let id: Int
    
    init(name: String, imageName: String, id: Int) {
        self.name = name
        self.imageName = imageName
        self.id = id
    }
    
}


class UserProfile: NSObject {
    
    let username: String
    let profileImageUrl: String
    
    init(username: String, profileImageUrl: String) {
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
}

class MenuController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let sideWindow: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cv.backgroundColor = UIColor.black
        cv.isOpaque = false
        cv.backgroundColor = UIColor(red: 0/255, green: 65/255, blue: 90/255, alpha: 1)
        return cv
    }()
    
    let cellId = "cellId"
    let cellId2 = "cellId2"

    let menuButtons: [MenuButton] = {
        return[MenuButton(name: "Home", imageName: "realHome", id: 0), MenuButton(name: "Settings", imageName: "settings2", id: 1), MenuButton(name: "Home", imageName: "realHome", id: 0), MenuButton(name: "Settings", imageName: "settings2", id: 1), MenuButton(name: "Home", imageName: "realHome", id: 0)]
    }()
    
    let userProfile: [UserProfile] = {
        return[UserProfile(username: "UndercoverMelon", profileImageUrl: "")]
    }()
    
    func showWindow() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            
            let width: CGFloat = window.frame.width - 75
            
            window.addSubview(blackView)
            //blackView.frame = window.frame
            blackView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            blackView.alpha = 0
            
            window.addSubview(sideWindow)
            
            sideWindow.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.frame = CGRect(x: width, y: 0, width: 75, height: window.frame.height)
                self.sideWindow.frame = CGRect(x: 0, y: 0, width: width, height: self.sideWindow.frame.height)
                
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.2) {
                    self.blackView.alpha = 0.5
                }
            })
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.blackView.alpha = 0
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.5) {
                self.blackView.frame = CGRect(x: 0, y: 0, width: 0, height: self.sideWindow.frame.height)
                self.sideWindow.frame = CGRect(x: 0, y: 0, width: 0, height: self.sideWindow.frame.height)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 1) {
            return menuButtons.count
        }
        return userProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if (indexPath.section == 1) {
            let menuButton = menuButtons[indexPath.item]
            print(menuButton.id)
            if (menuButton.id == 0) {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
            }
            else {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            let menuButton = menuButtons[indexPath.item]
            if (menuButton.id == 0) {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(red: 20/255, green: 80/255, blue: 105/255, alpha: 1)
            }
            else {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(red: 0/255, green: 65/255, blue: 90/255, alpha: 1)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.section == 1) {
            let cell = sideWindow.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SideWindowCell
            let menuButton = menuButtons[indexPath.item]
            cell.menuButton = menuButton
            if (menuButton.id == 0) {
                cell.backgroundColor = UIColor(red: 20/255, green: 80/255, blue: 105/255, alpha: 1)
            }
            else {
                cell.backgroundColor = UIColor(red: 0/255, green: 65/255, blue: 90/255, alpha: 1)
            }
            return cell
        }
        
        let cell2 = sideWindow.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! SideWindowProfile
        
        let userProfile = self.userProfile[indexPath.item]
        cell2.userProfile = userProfile
        
        print(indexPath.section)
        return cell2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.section == 1) {
            return CGSize(width: sideWindow.frame.width, height: 60)
        }
        return CGSize(width: sideWindow.frame.width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init() {
        super.init()
        
        sideWindow.delegate = self
        sideWindow.dataSource = self
        sideWindow.register(SideWindowProfile.self, forCellWithReuseIdentifier: cellId2)
        sideWindow.register(SideWindowCell.self, forCellWithReuseIdentifier: cellId)
        sideWindow.contentInset = UIEdgeInsets(top: 60.0, left: 0, bottom: 0, right: 0)
        sideWindow.allowsMultipleSelection = false
        sideWindow.selectItem(at: IndexPath.init(item: 0, section: 0), animated: false, scrollPosition: [])
    }
}

