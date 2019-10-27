//
//  StoryCreator.swift
//  Humanitary
//
//  Created by Aedan Joyce on 11/7/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import GooglePlaces
class StoryCreator: UIViewController, UITextViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate {
    var storyDelegate: StoryCreationDelegate?
    var alertText: UITextField?
    var scrollView: UIScrollView!
    let titleField: UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        return field
    }()
    let photoButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Choose a photo", for: .normal)
        return button
    }()
    let subTitleField: UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        return field
    }()
    let issueField: UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return field
    }()
    let beingDoneField: UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return field
    }()
    let helpField: UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return field
    }()
    let linkLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return label
    }()
    let linkImage: CustomImageView = {
       let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
       return image
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        return label
    }()
    let locationImage: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    var shareButton = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.done, target: self, action: #selector(shareStory))
    lazy var inputToolbar: UIToolbar = {
        var toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        var linkButton = UIBarButtonItem(image: #imageLiteral(resourceName: "link"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(addLink))
        var placeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "location"), style: .plain, target: self, action: #selector(addPlace))
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 20
        toolBar.setItems([linkButton, space, placeButton, flexSpace, shareButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }()
    var containerView = UIView()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Story"
        setupScrollView()
        view.backgroundColor = UIColor.white
        titleField.becomeFirstResponder()
        containerView.addSubview(titleField)
        self.titleField.delegate = self
        self.subTitleField.delegate = self
        titleField.customizeTextView()
        subTitleField.customizeTextView()
        let fixedWidth = titleField.frame.size.width
        titleField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = titleField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = titleField.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        titleField.frame = newFrame
        titleField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: view.frame.width-12, height: 0)
        containerView.addSubview(subTitleField)
        subTitleField.anchor(top: titleField.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, centerX:
            nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: view.frame.width-12, height: 0)
        titleField.placeholder = "Title"
        titleField.inputAccessoryView = inputToolbar
        subTitleField.placeholder = "Subtitle"
        subTitleField.inputAccessoryView = inputToolbar
        setupLabels(label: linkLabel, image: linkImage, textViewAbove: subTitleField, labelAbove: nil)
        setupLabels(label: locationLabel, image: locationImage, textViewAbove: nil, labelAbove: linkLabel)
        var issueLabel = UILabel()
        var beingDoneLabel = UILabel()
        var helpLabel = UILabel()
        setupLabelsAndFields(label: issueLabel, field: issueField, viewAbove: nil, labelAbove: locationLabel, labelText: "What is the issue?", fieldPlaceholder: "Please describe the issue...")
        setupLabelsAndFields(label: beingDoneLabel, field: beingDoneField, viewAbove: issueField, labelAbove: nil, labelText: "What's being done?", fieldPlaceholder: "Please describe what's being done about the issue...")
        setupLabelsAndFields(label: helpLabel, field: helpField, viewAbove: beingDoneField, labelAbove: nil, labelText: "How can someone help?", fieldPlaceholder: "Please describe how someone can help the cause...")
    }
    func textViewDidChange(_ textView: UITextView) {
        isFormValid()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = inputToolbar
        textView.delegate = self
        return true
    }
    @objc func shareStory() {
        let isFormValid = titleField.text.count ?? 0 > 0 && subTitleField.text.count ?? 0 > 0
            && issueField.text.count ?? 0 > 0 && beingDoneField.text.count ?? 0 > 0 && helpField.text.count ?? 0 > 0 && linkLabel.text != ""
        if isFormValid {
            print("yuhhhh")
        } else {
            //shareButton.isEnabled = false
            print("nahhhh")
            let alertController = UIAlertController(title: "Missing Information", message: "Ensure that all fields are filled out and that you have attached a donation link", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
            })
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    @objc func addPlace() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tableCellBackgroundColor = UIColor.white
        DispatchQueue.main.async {
             self.present(autocompleteController, animated: true, completion: nil)
        }
    }
    func isFormValid() {
        print("valid")
    }
    
}

