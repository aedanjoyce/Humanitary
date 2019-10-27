//
//  StoriesByPlaceController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 11/9/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
protocol StoryPlaceDelegate {
    func sendPostCount(count: Int)
}
class StoriesByPlaceController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    private let headerId = "headerId"
    var posts = [Post]()
    var number = 3
    var location = ""
    var placeId: String?
    var gmsPlace: GMSPlace? {
        didSet {
            guard let placeName = gmsPlace?.name else {return}
            location = placeName
            print("location", location)
            navigationItem.title = location
        }
    }
    var placeDelegate: StoryPlaceDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(LocalCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PlaceHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
        placeDelegate?.sendPostCount(count: 5)
        fetchPosts()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LocalCollectionCell
        cell.post = posts[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PlaceHeader
        header.gmsPlace = self.gmsPlace
        header.placeController = self
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyManager = StoryManager(collectionViewLayout: UICollectionViewFlowLayout())
        storyManager.post = posts[indexPath.item]
        storyManager.isHeroEnabled = true
        storyManager.heroModalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        present(storyManager, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    fileprivate func fetchPosts() {
        print("fetching")
            Database.database().reference().child("posts").observe(.value, with: { (snapshot) in
                guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
                userIdsDictionary.forEach({ (arg) in
                    let (key, value) = arg
                    Database.fetchUsersWithUID(uid: key, completion: { (user) in
                        self.fetchPostsWithUserAndLocation(user: user)
                    })
                })
            }) { (err) in
                print("Failed to fetch following user:", err)
        }
    }
    fileprivate func fetchPostsWithUserAndLocation(user: Userr) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                if post.location == self.gmsPlace?.name {
                    print(snapshot.key)
                    self.posts.append(post)
                }
                self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.collectionView?.reloadData()
            })
            
        }) { (err) in
            print("Failed to fetch posts", err)
        }
    }

    
}
class PlaceHeader: UICollectionViewCell, StoryPlaceDelegate {
    
    func sendPostCount(count: Int) {
    }
    var total: Int?
    var placeController: StoriesByPlaceController?
    var gmsPlace: GMSPlace? {
        didSet{
            guard let placeId = self.gmsPlace?.placeID else {return}
            loadFirstPhotoForPlace(placeID: placeId)
            guard let name = self.gmsPlace?.name else {return}
            titleLabel.text = name
        }
    }
    let placeImage: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = UIColor.customLightGrey
        return image
    }()
    let attributionTextView: UITextView = {
        let text = UITextView()
        return text
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        return label
    }()
    let storyCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.textColor = UIColor.lightGray
        return label
    }()
    let seperator: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.customLightGrey
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupViews()
    }
    func setupViews() {
        addSubview(seperator)
        seperator.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 25)
        addSubview(attributionTextView)
        attributionTextView.anchor(top: nil, left: leftAnchor, bottom: seperator.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: -36, paddingRight: 0, width: 0, height: 0)
        addSubview(titleLabel)
        titleLabel.anchor(top: attributionTextView.bottomAnchor, left: attributionTextView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        addSubview(placeImage)
        placeImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: frame.height - 25)
//        addSubview(storyCountLabel)
//        storyCountLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        guard let count = placeController?.number else {return}
        print(count)
        storyCountLabel.text = "stories"
        print("Count;","\(placeController?.posts.count)")
    }
    
    func countStories() -> Int {
        var count = 0
        return count
    }
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.placeImage.image = photo;
                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
