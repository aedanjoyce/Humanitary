//
//  StoryStartCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 11/5/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class StoryStartCell: UICollectionViewCell {
    var post: Post? {
        didSet{
            guard let postImageUrl = post?.imageUrl else {return}
            imageView.loadImage(urlString: postImageUrl)
            timeStamp.text = post?.creationDate.timeAgoDisplay()
            titleLabel.text = post?.title
            sublabel.text = post?.subTitle
            guard let username = post?.user.username else {return}
            authorLabel.text = "By " + username
        }
    }
    let imageView: CustomImageView = {
        let view = CustomImageView()
        view.backgroundColor = UIColor.customLightGrey
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let timeStamp: UILabel = {
        let label = UILabel()
        label.text = "3 hours ago"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 0
        //label.isScrollEnabled = false
        //label.backgroundColor = UIColor.blue
        return label
    }()
    let sublabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    let swipeLabel: UILabel = {
        let label = UILabel()
        label.text = "SWIPE TO BEGIN"
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        label.textColor = UIColor.white
        label.textAlignment = .left
        //label.isScrollEnabled = false
        //label.backgroundColor = UIColor.blue
        return label
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "By John Appleseed"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        //label.isScrollEnabled = false
        //label.backgroundColor = UIColor.blue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        backgroundColor = UIColor(red:0.11, green:0.11, blue:0.15, alpha:1.0)
        addSubview(swipeLabel)
        swipeLabel.anchor(top: nil, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: -12, paddingRight: 0, width: 0, height: 0)
        swipeLabel.shimmer()
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: frame.height / 2)
        addSubview(timeStamp)
        timeStamp.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 20)
        addSubview(titleLabel)
        titleLabel.anchor(top: timeStamp.bottomAnchor, left: timeStamp.leftAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(sublabel)
        sublabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(authorLabel)
        authorLabel.anchor(top: sublabel.bottomAnchor, left: sublabel.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
extension UILabel {
    func shimmer() {
        self.layer.opacity = 0.25
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(UInt8(UIViewAnimationOptions.repeat.rawValue) | UInt8(UIViewAnimationOptions.autoreverse.rawValue))), animations: {
            self.layer.opacity = 1.0
        }, completion: nil)
    }
}

