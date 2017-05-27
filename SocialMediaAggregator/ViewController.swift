//
//  ViewController.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 23/11/2016.
//  Copyright © 2016 Alex Johnson. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit
import FBSDKCoreKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public var userName = ""
    var dateFormatter = DateFormatter()
    
    var feeds: [Feed]? = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var tweets: [TWTRTweet] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTimeline()
        //testFacebook()
        
        collectionView?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        
        navigationItem.title = "SocialAggregator"
        navigationController?.navigationBar.isTranslucent = false
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showWindow))
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        collectionView?.register(SocialCell.self, forCellWithReuseIdentifier: "cellId")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), for: .valueChanged)
        refreshControl.backgroundColor = UIColor.clear
        //refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.darkGray
        collectionView?.refreshControl = refreshControl
    
        
        /**let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
        // Swift
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in*/
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                          parameters: ["include_email": "true", "skip_status": "true"],
                                                          error: nil)
                
                client.sendTwitterRequest(request) { response, data, connectionError in }
               //self.userName = (session?.userName)!
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        //self.view.addSubview(logInButton)
        
        
    }
    
    func testFacebook() {
        /*FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, feed, first_name, relationship_status"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let fbDetails = result as! NSDictionary
                print(fbDetails)
            }
        })*/
        FBSDKGraphRequest(graphPath: "me/posts", parameters: ["fields": ""]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil) {
                let fbDetails = result as! NSDictionary
                print(fbDetails)
            }
        })
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        showTimeline()
        collectionView?.reloadData()
        
        
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.string(from: now as Date)
        let attributedString = NSAttributedString(string: updateString, attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        collectionView?.refreshControl?.attributedTitle = attributedString
        
        refreshControl.endRefreshing()
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SocialCell
        
        cell.feed = feeds?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = feeds?[indexPath.item]
        let height = TWTRTweetTableViewCell.height(for: (tweet?.feedText)!, style: TWTRTweetViewStyle.compact, width: self.view.bounds.width, showingActions: true)
        return CGSize(width: view.bounds.width, height: height)
    }

    let menuController = MenuController()
    
    func showWindow() {
        menuController.showWindow()
    }
    
    func showTimeline() {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            let params = ["count": ""]
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(String(describing: connectionError))")
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
                    
                    
                    self.tweets = TWTRTweet.tweets(withJSONArray: json) as! [TWTRTweet]
                    
                    for (index, element) in self.tweets.enumerated() {
                        //print("Item \(index): \(element)")
                        let feed = Feed.init(feedText: element)
                        self.feeds?.append(feed)
                    }
                
                    NSKeyedArchiver.setClassName("Feed", for: Feed.self)
                    let archievedFeeds = NSKeyedArchiver.archivedData(withRootObject: self.feeds)
                    
                    let sharedDefaults = UserDefaults(suiteName: "group.alexj.SocialMediaAggregator")
                    
                    sharedDefaults?.set(archievedFeeds, forKey: "feedArray")
                    sharedDefaults?.synchronize()
                    print("ADDED TO USERDEFAULTS")
                    /*let feedsRetrieved = UserDefaults.standard.data(forKey: "feedArray")! as NSData
                    let feedsUnarchived = NSKeyedUnarchiver.unarchiveObject(with: feedsRetrieved as Data) as? [Feed]
                    print(feedsUnarchived?[0].feedText ?? "NONE SET")*/
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
    }
    
    func dismissTimeline() {
        dismiss(animated: true, completion: nil)
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
    }
}

