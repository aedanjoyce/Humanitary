//
//  LoginController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/7/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
        return label
    }()
    let emailField: BorderedTextField = {
        let field = BorderedTextField()
        field.placeholder = "Email"
        field.setLabelText(text: "EMAIL")
        field.textAlignment = .left
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()
    let passwordField: BorderedTextField = {
        let field = BorderedTextField()
        field.placeholder = "Password"
        field.setLabelText(text: "PASSWORD")
        field.textAlignment = .left
        field.isSecureTextEntry = true
        return field
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        button.tintColor = UIColor.white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.layer.opacity = 0.5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
    }
    func setupViews() {
        emailField.becomeFirstResponder()
        hideKeyboardWithOutsideTouch()
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(titleLabel)
        let constant: CGFloat = 100
        emailField.setSeperator(width: view.frame.width - constant)
        emailField.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - constant, height: 50)
        passwordField.setSeperator(width: view.frame.width - constant)
        passwordField.anchor(top: emailField.bottomAnchor, left: emailField.leftAnchor, bottom: nil, right: emailField.rightAnchor, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: emailField.frame.width, height: 50)
        view.addSubview(loginButton)
       
        emailField.addTarget(self, action: #selector(changeButtonColor), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(changeButtonColor), for: .editingChanged)
        if UIScreen.main.bounds.height < 500 {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            loginButton.anchor(top: passwordField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - constant, height: 30)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        } else {
             loginButton.anchor(top: passwordField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - constant, height: 50)
            
                    titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        }
    }
    
    @objc func handleSignIn() {
        print("called")
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("Failed sign in", err)
                guard let errorCode = AuthErrorCode(rawValue: err._code) else {return}
                switch errorCode {
                case .invalidEmail:
                    break
                case .wrongPassword:
                   break
                case .userDisabled:
                    break
                case .userNotFound:
                    break
                default: break
                }
                return
            }
            print("Successfully logged in user", user?.uid ?? "")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
            mainTabBarController.setupControllers()
            self.dismiss(animated: true, completion: nil)
            self.modalTransitionStyle = .crossDissolve
        }
    }
    
    @objc func changeButtonColor() {
        let isFormValid = emailField.text?.characters.count ?? 0 > 0 && passwordField.text?.characters.count ?? 0 > 0
        if isFormValid {
              loginButton.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
              loginButton.tintColor = UIColor.white
              loginButton.layer.opacity = 1
              loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
            loginButton.tintColor = UIColor.white
            loginButton.layer.opacity = 0.5
            loginButton.isEnabled = false
        }
    }
}




