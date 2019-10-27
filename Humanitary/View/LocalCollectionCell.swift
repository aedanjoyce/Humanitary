//
//  LocalCollectionCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 12/16/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Hero
class LocalCollectionCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            nameLabel.text = post?.user.username
            guard let profileImageUrl = post?.user.profileImageUrl else {return}
            guard let postImageUrl = post?.imageUrl else {return}
            //imageView.loadImage(urlString: postImageUrl)
            imageView.layer.cornerRadius = 10
            UIViewPropertyAnimator(duration: 0.075, curve: .easeInOut, animations: {
                self.userImage.loadImage(urlString: profileImageUrl)
                self.imageView.loadImage(urlString: postImageUrl)
            }).startAnimation()
            titleLabel.text = post?.title
            sublabel.text = post?.subTitle
            timeStamp.text = post?.creationDate.timeAgoDisplay()
        }
    }
    let userDataContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let descriptionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let userImage: CustomImageView = {
        let image = CustomImageView()
        // image.image = #imageLiteral(resourceName: "profileReplace")
        image.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Aedan Joyce"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Problems in Puerto Rico"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    let sublabel: UILabel = {
        let label = UILabel()
        label.text = "This is a sample of a tagline that would be shown amongst other little interesting details that could be shown"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        //label.numberOfLines = 3
        return label
    }()
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    let timeStamp: UILabel = {
        let label = UILabel()
        label.text = "5 mins ago"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textColor = UIColor.lightGray
        return label
    }()
    let imageView: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    let likeButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        return button
    }()
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Chat"), for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupViews()
        self.isHeroEnabled = true
    }
    func setupViews() {
        addSubview(imageView)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 125, height: 125)
        
        addSubview(descriptionContainer)
        descriptionContainer.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: imageView.leftAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.height - 50)
        descriptionContainer.addSubview(timeStamp)
        timeStamp.anchor(top: descriptionContainer.topAnchor, left: descriptionContainer.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        descriptionContainer.addSubview(titleLabel)
        titleLabel.anchor(top: timeStamp.bottomAnchor, left: descriptionContainer.leftAnchor, bottom: nil, right: imageView.leftAnchor, centerX: nil, centerY: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        descriptionContainer.addSubview(sublabel)
        sublabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: imageView.leftAnchor, centerX: nil, centerY: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(userDataContainer)
        userDataContainer.anchor(top: descriptionContainer.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: imageView.leftAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        userDataContainer.addSubview(userImage)
        userImage.anchor(top: nil, left: userDataContainer.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: userDataContainer.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        userImage.layer.cornerRadius = 35 / 2
        userDataContainer.addSubview(nameLabel)
        nameLabel.anchor(top: nil, left: userImage.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: userDataContainer.centerYAnchor, paddingTop: 6, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: userDataContainer.frame.width, height: 0)
        imageView.layer.cornerRadius = 5
//        userDataContainer.addSubview(likeButton)
//        likeButton.anchor(top: nil, left: nameLabel.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: userDataContainer.centerYAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 50, height: 20)
//        userDataContainer.addSubview(commentButton)
//        commentButton.anchor(top: nil, left: likeButton.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: userDataContainer.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 20)
        addSubview(seperator)
        seperator.anchor(top: nil, left: descriptionContainer.leftAnchor, bottom: bottomAnchor, right: imageView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        seperator.layer.opacity = 0.25
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
