//
//  SideWindowCell.swift
//  SocialMediaAggregator
//
//  Created by Alex Johnson on 11/04/2017.
//  Copyright © 2017 Alex Johnson. All rights reserved.
//

import UIKit

class SideWindowCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var colorId = 0
    
    var menuButton: MenuButton? {
        didSet {
            label.text = menuButton?.name
            iconImageView.image = UIImage(named: (menuButton?.imageName)!)
            iconImageView.tintColor = UIColor.white
            colorId = (menuButton?.id)!
            print("COLOR ID ",  colorId)
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
        //iconImageView.contentMode = .scaleAspectFit
        //iconImageView.contentMode = .scaleAspectFill
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
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(20)]-15-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : iconImageView, "v1" : label]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : label]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : iconImageView]))
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-59-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : seperatorView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : seperatorView]))
        
        addConstraints([NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
