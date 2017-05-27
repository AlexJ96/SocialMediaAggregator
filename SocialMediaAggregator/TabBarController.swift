//
//  TabBarController.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 11/04/2017.
//  Copyright © 2017 Alex Johnson. All rights reserved.
//

import UIKit


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let topBar = UINavigationController(rootViewController: ViewController(collectionViewLayout: layout))
        topBar.title = "HOME"
        
        
        viewControllers = [topBar]
    }
}
