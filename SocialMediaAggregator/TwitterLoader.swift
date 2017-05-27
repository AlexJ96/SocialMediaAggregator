//
//  TwitterLoader.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 19/04/2017.
//  Copyright © 2017 Alex Johnson. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterLoader {
    
    var feeds: [Feed]? = [] {
        didSet {
        }
    }
    
    var tweets: [TWTRTweet] = [] {
        didSet {
        }
    }
    
    func loadTwitter() {
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
                        let feed = Feed.init(feedText: element)
                        self.feeds?.append(feed)
                    }
                    
                    let feeds = NSKeyedArchiver.archivedData(withRootObject: self.feeds as Any)
                    UserDefaults.standard.setValue(feeds, forKey: "feedArray")
                    UserDefaults.standard.synchronize()
                    print("ADDED TO USERDEFAULTS")
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
    }
}
