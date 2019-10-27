//
//  UserProfileHeader.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/18/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
class UserProfileHeader: UICollectionViewCell {
    var profileView: ProfileViewController?
    var isCalled = false
    var delegate: ProfileDelegate?
    var user: Userr? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            guard let userId = user?.uid else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
            if isCalled == false {
            setCounts()
            isCalled = true
            }
            guard let following = self.user?.following else {return}
            guard let followers = self.user?.followers else {return}
            let attributedText = NSMutableAttributedString(string: "\(followers) ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
            
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]))
            
            self.followersLabel.attributedText = attributedText
            let at = NSMutableAttributedString(string: "\(following) ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
            
            at.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]))
            self.followingLabel.attributedText = at

        }
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            self.editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            self.editProfileFollowButton.layer.borderWidth = 1
            self.editProfileFollowButton.addTarget(self, action: #selector(handleEditProfileView), for: .touchUpInside)
            self.editProfileFollowButton.layer.cornerRadius = 3
            self.settingsStyle()
        } else if currentLoggedInUserId != userId {
            
            // check if following
            DispatchQueue.global(qos: .background).async {
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async {
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    self.editProfileFollowButton.layer.borderWidth = 1
                    self.editProfileFollowButton.layer.borderColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0).cgColor
                    self.editProfileFollowButton.backgroundColor = .white
                    self.editProfileFollowButton.setTitleColor(UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0), for: .normal)
                    self.editProfileFollowButton.removeShadow()
                    self.messagesStyle()
                } else {
                    self.setupFollowStyle()
                }
                }
            }, withCancel: { (err) in
                print("Failed to check if following:", err)
            })
            }
        }
        
    }
    @objc func handleEditProfileView() {
        delegate?.pushToEditProfile()
    }
    
    @objc func handleEditProfileOrFollow() {
        print("Execute edit profile / follow / unfollow logic...")
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        if editProfileFollowButton.titleLabel?.text == "Unfollow" && currentLoggedInUserId != userId{
            
            //unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                
                print("Successfully unfollowed user:", self.user?.username ?? "")
                Database.database().reference().child("followers").child(userId).child(currentLoggedInUserId).removeValue(completionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to unfollow user:", err)
                        return
                    }
                })
            
                    self.setupFollowStyle()
                
                
                
            })
            
        } else if editProfileFollowButton.titleLabel?.text == "Follow" && currentLoggedInUserId != userId {
            //follow
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let followersRef = Database.database().reference().child("followers").child(userId)
            let values = [userId: 1]
            let followerValues = [currentLoggedInUserId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
                
                print("Successfully followed user: ", self.user?.username ?? "")
              
                        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                        self.editProfileFollowButton.backgroundColor = .white
                        self.editProfileFollowButton.layer.borderColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0).cgColor
                        self.editProfileFollowButton.layer.borderWidth = 1
                        self.editProfileFollowButton.setTitleColor(UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0), for: .normal)
                        self.editProfileFollowButton.removeShadow()
                
            }
            DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
                followersRef.updateChildValues(followerValues)
            }
        }
    }
    var finalString = ""
    func setCounts(){
        
        guard let userId = self.user?.uid else { return }
        Database.database().reference().child("following").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            self.user?.following = Int(snapshot.childrenCount)
            print(Int(snapshot.childrenCount))
        })
        Database.database().reference().child("followers").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            self.user?.followers = Int(snapshot.childrenCount)
        })
        
    }
    func settingsStyle() {
        settingsMessageButton.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal), for: .normal)
        settingsMessageButton.addTarget(self, action: #selector(pushSettings), for: .touchUpInside)
    }
    func messagesStyle() {
        settingsMessageButton.setImage(#imageLiteral(resourceName: "Message").withRenderingMode(.alwaysOriginal), for: .normal)
        settingsMessageButton.addTarget(self, action: #selector(pushMessages), for: .touchUpInside)
    }
    @objc func pushSettings() {
        print("settings pushed")
        delegate?.pushToSettings()
    }
    @objc func pushMessages() {
        print("messages pushed")
    }

    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.editProfileFollowButton.addBlueShadow()
        self.messagesStyle()
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        return label
    }()
    let seperatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.opacity = 0.25
        return view
    }()
    let followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followingButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("0 Followers", for: .normal)
        return button
    }()
    let followerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("0 Followers", for: .normal)
        return button
    }()
    
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderColor = UIColor.lightGray.cgColor
       // button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    lazy var settingsMessageButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    lazy var shareButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Share").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupUserStatsView()
       
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        setupUserStatsView()

        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: followersLabel.bottomAnchor, left: followersLabel.leftAnchor, bottom: profileImageView.bottomAnchor, right: followersLabel.rightAnchor, centerX: nil, centerY: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 1)
        
        addSubview(settingsMessageButton)
        settingsMessageButton.anchor(top: editProfileFollowButton.topAnchor, left: followingLabel.leftAnchor, bottom: editProfileFollowButton.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: followingLabel.frame.height - editProfileFollowButton.frame.height, height: 0)
        addSubview(shareButton)
        shareButton.anchor(top: editProfileFollowButton.topAnchor, left: settingsMessageButton.rightAnchor, bottom: editProfileFollowButton.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: followingLabel.frame.height - editProfileFollowButton.frame.height, height: 0)
        shareButton.addTarget(self, action: #selector(shareFunction), for: .touchUpInside)
    }
    @objc func shareFunction() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        guard let username = user?.username else {return}
            var controllerText = ""
            let url = "https://itunes.apple.com/us/app/humanitary/id1301717511?ls=1&mt=8"
            if currentLoggedInUserId == userId {
                controllerText = "Follow me on Humanitary! \(url)"
            } else {
                controllerText = "Follow \(username) on Humanitary! \(url)"
            }
            delegate?.pushToMessages(text: controllerText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUserStatsView() {
        //setFollowingCount()
        let stackView = UIStackView(arrangedSubviews: [followersLabel, followingLabel])
        
        stackView.distribution = .fillEqually
        
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 52)
    }
    
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 17, green: 154, blue: 237)
    }
    
}
