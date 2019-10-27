//
//  StoryDescriptionController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 2/11/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GooglePlaces
class StoryDescriptionController: BaseConstructionController {
    var storyController: NewStoryController?
    var placeId = ""
    let descriptionTextField: UITextView = {
        let field = UITextView()
        field.backgroundColor = UIColor.customLightGrey
        field.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        field.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        field.backgroundColor = UIColor.white
        return field
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setTitleAndSubTitle(title: "What's the issue?", subtitle: "Please be as specific as possible")
        descriptionTextField.becomeFirstResponder()
        view.addSubview(descriptionTextField)
        descriptionTextField.anchor(top: subTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height / 2.5)
        self.descriptionTextField.delegate = self
    }
    override func pushToView() {
        let analysis = AnalysisController()
        analysis.storyController = storyController
        analysis.storyDescription = self
        analysis.placeId = self.placeId
        navigationController?.pushViewController(analysis, animated: true)
    }
    func textViewDidChange(_ textView: UITextView) {
        determineIfFieldIsFilledOut(field: descriptionTextField)
    }
    
}
class AnalysisController: BaseConstructionController {
    var placeId = ""
    var storyController: NewStoryController?
    var storyDescription: StoryDescriptionController?
    let analysisTextField: UITextView = {
        let field = UITextView()
        field.backgroundColor = UIColor.customLightGrey
        field.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        field.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        field.backgroundColor = UIColor.white
        return field
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleAndSubTitle(title: "What is being done?", subtitle: "Please be as specific as possible")
        setupViews()
        analysisTextField.becomeFirstResponder()
        view.addSubview(analysisTextField)
        analysisTextField.anchor(top: subTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height / 2.5)
        self.analysisTextField.delegate = self
    }
    override func pushToView() {
        print("pusjed")
        let help = HelpController()
        help.storyController = storyController
        help.storyDescription = storyDescription
        help.analysisController = self
        help.placeId = self.placeId
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(help, animated: true)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        determineIfFieldIsFilledOut(field: analysisTextField)
    }
}
class HelpController: BaseConstructionController {
    var placeId = ""

    
    var storyController: NewStoryController?
    var storyDescription: StoryDescriptionController?
    var analysisController: AnalysisController?
    let helpTextField: UITextView = {
        let field = UITextView()
        field.backgroundColor = UIColor.customLightGrey
        field.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        field.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        field.backgroundColor = UIColor.white
        return field
    }()
    private var location = ""
    fileprivate func setLocation(locationString: String) {
        location = locationString
        print("setLocation:", location)
    }
    fileprivate func getLocation() -> String {
        return location
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleAndSubTitle(title: "How Someone Can Help", subtitle: "Please be as specific as possible")
        setupViews()
        helpTextField.becomeFirstResponder()
        view.addSubview(helpTextField)
        helpTextField.anchor(top: subTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height / 2.5)
        self.helpTextField.delegate = self
        nextButton.title = "Share"
        guard let locationText = storyController?.locationButton.titleLabel?.text else {return}
        print(locationText)
        setLocation(locationString: locationText)
        print("\(placeId)", " PLace")
    }
    func textViewDidChange(_ textView: UITextView) {
        determineIfFieldIsFilledOut(field: helpTextField)
    }
        override func pushToView() {
           // guard let caption = textView.text, caption.characters.count > 0 else { return }
            guard let image = storyController?.addPhotoButton.imageView?.image else { return }
    
            guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
    
            navigationItem.rightBarButtonItem?.isEnabled = false
    
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
    
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to upload post image:", err)
                    return
                }
    
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
    
                print("Successfully uploaded post image:", imageUrl)
    
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            }
        }
        static let updateFeedNotificationName = NSNotification.Name("UpdateFeed")
            fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
            guard let postImage = storyController?.addPhotoButton.imageView?.image else { return }
    
            guard let titleText = storyController?.titleLabelView.text else {return}
            guard let subTitle = storyController?.subLabelView.text else {return}
            guard let donateLink = storyController?.linkTextField.text else {return}
            let locationText = getLocation()
            print("getLocation", locationText)
            guard let storyDescription = storyDescription?.descriptionTextField.text else {return}
            guard let storyAnalysis = analysisController?.analysisTextField.text else {return}
            
            guard let storyHelpDescription = helpTextField.text else {return}
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
    
            let userPostRef = Database.database().reference().child("posts").child(uid)
            let ref = userPostRef.childByAutoId()
    
            let values = ["title": titleText, "subTitle": subTitle,"storyDesciption": storyDescription ,"storyAnalysis": storyAnalysis, "storyHelpDescription": storyHelpDescription,"imageUrl": imageUrl, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height,"donateLink": donateLink, "creationDate": Date().timeIntervalSince1970, "location": locationText] as [String: Any]
            let locationRef = Database.database().reference().child("location").child(placeId).childByAutoId()
                let locationValues = ["location": locationText, "creationDate": Date().timeIntervalSince1970, "placeId": placeId] as [String : Any]
            locationRef.updateChildValues(locationValues) { (err, ref) in
                if let err = err {
                    print("Problem saving location", err)
                    return
                }
            }
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.nextButton.isEnabled = true
                    print("Failed to save post into DB", err)
                    return
                }
                print("Successfully saved post into DB")
                NotificationCenter.default.post(name: EditProfileHeader.updateFeedNotificationName, object: nil)
                DispatchQueue.main.async {
                    self.nextButton.isEnabled = false
                    self.navigationController?.popToRootViewController(animated: true)
                    self.modalTransitionStyle = .crossDissolve
                }
            }
        }
}
