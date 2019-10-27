//
//  StoryManager.swift
//  Humanitary
//
//  Created by Aedan Joyce on 11/3/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Hero
class StoryManager: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    private let startCellId = "startCellId"
    private let donateCellId = "donateCellId"
    var post: Post?
    var detailCell: StoryDetailCell?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailCell?.detailLabel.setContentOffset(CGPoint.zero, animated: false)
    }
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Dismiss"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    let actionBar: UIView = {
       let actionBar = UIView()
        actionBar.backgroundColor = UIColor.clear
        return actionBar
    }()
    var viewManager: ViewManager?
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.isPagingEnabled = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        //collectionView?.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0)
        collectionView?.register(StoryDetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(StoryStartCell.self, forCellWithReuseIdentifier: startCellId)
        collectionView?.register(DonateCell.self, forCellWithReuseIdentifier: donateCellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Dismiss"), style: .plain, target: self, action: nil)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        view.addSubview(actionBar)
        actionBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 50)
        actionBar.addSubview(button)
        button.anchor(top: nil, left: actionBar.leftAnchor, bottom: actionBar.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: -12, paddingRight: 0, width: 30, height: 30)
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StoryDetailCell
        cell.post = post
        switch indexPath.item {
        case 0:
            let storyStartCell = collectionView.dequeueReusableCell(withReuseIdentifier: startCellId, for: indexPath) as! StoryStartCell
            storyStartCell.post = post
            return storyStartCell
        case 1:
            cell.titleLabel.text = "What is the issue?"
            cell.detailLabel.text = post?.storyDesciption
            
        case 2:
            cell.titleLabel.text = "What is being done?"
            cell.detailLabel.text = post?.storyAnalysis
        case 3:
            cell.titleLabel.text = "How can you help?"
            cell.detailLabel.text = post?.storyHelpDescription
        case 4:
            let donateCell = collectionView.dequeueReusableCell(withReuseIdentifier: donateCellId, for: indexPath) as! DonateCell
            donateCell.post = post
            return donateCell
        default:
            break
        }
        
        return cell
    }
    
}
class StoryDetailCell: UICollectionViewCell {
    var post: Post?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.medium)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    let detailLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.textColor = UIColor(red:0.40, green:0.43, blue:0.47, alpha:1.0)
        label.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        label.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of  (The Extremes of Good and Evil) by Cicero, written in 45 BC. \n\nThis book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum,, comes from a line in section 1.10.32."
        label.isScrollEnabled = true
        label.isEditable = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        addSubview(titleLabel)
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 70, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(detailLabel)
        detailLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //self.detailLabel.scrollRangeToVisible(NSMakeRange(0, 0))
        detailLabel.setContentOffset(CGPoint.zero, animated: false)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DonateCell: UICollectionViewCell {
    var post: Post? {
        didSet{
            guard let url = post?.user.profileImageUrl else {return}
            userImageView.loadImage(urlString: url)
            storyTitle.text = post?.title
            guard let username = post?.user.username else {return}
            usernameLabel.text = "By " + username
        }
    }
    let imageView: CustomImageView = {
       let view = CustomImageView(image: #imageLiteral(resourceName: "selected"))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.text = "That's all, folks!"
        label.textAlignment = .center
        return label
    }()
    let donateButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Donate to this cause", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 100
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        return button
    }()
    let userImageView: CustomImageView = {
        let view = CustomImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let storyTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.textColor = UIColor.black
        label.textAlignment = .left
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
        backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        addSubview(donateButton)
        donateButton.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width - 75, height: 50)
        donateButton.layer.cornerRadius = 50/2
        donateButton.addShadow()
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: nil, bottom: donateButton.topAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -12, paddingRight: 0, width: 0, height: 0)
        addSubview(imageView)
        imageView.anchor(top: nil, left: nil, bottom: titleLabel.topAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -12, paddingRight: 0, width: 80, height: 80)
        addSubview(userImageView)
        userImageView.anchor(top: donateButton.bottomAnchor, left: donateButton.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        userImageView.layer.cornerRadius = 5
        addSubview(storyTitle)
        storyTitle.anchor(top: userImageView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(usernameLabel)
        usernameLabel.anchor(top: storyTitle.bottomAnchor, left: storyTitle.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        donateButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        
    }
    @objc func openLink() {
        guard let link = post?.donateLink else {return}
        guard let url = URL(string: link) else {return}
        //detailController?.showSafariForURL(url: url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
extension UIButton {
    func addShadow() {
        self.layer.shadowColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0).cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.cornerRadius = 10
    }
    func addBlueShadow() {
        self.layer.shadowColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0).cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0
    }
    func removeShadow() {
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.cornerRadius = 3
    }
}
