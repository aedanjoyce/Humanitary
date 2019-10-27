//
//  StoryCreatorExtension.swift
//  Humanitary
//
//  Created by Aedan Joyce on 11/9/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import GooglePlaces
extension StoryCreator {
    func setupLabelsAndFields(label: UILabel, field: UITextView, viewAbove: UITextView?, labelAbove: UILabel?, labelText: String, fieldPlaceholder: String) {
        containerView.addSubview(label)
        containerView.addSubview(field)
        label.text = labelText
        field.inputAccessoryView = inputToolbar
        field.delegate = self
        field.placeholder = fieldPlaceholder
        label.normalizeAttributes()
        field.customizeTextView()
        if viewAbove != nil {
            label.anchor(top: viewAbove?.bottomAnchor , left: containerView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        } else {
            label.anchor(top: labelAbove?.bottomAnchor , left: containerView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        }
        field.anchor(top: label.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 12, height: 0)
    }
    func setupScrollView() {
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        //scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.contentSize =  CGSize(width: view.frame.width, height: 1000)
        scrollView.addSubview(containerView)
    }
    func setupLabels(label: UILabel, image: CustomImageView, textViewAbove: UITextView?, labelAbove: UILabel?) {
        scrollView.addSubview(label)
        scrollView.addSubview(image)
        if textViewAbove != nil {
            image.anchor(top: textViewAbove?.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        } else {
            image.anchor(top: labelAbove?.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        }
        label.anchor(top: image.topAnchor, left: image.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    @objc func addLink() {
        let alertController = UIAlertController(title: "Enter Donation Link", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            self.alertText = alertController.textFields![0] as UITextField
            guard let text = self.alertText?.text else {return}
            print("firstName \(self.alertText?.text)")
            self.fadeInLabel(label: self.linkLabel, image: self.linkImage, imageName: "link", receiverText: text)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter link"
            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInAlert), for: .editingChanged)
        }
        
        saveAction.isEnabled = false
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        print("link called")
    }
    func fadeInLabel(label: UILabel, image: CustomImageView, imageName: String, receiverText: String) {
        let labelOrigin = label.frame.origin.y
        label.frame.origin.y += 20
        let imageOrigin = image.frame.origin.y
        image.frame.origin.y += 20
        label.layer.opacity = 0
        image.layer.opacity = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            label.layer.opacity = 1
            image.layer.opacity = 1
            image.image = UIImage(named: imageName)
            label.text = receiverText
            label.frame.origin.y = labelOrigin
            label.frame.origin.y = imageOrigin
        }, completion: nil)
    }
}
extension StoryCreator: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        dismiss(animated: true) {
            self.fadeInLabel(label: self.locationLabel, image: self.locationImage, imageName: "location", receiverText: place.name)
        }
        view.endEditing(false)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension UILabel {
    func normalizeAttributes() {
        self.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
        self.textAlignment = .left
        self.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    }
}
extension UITextView {
    func customizeTextView() {
        self.backgroundColor = UIColor.white
        self.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        self.backgroundColor = UIColor.white
        self.isScrollEnabled = false
        self.clearsOnInsertion = true
        self.textAlignment = .left
    }
    func customizeView() {
        //self.backgroundColor = UIColor.white
        //self.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        self.textColor = UIColor.black
        //self.backgroundColor = UIColor.white
        self.isScrollEnabled = false
        self.clearsOnInsertion = true
        self.textAlignment = .left
    }
}
