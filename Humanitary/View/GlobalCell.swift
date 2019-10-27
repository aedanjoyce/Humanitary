//
//  GlobalCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 9/29/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Hero
class GlobalCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    lazy var collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      cv.backgroundColor = UIColor.white
      layout.scrollDirection = .vertical
      cv.dataSource = self
      cv.delegate = self
      return cv
    }()
    func fetchAllPosts() {
        //fetchPosts()
        fetchFollowingUserIds()
    }
    fileprivate func fetchFollowingUserIds() {
        if Auth.auth().currentUser != nil {
        Database.database().reference().child("posts").observe(.value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
            userIdsDictionary.forEach({ (arg) in
                let (key, value) = arg
                Database.fetchUsersWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (err) in
            print("Failed to fetch following user:", err)
        }
        }
    }
    var posts = [Post]()
    var newPosts = [Post]()
    // added weak
    weak var viewManager: ViewManager?
    private let cellId = "cellId"
    private let eventCellId = "eventCellId"
    private let popHeaderId = "popHeaderId"
    private let allHeader = "allHeader"
    private let footerId = "footerId"
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
       NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: HelpController.updateFeedNotificationName, object: nil)
        addContraintsWithFormat("H:|[v0]|", views: collectionView)
        addContraintsWithFormat("V:|[v0]|", views: collectionView)
        collectionView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0)
        collectionView.register(LocalCollectionCell.self, forCellWithReuseIdentifier: eventCellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.layer.zPosition = -1
        fetchFollowingUserIds()
        
    }
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellId, for: indexPath) as! LocalCollectionCell
            cell.post = posts[indexPath.item]
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
              return CGSize(width: frame.width, height: 150)
        }
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return posts.count
        }
         func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
         func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath)
                return footer
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 60)
    }

    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
        }
    
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//            return CGSize(width: frame.width, height: 25)
//        }
         func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            viewManager?.showStoryDetail(post: posts[indexPath.item])
        }
    fileprivate func fetchPostsWithUser(user: Userr) {
        print("called global")
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
               
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                })
        
        }) { (err) in
            print("Failed to fetch posts", err)
        }
    }

    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUsersWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
}
class PopularHeader: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.40, green:0.43, blue:0.47, alpha:1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EventCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hurricane Irma"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
        return label
    }()
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a tagline that describes the event"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        addSubview(subLabel)
        subLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        addSubview(seperator)
        seperator.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 2)
    }
}


