//
//  MessagesCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/12/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
class MessagesCell: UITableViewCell {
    var message: Message? {
        didSet {
            let chatPartnerId: String?
            if message?.fromId == Auth.auth().currentUser?.uid {
                chatPartnerId = message?.toId
            } else {
                chatPartnerId = message?.fromId
            }
            if let id = chatPartnerId {
                Database.fetchUserWithUID(uid: id) { (user) in
                    self.usernameLabel.text = user.username
                    self.profileImageView.loadImage(urlString: user.profileImageUrl)
                }
            }
        }
    }
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Appleseed"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        return label
    }()
    let messagePreview: UILabel = {
        let label = UILabel()
        label.text = "This is an example of what a message what look like and other information such as people,places, things etc This is an example of what a message what look like and other information such as people,places, things etc"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = UIColor.lightGray
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60 / 2
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(messagePreview)
        messagePreview.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
