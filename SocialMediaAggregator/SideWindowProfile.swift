//
//  SideWindowCell.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 11/04/2017.
//  Copyright © 2017 Alex Johnson. All rights reserved.
//

import UIKit

class SideWindowProfile: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var userProfile: UserProfile? {
        didSet {
            label.text = userProfile?.username
        }
    }
    
    let label: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImageView: UIImageView = {
        var iconImageView = UIImageView()
        iconImageView.image = UIImage(named: ("melon"))
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderColor = UIColor(red: 54/255, green: 38/255, blue: 38/255, alpha: 0.5).cgColor
        iconImageView.layer.borderWidth = 2
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    let seperatorView: UIView = {
       var seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(red: 54/255, green: 38/255, blue: 38/255, alpha: 0.2)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorView
    }()
    
    
    func setupViews() {
        addSubview(label)
        addSubview(iconImageView)
        addSubview(seperatorView)
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-70-[v0(100)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : iconImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(100)]-10-[v1]-15-[v2(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : iconImageView, "v1" : label, "v2" : seperatorView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : label]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : seperatorView]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : label]))
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
