//
//  SocialCell.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 07/02/2017.
//  Copyright © 2017 Alex Johnson. All rights reserved.
//

import Foundation
import TwitterKit

class SocialCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var thumbnailLink = ""
    
    var feed: Feed? {
        didSet {
            //timeDateLabel.text = feed?.timeString
            //usernameLabel.text = feed?.username
            //contentLabel. = feed?.feedText
            contentLabel.configure(with: feed?.feedText)
            contentLabel.showActionButtons = true
            //contentLabel.showBorder = false
            //thumbnailLink = (feed?.userThumbnail)!
            //setUserThumbnail()
        }
    }
    
    func setUserThumbnail() {
        let url = URL(string: (thumbnailLink))
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error ?? "ERROR")
                return
            }
            self.socialUserThumbnail.image = UIImage(data: data!)
        }.resume()
    }
    
    let socialThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "twtr-icn-logo")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let socialUserThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let timeDateLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "15m"
        textLabel.font = UIFont(name: textLabel.font.fontName, size: 12)
        textLabel.textColor = UIColor.lightGray
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "Username"
        usernameLabel.font = UIFont(name: usernameLabel.font.fontName, size: 14)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        return usernameLabel
    }()
    
    let contentLabel: TWTRTweetView = {
        let contentLabel = TWTRTweetView.init()
        //let contentLabel = TWTRTweetView()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        return contentLabel
    }()

    
    func setupViews() {
        //backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        //addSubview(socialThumbnail)
        //addSubview(socialUserThumbnail)
        //addSubview(timeDateLabel)
        //addSubview(usernameLabel)
        addSubview(contentLabel)
    
        
        //Time/date label
        /*addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(15)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : timeDateLabel]))
        
        //SocialMedia Thumbnail + time/date
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(16)]-260-[v1]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : socialThumbnail, "v1" : timeDateLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(13)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : socialThumbnail]))
        
        //UserThumbnail + username label
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-35-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : socialUserThumbnail]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(40)]-50-[v1]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : socialUserThumbnail, "v1" : usernameLabel]))
        
        //Username label
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-35-[v0(15)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : usernameLabel]))
        */
        //Content label
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : contentLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : contentLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
