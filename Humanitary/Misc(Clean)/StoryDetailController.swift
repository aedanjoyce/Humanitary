//
//  StoryDetailController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/1/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import SafariServices




class StoryDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout, StoryCellDelegate {
    func pushToViewWithPost(post: Post) {
        print("Push to view called")
        let userProfileController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = post.user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    private let sectionHeaderId = "sectionHeaderId"
    private let headerId = "headerId"
    private let cellId = "cellId"
    private let footerId = "footerId"
    var post: Post?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        UIApplication.shared.statusBarView?.backgroundColor = .white
//        navigationController?.navigationBar.shadowImage = #imageLiteral(resourceName: "Irma")
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(DetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(SectionHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderId)
        collectionView?.register(EventDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(EventFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
    }
    func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            if indexPath.section == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EventDetailHeader
                header.post = post
                return header
            } else {
                
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderId, for: indexPath) as! SectionHeaderCell
            
                if indexPath.section == 1 {
                    sectionHeader.titleLabel.text = "What is being done?"
                } else if indexPath.section == 2 {
                    sectionHeader.titleLabel.text = "How You Can Help"
                }
                return sectionHeader
            }
        default:
        
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! EventFooter
            footer.post = post
            footer.storyDelegate = self
         return footer
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailCell
        cell.post = post
        if indexPath.section == 0 {
            cell.textView.text = post?.storyDesciption
        } else if indexPath.section == 1 {
            cell.textView.text = post?.storyAnalysis
        } else {
            cell.textView.text = post?.storyHelpDescription
        }
        return cell
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfContent = view.frame.width - 6
        // x is the width of the logo in the left
        
        let size = CGSize(width: approximateWidthOfContent, height: 2000)
        
        //1000 is the large arbitrary values which should be taken in case of very high amount of content
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)]
        var estimatedFrame: CGRect?
        if indexPath.section == 0 {
            estimatedFrame = NSString(string: (post?.storyDesciption)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        } else if indexPath.section == 1 {
                estimatedFrame = NSString(string: (post?.storyAnalysis)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        } else {
             estimatedFrame = NSString(string: (post?.storyHelpDescription)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }
        
        return CGSize(width: view.frame.width, height: estimatedFrame!.height + 93)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 275)
        }
        return CGSize(width: view.frame.width, height: 25)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 2 {
       return CGSize(width: view.frame.width, height: 180)
        } else {
       return CGSize(width: view.frame.width, height: 0)
        }
    }
}
class EventDetailHeader: UICollectionViewCell {
    var detailController: StoryDetailController?
    var post: Post? {
        didSet {
            eventTitle.text = post?.title
            eventSubTitle.text = post?.subTitle
            guard let postImageUrl = post?.imageUrl else {return}
            imageView.loadImage(urlString: postImageUrl)
        }
    }
 
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let eventTitle: UILabel = {
        let label = UILabel()
        label.text = "The problems in Puerto Rico"
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.medium)
        label.textAlignment = .left
        return label
    }()
    let eventSubTitle: UILabel = {
        let label = UILabel()
        label.text = "Many people aren't doing anything. I plan to change that"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        label.textColor = UIColor(red:0.40, green:0.43, blue:0.47, alpha:1.0)
        label.textAlignment = .left
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "What is the issue?"
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(eventTitle)
        eventTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        addSubview(eventSubTitle)
        eventSubTitle.anchor(top: eventTitle.bottomAnchor, left: eventTitle.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        addSubview(imageView)
        imageView.anchor(top: eventSubTitle.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 150)
        addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: eventTitle.leftAnchor, bottom: bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SectionHeaderCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DetailCell: UICollectionViewCell {
    var post: Post?
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        return view
    }()
    let textView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textAlignment = .left
       // view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        view.textColor = UIColor(red:0.40, green:0.43, blue:0.47, alpha:1.0)
        view.isEditable = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupViews()
        textView.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(textView)
        textView.anchor(top:  container.topAnchor, left:  container.leftAnchor, bottom:  container.bottomAnchor, right:  container.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
class EventFooter: UICollectionViewCell {
    var storyDelegate: StoryCellDelegate?
    var post: Post? {
        didSet {
            guard let username = post?.user.username else {return}
            nameLabel.text = username
            guard let postImageUrl = post?.user.profileImageUrl else {return}
            imageView.loadImage(urlString: postImageUrl)
        }
    }
    
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        return label
    }()
    var detailController: StoryDetailController?
    let donateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Donate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        button.tintColor = UIColor(red:0.35, green:0.69, blue:0.97, alpha:1.0)
        button.backgroundColor = UIColor.white
        //button.titleLabel?.textColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        button.layer.shadowColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0).cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize.zero
        button.layer.cornerRadius = 5
        return button
    }()
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.textColor = UIColor(red:0.35, green:0.69, blue:0.97, alpha:1.0)
        button.tintColor = UIColor(red:0.35, green:0.69, blue:0.97, alpha:1.0)
        button.setTitle("See More", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:0.35, green:0.69, blue:0.97, alpha:1.0).cgColor
        button.layer.cornerRadius = 5
        button.contentHorizontalAlignment = .center
        button.backgroundColor = UIColor.white
        //button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return button
    }()
    let seperator: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.opacity = 0.25
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(donateButton)
        donateButton.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width - 24, height: 50)
        donateButton.addTarget(self, action: #selector(showLink), for: .touchUpInside)
        addSubview(seperator)
        seperator.anchor(top: donateButton.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 1)
        addSubview(imageView)
        imageView.anchor(top: seperator.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        imageView.layer.cornerRadius = 60 / 2
        addSubview(nameLabel)
        nameLabel.anchor(top: imageView.topAnchor, left: imageView.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: frame.width - 6, height: 0)
        addSubview(moreButton)
        moreButton.anchor(top: nameLabel.bottomAnchor, left: imageView.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 3, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 120, height: 25)
          moreButton.addTarget(self, action: #selector(seeMore), for: .touchUpInside)
        //moreButton.setTitle("see more", for: .normal)
        //moreButton.titleLabel?.text = "See more"
        
    }
    @objc func seeMore() {
        print("called")
        guard let post = post else {return}
        storyDelegate?.pushToViewWithPost(post: post)
    }
    @objc func showLink() {
        print("called")
        guard let link = post?.donateLink else {return}
        guard let url = URL(string: link) else {return}
        //detailController?.showSafariForURL(url: url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
protocol StoryCellDelegate {
    func pushToViewWithPost(post: Post)
}
protocol StoryCreationDelegate {
    func presentAlertController(controller: UIAlertController)
}


