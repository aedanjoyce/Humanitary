//
//  UserResultsController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/17/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
class UserResultsController: UITableViewController {
    
    
    private let cellId = "cellId"
    var filteredUsers = [Userr]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    var messageController: MessagesController?
    var newMessageController: NewMessageController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredUser = filteredUsers[indexPath.row]
        dismiss(animated: true) {
            self.newMessageController?.callRootPushForUser(user: filteredUser)
        }
        
    }
}
class UserCell: UITableViewCell {
    var user: Userr? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            
            profileImageView.loadImage(urlString: profileImageUrl)
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
        label.text = "username"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

