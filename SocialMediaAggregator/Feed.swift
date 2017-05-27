//
//  Feed.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 09/02/2017.
//  Copyright © 2017 Alex Johnson. All rights reserved.
//

import Foundation
import TwitterKit

@objc(Feed)
class Feed: NSObject, NSCoding {
    
    var socialThumbnail: String?
    var timeString: String?
    var userThumbnail: String?
    var feedText: TWTRTweet?
    var username: String?
    
    init(feedText: TWTRTweet) {
        self.feedText = feedText
    }
    
    //MARK: NSCoding
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(feedText, forKey: "feedText")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.feedText = aDecoder.decodeObject(forKey: "feedText") as? TWTRTweet
    }
    
}
