//
//  ProfileViewController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/13/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
protocol ProfileDelegate {
    func pushToEditProfile()
    func pushToMessages(text: String)
    func pushToChatController()
    func pushToSettings()
}
class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, MFMessageComposeViewControllerDelegate, ProfileDelegate {
    func pushToSettings() {
        let settings = SettingController(collectionViewLayout: UICollectionViewFlowLayout())
        settings.user = self.user
        navigationController?.pushViewController(settings, animated: true)
    }
    
    func pushToChatController() {
        let chat = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chat, animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var settingsHeader: SettingsHeader?
    func pushToEditProfile() {
        let editProfile = EditProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav = UINavigationController(rootViewController: editProfile)
        editProfile.user = self.user
        navigationController?.present(nav, animated: true, completion: nil)
    }
    func pushToMessages(text: String) {
        let controller = MFMessageComposeViewController()
        if (MFMessageComposeViewController.canSendText()) {
            controller.body = text
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    

    let cellId = "cellId"
    let noCellId = "noCellId"
    let localCellId = "localCellId"
    var user: Userr?
    var userId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(LocalCollectionCell.self, forCellWithReuseIdentifier: localCellId)
        collectionView?.register(NoPostCell.self, forCellWithReuseIdentifier: noCellId)
        collectionView?.reloadData()
        //fetchUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: EditProfileHeader.updateFeedNotificationName, object: nil)
    }
    @objc func handleRefresh() {
        self.posts.removeAll()
        self.collectionView?.reloadData()
    }
    var posts = [Post]()
    func getPostCount() -> Int {
        return posts.count
    }
    fileprivate func fetchOrderedPosts() {
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        //perhaps later on we'll implement some pagination of data
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.append(post)
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleLogOut))
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        setupLogOutButton()
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                let loginController = OnboardController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                self.modalTransitionStyle = .crossDissolve
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts.count == 0 {
            return 1
        }
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if posts.count == 0 {
            let noPostsCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! NoPostCell
            return noPostsCell
        }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: localCellId, for: indexPath) as! LocalCollectionCell
            cell.post = posts[indexPath.item]
            return cell
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if posts.count == 0 {
            //collectionView.alwaysBounceVertical = false
            return CGSize(width: view.frame.width, height: view.frame.height - 200)
        }
         return CGSize(width: view.frame.width, height: 150)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 175)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = StoryManager(collectionViewLayout: UICollectionViewFlowLayout())
        if posts.count > 0  {
        detail.post = posts[indexPath.item]
        detail.isHeroEnabled = true
        detail.heroModalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        navigationController?.present(detail, animated: true, completion: nil)
        }
    }

    fileprivate func fetchUser() {
        self.posts.removeAll()
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.fetchOrderedPosts()
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
}
class NoPostCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.text = "No stories yet."
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        addSubview(label)
        label.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
    }
    func setText(text: String) {
        label.text = text
    }
    func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (Userr) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = Userr(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
}







