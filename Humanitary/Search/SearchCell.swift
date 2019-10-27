//
//  SearchCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 12/2/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class SearchCell: UICollectionViewCell {
    var post: LocationPost? {
        didSet{
            guard let location = post?.location else {return}
            titleLabel.text = location
        }
    }
    let numberLabel: UILabel = {
       let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.textColor = UIColor(red:0.40, green:0.43, blue:0.47, alpha:1.0)
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Yemen"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSeperator()
        addSubview(numberLabel)
        addSubview(titleLabel)
        numberLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 28, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.anchor(top: nil, left: numberLabel.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 36, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class PopularHeaderAlternate: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        return label
    }()
    let coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        addSubview(titleLabel)
        addSubview(coloredView)
        coloredView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 15)
        titleLabel.anchor(top: coloredView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 3, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSeperator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

