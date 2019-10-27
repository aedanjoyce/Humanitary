//
//  StoryDescriptionController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/3/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
class BaseConstructionController: UIViewController, UITextViewDelegate {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        label.textAlignment = .center
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
  let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(pushToView))
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.backgroundColor = UIColor.white
        navigationItem.setRightBarButton(nextButton, animated: true)
        titleLabel.anchor(top:  view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: titleLabel.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        nextButton.isEnabled = false
    }
    func setTitleAndSubTitle(title: String, subtitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subtitle
    }
    @objc func pushToView() {}
    func determineIfFieldIsFilledOut(field: UITextView) {
        let isFilledOut = field.text?.characters.count ?? 0 > 0
        if isFilledOut {
            nextButton.isEnabled = true
            nextButton.action = #selector(pushToView)
        } else {
            nextButton.isEnabled = false
        }
    }
}


//class DonateController: BaseConstructionController {
//    var storyController: StoryController?
//    var storyDescription: StoryDescriptionController?
//    var helpController: HelpController?
//    var analysisController: AnalysisController?
//    let donateField: UITextField = {
//        let label = UITextField()
//        label.placeholder = "Link"
//        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
//        //label.backgroundColor = UIColor(red:0.40, green:0.43, blue:0.47, alpha:1.0)
//        label.autocapitalizationType = .none
//        return label
//    }()
//    let donateSeperator: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.lightGray
//        return view
//    }()
//    let titleSmallLabel: UILabel = {
//        let label = UILabel()
//        label.text = "LINK"
//        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
//        label.textAlignment = .left
//        label.textColor = UIColor.lightGray
//        return label
//    }()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        nextButton.title = "Post"
//        donateField.addTarget(self, action: #selector(changeSeperatorColor), for: .allEditingEvents)
//        donateField.becomeFirstResponder()
//        setTitleAndSubTitle(title: "Paste a valid donation link", subtitle: "Please choose one reliable organization that you feel will help this cause")
//        view.addSubview(donateField)
//        donateField.anchor(top: subTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 22, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 24, height: 50)
//        view.addSubview(donateSeperator)
//        donateSeperator.anchor(top: nil, left: nil, bottom: donateField.bottomAnchor, right: nil, centerX: donateField.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width-24, height: 1)
//        donateSeperator.layer.opacity = 0.5
//        view.addSubview(titleSmallLabel)
//        titleSmallLabel.anchor(top: donateField.topAnchor, left: donateField.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: -6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        titleSmallLabel.layer.opacity = 0
//    }
//    var animationHasShown = false
//    @objc func changeSeperatorColor() {
//        if donateField.isEditing == true {
//            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//                self.donateSeperator.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
//                self.donateSeperator.layer.opacity = 1
//            }, completion: nil)
//        } else {
//            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//                self.donateSeperator.backgroundColor = UIColor.lightGray
//                self.donateSeperator.layer.opacity = 0.5
//            }, completion: nil)
//        }
//        let donateValid = donateField.text?.count ?? 0 > 0
//        if donateValid {
//            if animationHasShown == false {
//                fadeIn(label: titleSmallLabel)
//                nextButton.isEnabled = true
//                animationHasShown = true
//            }
//        } else {
//            fadeOut(label: titleSmallLabel)
//            nextButton.isEnabled = false
//            animationHasShown = false
//        }
//}
//    func canOpenURL(string: String?) -> Bool {
//        guard let urlString = string else {return false}
//        guard let url = NSURL(string: urlString) else {return false}
//        if !UIApplication.shared.canOpenURL(url as URL) {return false}
//        
//        //
//        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
//        return predicate.evaluate(with: string)
//    }
//    override func pushToView() {
//       // guard let caption = textView.text, caption.characters.count > 0 else { return }
//        guard let image = storyController?.causePhotoView.imageView?.image else { return }
//        
//        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
//        
//        navigationItem.rightBarButtonItem?.isEnabled = false
//        
//        let filename = NSUUID().uuidString
//        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
//            
//            if let err = err {
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
//                print("Failed to upload post image:", err)
//                return
//            }
//            
//            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
//            
//            print("Successfully uploaded post image:", imageUrl)
//            
//            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
//        }
//    }
//    static let updateFeedNotificationName = NSNotification.Name("UpdateFeed")
//    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
//        guard let postImage = storyController?.causePhotoView.imageView?.image else { return }
// 
//        guard let titleText = storyController?.titleTextField.text else {return}
//        guard let subTitle = storyController?.subTitleTextField.text else {return}
//        guard let storyDescription = storyDescription?.descriptionTextField.text else {return}
//        guard let storyAnalysis = analysisController?.analysisTextField.text else {return}
//        guard let storyHelpDescription = helpController?.helpTextField.text else {return}
//        guard let donateLink = donateField.text else {return}
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        let userPostRef = Database.database().reference().child("posts").child(uid)
//        let ref = userPostRef.childByAutoId()
//        
//        let values = ["title": titleText, "subTitle": subTitle,"storyDesciption": storyDescription ,"storyAnalysis": storyAnalysis, "storyHelpDescription": storyHelpDescription,"imageUrl": imageUrl, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height,"donateLink": donateLink, "creationDate": Date().timeIntervalSince1970] as [String: Any]
//        
//        ref.updateChildValues(values) { (err, ref) in
//            if let err = err {
//                self.nextButton.isEnabled = true
//                print("Failed to save post into DB", err)
//                return
//            }
//            print("Successfully saved post into DB")
//            self.nextButton.isEnabled = false
//            self.navigationController?.popToRootViewController(animated: true)
//            self.modalTransitionStyle = .crossDissolve
//            NotificationCenter.default.post(name: EditProfileHeader.updateFeedNotificationName, object: nil)
//        }
//    }
//    
//    
//}
//
//
