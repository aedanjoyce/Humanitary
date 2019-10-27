//
//  LocalCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 9/29/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
class LocalCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,NVActivityIndicatorViewable  {
    var posts = [Post]()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        layout.scrollDirection = .vertical
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let cellId = "cellId"
    let noCellId = "noCellId"
    private let footerId = "footerId"
    // added weak
    weak var viewManager: ViewManager?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addContraintsWithFormat("H:|[v0]|", views: collectionView)
        addContraintsWithFormat("V:|[v0]|", views: collectionView)
        collectionView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0)
        collectionView.register(LocalCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(NoPostCell.self, forCellWithReuseIdentifier: noCellId)
        //fetchPosts()
        fetchAllPosts()
        let refreshControl = UIRefreshControl()
        refreshControl.layer.zPosition = -1
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
    }
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if posts.count == 0 {
            let noPostCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! NoPostCell
            noPostCell.setText(text: "You aren't following anyone yet.")
            noPostCell.setBackgroundColor(color: UIColor.white)
            return noPostCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LocalCollectionCell
        cell.post = posts[indexPath.item]
//        cell.imageView.layer.opacity = 0
//        UIView.animate(withDuration: 0.0075, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//            cell.imageView.layer.opacity = 1
//        }, completion: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if posts.count == 0 {
            return CGSize(width: frame.width, height: frame.height - 150)
        }
        return CGSize(width: frame.width, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts.count == 0 {
            return 1
        }
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if posts.count == 0 {
            return CGSize(width: frame.width, height: 0)
        }
        return CGSize(width: frame.width, height: 60)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewManager?.showStoryDetail(post: posts[indexPath.item])
    }
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }
    func fetchAllPosts() {
        //fetchPosts()
        print("called local")
        fetchFollowingUserIds()
    }
    func fetchPosts() {
        print("called local")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUsersWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    fileprivate func fetchPostsWithUser(user: Userr) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    
//                    if let value = snapshot.value as? Int, value == 1 {
//                        post.hasLiked = true
//
//                    } else {
//                        post.hasLiked = false
//                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                    
                }, withCancel: { (err) in
                    print(err)
                })
            })
        }) { (err) in
            print("Failed to fetch posts", err)
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWithOutsideTouch() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

var imageCache = [String: UIImage]()
class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
           
            }.resume()
       
        }

        
    }


