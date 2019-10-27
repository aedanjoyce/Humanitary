//
//  SignUpController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/7/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let userPhotoView: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "Photo"), for: .normal)
        //view.backgroundColor = UIColor.red
        view.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    @objc func handlePhoto() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            userPhotoView.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            userPhotoView.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        userPhotoView.layer.cornerRadius = userPhotoView.frame.width / 2
        userPhotoView.layer.masksToBounds = true
        dismiss(animated: true, completion: nil)
    }
    let nameField: BorderedTextField = {
        let field = BorderedTextField()
        field.placeholder = "Full Name"
        field.addTarget(self, action: #selector(handleSignUpColor), for: .editingChanged)
        field.setLabelText(text: "FULL NAME")
        return field
    }()
    let emailField: BorderedTextField = {
        let field = BorderedTextField()
        field.placeholder = "Email"
        field.keyboardType = .emailAddress
        field.autocorrectionType = .yes
        field.autocapitalizationType = .none
        field.returnKeyType = .next
        field.setLabelText(text: "EMAIL")
        field.addTarget(self, action: #selector(handleSignUpColor), for: .editingChanged)
        return field
    }()
    let passwordField: BorderedTextField = {
        let field = BorderedTextField()
        field.placeholder = "Password"
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(handleSignUpColor), for: .editingChanged)
        field.isSecureTextEntry = true
        field.setLabelText(text: "PASSWORD")
        return field
    }()
    let signUpButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha: 0.7)
        button.layer.opacity = 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        button.tintColor = UIColor.white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sign Up"
        hideKeyboardWithOutsideTouch()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        view.backgroundColor = UIColor.white
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.tintColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        view.addSubview(userPhotoView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        nameField.setSeperator(width: view.frame.width - 100)
        emailField.setSeperator(width: view.frame.width - 100)
        passwordField.setSeperator(width: view.frame.width - 100)
        
        if UIScreen.main.bounds.height < 500 {
        userPhotoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
            nameField.anchor(top: userPhotoView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 15, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 30)
            changeConstraints(field: nameField, height: 12)
            changeConstraints(field: emailField, height: 12)
            changeConstraints(field: passwordField, height: 12)
            emailField.anchor(top: nameField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 30)
            
            passwordField.anchor(top: emailField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 30)
            signUpButton.anchor(top: passwordField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 30)
            signUpButton.layer.cornerRadius = 5
            signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        } else {
            userPhotoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
            nameField.anchor(top: userPhotoView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 15, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 50)
            emailField.anchor(top: nameField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 50)
            passwordField.anchor(top: emailField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 50)
            signUpButton.anchor(top: passwordField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 100, height: 50)
            signUpButton.layer.cornerRadius = 5
        }
    }
    func changeConstraints(field: BorderedTextField, height: CGFloat) {
        field.font = UIFont.systemFont(ofSize: height)
        field.setLabelSize(size: height)
        field.setLabelText(text: "")
        field.autocorrectionType = .no
    }
    @objc func createUser() {
        signUpButton.showLoading()
        guard let username = nameField.text, username.count > 0 else {return}
        guard let email = emailField.text, email.count > 0 else {return}
        guard let password = passwordField.text, password.count > 0 else {return}
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error: Error?) in
            if let err = error {
                self.signUpButton.hideLoading()
                print("Failed to create user:", err)
                guard let errorCode = AuthErrorCode(rawValue: err._code) else {return}
                switch errorCode {
                case .invalidEmail: break
                case .weakPassword: break
                case .emailAlreadyInUse: break
                default: break
                }
                return
            }
            print("Successfully created user", user?.uid ?? "")
            self.signUpButton.hideLoading()
            guard let image = self.userPhotoView.imageView?.image else {return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
            let fileName = NSUUID().uuidString
            
            Storage.storage().reference().child("profile_image").child(fileName).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image", err)
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
                print("Successfully uploaded profile image:", profileImageUrl)
                guard let uid = user?.uid else {return}
                guard let fcmToken = Messaging.messaging().fcmToken else {return}
                let dictionaryValues = ["username":username, "profileImageUrl": profileImageUrl, "email": email, "fcmToken": fcmToken]
                let values = [uid: dictionaryValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to save user info", err)
                        return
                    }
                    
                    print("Successfully saved user info")
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
                    mainTabBarController.setupControllers()
                    self.dismiss(animated: true, completion: nil)
                    self.modalTransitionStyle = .crossDissolve
                })
            })
            
        })
    }
    
    @objc func handleSignUpColor() {
        let isFormValid = nameField.text?.characters.count ?? 0 > 0 && emailField.text?.characters.count ?? 0 > 0 && passwordField.text?.characters.count ?? 0 > 0
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
            signUpButton.layer.opacity = 1
            signUpButton.tintColor = UIColor.white
            
        } else {
            signUpButton.isEnabled = false
            signUpButton.tintColor = UIColor.white
            signUpButton.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha: 0.7)
            signUpButton.layer.opacity = 0.5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameField.isFirstResponder == true {
            nameField.resignFirstResponder()
            emailField.becomeFirstResponder()
        } else if emailField.isFirstResponder == true {
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if passwordField.isFirstResponder == true {
            passwordField.resignFirstResponder()
        }
        return true
    }
}

