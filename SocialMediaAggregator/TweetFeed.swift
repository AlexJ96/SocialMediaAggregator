//
//  TweetFeed.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 24/11/2016.
//  Copyright © 2016 Alex Johnson. All rights reserved.
//

import Foundation
import TwitterKit

class TweetFeed: UITableViewController, TWTRTweetViewDelegate {
    
    
    var refreshControl2 = UIRefreshControl()
    
    var tweetData = [[String:Any]]()
    var tweetTableReuseIdentifier = "TweetCell"
    var dateFormatter = DateFormatter()
    
    var tweetUser = Twitter.sharedInstance().sessionStore.session() as? TWTRSession

    
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @available(iOS 2.0, *)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath as IndexPath)
        let user = tweetData[indexPath.item]["user"] as? [String: Any]
        let text = tweetData[0]["text"] as? String
        let username = user?["name"] as? String
        cell.textLabel?.text = username
        return cell*/
        
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetTableReuseIdentifier, for: indexPath) as! TWTRTweetTableViewCell
        cell.tweetView.delegate = self
        cell.configure(with: tweet)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return TWTRTweetTableViewCell.height(for: tweet, style: TWTRTweetViewStyle.regular ,width: self.view.bounds.width, showingActions: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateStyle = DateFormatter.Style.short
        self.dateFormatter.timeStyle = DateFormatter.Style.long
        
        showTimeline()
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension // Explicitly set on iOS 8 if using automatic row height calculation
        tableView.allowsSelection = false
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetFeed.refresh(_:)), for: .valueChanged)
        //refreshControl.backgroundColor = UIColor.clear
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        tableView.refreshControl = refreshControl
        
        
        
        self.navigationController?.navigationBar.topItem?.title = tweetUser?.userName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton;
        super.viewWillAppear(animated);
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        showTimeline()
        tableView.reloadData()
        
        
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.string(from: now as Date)
        let attributedString = NSAttributedString(string: updateString, attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.refreshControl?.attributedTitle = attributedString
        
        
        refreshControl.endRefreshing()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
                    print("Error: \(connectionError)")
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
                
                    
                   // let tweetsArray = TWTRTweet.tweets(withJSONArray: json) as? [[String:Any]]
                    
                    
                    self.tweets = TWTRTweet.tweets(withJSONArray: json) as! [TWTRTweet]
                    
                    let user = json?[0]["user"] as? [String: Any]
                    let text = json?[0]["text"] as? String
                    let username = user?["name"] as? String
                    
                    print("USER: \(username)")
                    print("TWEET: \(text)")
                    
                    //print("json: \(json)")
                    
                    self.tweetData = json!
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
    }

    
    @available(iOS 2.0, *)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets.first != nil) {
            return tweets.count
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width-10, height: self.tableView.bounds.size.height))
            noDataLabel.text = "Cannot load " +  (tweetUser?.userName)! + "'s Timeline. Please pull down to refresh."
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.numberOfLines = 0
            noDataLabel.sizeToFit()
            noDataLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
            
        }
        return 0
    }

    
    
    
    
}
