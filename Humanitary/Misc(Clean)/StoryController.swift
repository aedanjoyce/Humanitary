//
//  StoryController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/3/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit

//class StoryController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    let titleTextField: BorderedTextField = {
//        let field = BorderedTextField()
//        field.placeholder = "Title"
//        field.setLabelText(text: "TITLE")
//        field.textAlignment = .left
//        return field
//    }()
//    let subTitleTextField: BorderedTextField = {
//        let field = BorderedTextField()
//        field.placeholder = "Subtitle"
//        field.setLabelText(text: "SUBTITLE")
//        field.textAlignment = .left
//        return field
//    }()
//    let causePhotoView: UIButton = {
//        let view = UIButton(type: .system)
//        view.setImage(#imageLiteral(resourceName: "AddPhoto"), for: .normal)
//        view.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    @objc func handlePhoto() {
//        DispatchQueue.main.async {
//            let pickerController = UIImagePickerController()
//            pickerController.delegate = self
//            pickerController.allowsEditing = true
//            self.present(pickerController, animated: true, completion: nil)
//        }
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            causePhotoView.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            causePhotoView.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//        
//        causePhotoView.layer.masksToBounds = true
//        dismiss(animated: true, completion: nil)
//    }
//   private let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(pushToDescriptionView))
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.setRightBarButton(nextButton, animated: true)
//        nextButton.isEnabled = false
//        view.backgroundColor = UIColor.white
//        setupViews()
//        titleTextField.becomeFirstResponder()
//        hideKeyboardWithOutsideTouch()
//    }
//    @objc func pushToDescriptionView() {
//        print("Called")
//        let desc = StoryDescriptionController()
//        desc.navigationItem.title = titleTextField.text
//        desc.storyController = self
//        navigationController?.pushViewController(desc, animated: true)
//    }
//    func setupViews() {
//        view.addSubview(causePhotoView)
//        view.addSubview(titleTextField)
//        view.addSubview(subTitleTextField)
//        titleTextField.addTarget(self, action: #selector(changeSeperatorColor),for: .allEditingEvents)
//        subTitleTextField.addTarget(self, action: #selector(changeSeperatorColor),for: .allEditingEvents)
//        titleTextField.setSeperator(width: view.frame.width - 24)
//        subTitleTextField.setSeperator(width: view.frame.width - 24)
//        navigationItem.title = "New Story"
//        if UIScreen.main.bounds.height < 500 {
//            causePhotoView.anchor(top:  view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 24, height: 100)
//            titleTextField.anchor(top: causePhotoView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 24, height: 30)
//              subTitleTextField.anchor(top: titleTextField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 24, height: 30)
//            changeConstraints(field: titleTextField, height: 12)
//            changeConstraints(field: subTitleTextField, height: 12)
//        } else {
//            causePhotoView.anchor(top:  view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 24, height: 200)
//            titleTextField.anchor(top: causePhotoView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 24, height: 50)
//            subTitleTextField.anchor(top: titleTextField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 24, height: 50)
//        }
//    }
//    func changeConstraints(field: BorderedTextField, height: CGFloat) {
//        field.font = UIFont.systemFont(ofSize: height)
//        field.setLabelSize(size: height)
//        field.setLabelText(text: "")
//        field.autocorrectionType = .no
//        
//    }
//    @objc func changeSeperatorColor() {
//        let titleGreaterThanZero = titleTextField.text?.characters.count ?? 0 > 0
//        let subGreater = subTitleTextField.text?.characters.count ?? 0 > 0
//        let photoIsSelected = causePhotoView.currentImage?.isEqual(#imageLiteral(resourceName: "AddPhoto")) == false
//        let isFormValid = titleGreaterThanZero && subGreater && photoIsSelected
//        if isFormValid {
//            nextButton.isEnabled = true
//            nextButton.action = #selector(pushToDescriptionView)
//        } else {
//            nextButton.isEnabled = false
//        }
//        
//        
//    }
//}
extension UIViewController {
    func fadeIn(label: UILabel) {
     let origin = label.frame.origin.y
        label.frame.origin.y += 10
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            label.layer.opacity = 1
            label.frame.origin.y = origin
        }, completion: nil)
    }
    func fadeOut(label: UILabel) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            label.layer.opacity = 0
            label.frame.origin.y += 10
        }, completion: nil)
    }
}
extension UITextField {
    func fadeInLabel(label: UILabel) {
        let origin = label.frame.origin.y
        label.frame.origin.y += 10
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            label.layer.opacity = 1
            label.frame.origin.y = origin
        }, completion: nil)
    }
    func fadeOutLabel(label: UILabel) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            label.layer.opacity = 0
            label.frame.origin.y += 10
        }, completion: nil)
    }
}

