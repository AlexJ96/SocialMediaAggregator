//
//  TodayViewController.swift
//  SocialMediaAggregator_Widget
//
//  Created by Alex Johnson on 23/11/2016.
//  Copyright © 2016 Alex Johnson. All rights reserved.
//

import UIKit
import NotificationCenter
import Fabric
import TwitterKit

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var feeds: [Feed]? = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let twitterLoader = TwitterLoader()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.with([Twitter.self])
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SocialCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        
        let sharedDefaults = UserDefaults(suiteName: "group.alexj.SocialMediaAggregator")
        
        NSKeyedUnarchiver.setClass(Feed.self, forClassName: "Feed")
        
        let feedsRetrieved = sharedDefaults?.object(forKey: "feedArray") as? NSData
        let feedsUnarchived = NSKeyedUnarchiver.unarchiveObject(with: feedsRetrieved as! Data) as? [Feed]
        self.feeds = feedsUnarchived
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = sectionInsets
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SocialCell.self, forCellWithReuseIdentifier: "cellId")
        view.addSubview(collectionView)
        
        
        let sharedDefaults = UserDefaults(suiteName: "group.alexj.SocialMediaAggregator")
        
        NSKeyedUnarchiver.setClass(Feed.self, forClassName: "Feed")
        
        let feedsRetrieved = sharedDefaults?.object(forKey: "feedArray") as? NSData
        let feedsUnarchived = NSKeyedUnarchiver.unarchiveObject(with: feedsRetrieved as! Data) as? [Feed]
        self.feeds = feedsUnarchived
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SocialCell
        
        cell.feed = feeds?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = feeds?[indexPath.item]
        let height = TWTRTweetTableViewCell.height(for: (tweet?.feedText)!, style: TWTRTweetViewStyle.compact, width: self.view.bounds.width, showingActions: true)
        return CGSize(width: view.bounds.width, height: height)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if (activeDisplayMode == NCWidgetDisplayMode.expanded) {
            var heightTotal: CGFloat = 0.0
            for index in 0...4 {
                let tweet = feeds?[index]
                let height = TWTRTweetTableViewCell.height(for: (tweet?.feedText)!, style: TWTRTweetViewStyle.compact, width: self.view.bounds.width, showingActions: true)
                heightTotal += height
            }
            self.preferredContentSize = CGSize(width: maxSize.width, height: heightTotal)
        } else {
            self.preferredContentSize = maxSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        let sharedDefaults = UserDefaults(suiteName: "group.alexj.SocialMediaAggregator")
        
        NSKeyedUnarchiver.setClass(Feed.self, forClassName: "Feed")
        
        let feedsRetrieved = sharedDefaults?.object(forKey: "feedArray") as? NSData
        let feedsUnarchived = NSKeyedUnarchiver.unarchiveObject(with: feedsRetrieved as! Data) as? [Feed]
        self.feeds = feedsUnarchived
        print(feedsUnarchived?[0].feedText ?? "DEFAULT")
        
        collectionView.reloadData()
        
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
