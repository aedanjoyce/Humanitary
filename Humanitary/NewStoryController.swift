//
//  NewStoryController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/22/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
class NewStoryController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate, UITextViewDelegate  {
    var placeId = ""
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //helpControllerDelegate?.setGMSPlaceId(gmsPlaceId: place.placeID)
        placeId = place.placeID
        self.dismiss(animated: true) {
        self.locationButton.titleLabel?.text = place.name
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true) {
            if self.locationButton.titleLabel?.text != "Location" {
                self.locationButton.titleLabel?.text = self.locationButton.titleLabel?.text
            }
        }
        
    }
    var alertText: UITextField?
    let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.customLightGrey
        button.setTitle("Tap to add a cover photo", for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "PlusPhoto"), for: UIControlState.normal)
        button.titleLabel?.textAlignment = .center
        button.contentMode = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return button
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return label
    }()
     lazy var titleLabelView: UITextView = {
        let label = UITextView()
        label.backgroundColor = UIColor.customLightGrey
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isScrollEnabled = false
        label.layer.cornerRadius = 5
        label.delegate = self
        return label
    }()
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtitle"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return label
    }()
    lazy var subLabelView: UITextView = {
        let label = UITextView()
        label.backgroundColor = UIColor.customLightGrey
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isScrollEnabled = false
        label.layer.cornerRadius = 5
        label.delegate = self
        return label
    }()
    let linkLabel: UILabel = {
        let label = UILabel()
        label.text = "Donation Link (Required)"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return label
    }()
     lazy var linkTextField: UITextView = {
        let label = UITextView()
        label.backgroundColor = UIColor.customLightGrey
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isScrollEnabled = false
        label.layer.cornerRadius = 5
        label.autocorrectionType = .no
        label.autocapitalizationType = .none
        label.delegate = self
        return label
    }()
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Location", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.customLightGrey
        button.layer.cornerRadius = 5
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(addPlace), for: .touchUpInside)
        return button
    }()
    
    private let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(pushToDescription))
    @objc func pushToDescription() {
        let desc = StoryDescriptionController()
        desc.storyController = self
        desc.placeId = self.placeId
        print(placeId)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(desc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Story"
        view.backgroundColor = UIColor.white
        titleLabelView.customizeView()
        subLabelView.customizeView()
        nextButton.isEnabled = false
        setupViews()
        self.hideKeyboardWithOutsideTouch()
        navigationItem.setRightBarButton(nextButton, animated: true)
        observeKeyboardNotifications()
    }
    func setupViews() {
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 200)
        addPhotoButton.alignImageAndTitleVertically()
        view.addSubview(titleLabel)
        titleLabel.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        view.addSubview(titleLabelView)
        titleLabelView.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 48, height: 0)
        view.addSubview(subLabel)
        subLabel.anchor(top: titleLabelView.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        view.addSubview(subLabelView)
        subLabelView.anchor(top: subLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width-48, height: 0)
        view.addSubview(linkLabel)
        linkLabel.anchor(top: subLabelView.bottomAnchor, left: subLabelView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        view.addSubview(linkTextField)
        linkTextField.anchor(top: linkLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width-48, height: 0)
        view.addSubview(locationButton)
        locationButton.anchor(top: linkTextField.bottomAnchor, left: linkTextField.leftAnchor, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 48, height: 50)
        nextButton.action = #selector(pushToDescription)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            if self.linkTextField.isFirstResponder == true {
                self.view.frame = CGRect(x: 0, y: -2*(self.subLabelView.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            }
            if self.subLabelView.isFirstResponder == true {
                self.view.frame = CGRect(x: 0, y: -1.5*(self.subLabelView.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            }
        }, completion: nil)
    }
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.delegate = self
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        isFormValid()
        isValidLink(linkTextField.text)
    }
    func isValidLink(_ link: String) -> Bool{
        let isValid = link.count > 0 && canOpenURL(string: link)
        if isValid
        {
            linkTextField.layer.borderColor = UIColor.green.cgColor
            linkTextField.layer.borderWidth = 1
        } else {
            linkTextField.layer.borderColor = UIColor.red.cgColor
            linkTextField.layer.borderWidth = 1
        }
        return isValid
    }
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    @objc func addPlace() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tableCellBackgroundColor = UIColor.white
        DispatchQueue.main.async {
            self.present(autocompleteController, animated: true, completion: nil)
        }
    }
    @objc func isFormValid() {
        isValidLink(linkTextField.text)
        let formIsValid = titleLabelView.text?.count ?? 0 > 0 && subLabelView.text?.count ?? 0 > 0 && isValidLink(linkTextField.text) && addPhotoButton.currentImage?.isEqual(#imageLiteral(resourceName: "PlusPhoto")) == false
        if formIsValid {
            nextButton.isEnabled = true
            nextButton.action = #selector(pushToDescription)
        } else {
            nextButton.isEnabled = false
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        isFormValid()
        isValidLink(linkTextField.text)
    }
    @objc func handlePhoto() {
        DispatchQueue.main.async {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        addPhotoButton.layer.masksToBounds = true
        dismiss(animated: true, completion: nil)
    }
}



extension UIButton {
    
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
}
