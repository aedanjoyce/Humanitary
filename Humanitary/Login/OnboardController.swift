//
//  LoginController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/7/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
class OnboardController: UIViewController {
    let imageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Humanitary"
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        return label
    }()
    let emailTextField: UITextField = {
       let field = UITextField()
        field.placeholder = "Email"
        field.layer.borderColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 4
        field.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        field.autocapitalizationType = .none
        return field
    }()
    let passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.layer.borderColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 4
        field.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        return field
    }()
    let loginButton: LoadingButton = {
       let button = LoadingButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha: 0.7)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        button.titleLabel?.textColor = UIColor.white
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 2
        //button.layer.shadowColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0).cgColor
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0
        button.isEnabled = false
        return button
    }()
    let forgotPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        button.titleLabel?.textColor = UIColor(red:0.80, green:0.80, blue:0.83, alpha:1.0)
        button.tintColor = UIColor(red:0.80, green:0.80, blue:0.83, alpha:1.0)
        button.titleLabel?.textAlignment = .right
        return button
    }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create an Account", for: .normal)
        button.backgroundColor =  UIColor.white
        button.titleLabel?.textColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        button.tintColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    let errorLabel: UILabel = {
       let label = UILabel()
       label.text = "Incorrect email/password"
       label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
       label.layer.opacity = 0
       return label
    }()
    let aiView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
    }
    var constant: CGFloat = 60
    func setupViews() {
        navigationController?.navigationBar.shadowImage = UIImage()
        isHeroEnabled = true
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPassword)
        view.addSubview(signUpButton)
        view.addSubview(errorLabel)
        hideKeyboardWithOutsideTouch()
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 130, height: 130)
        titleLabel.anchor(top: nil, left: imageView.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: imageView.centerYAnchor, paddingTop: 30, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emailTextField.anchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 46, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - constant, height: 60)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - constant, height: 60)
        loginButton.anchor(top: passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: (view.frame.width - constant) / 2, height: 50)
        forgotPassword.anchor(top: passwordTextField.bottomAnchor, left: loginButton.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 12, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: (view.frame.width - constant) / 2, height: 50)
        errorLabel.anchor(top: nil, left: nil, bottom: emailTextField.topAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -6, paddingRight: 0, width: 0, height: 0)
        var orText = UILabel()
        orText.text = "Or"
        orText.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        orText.textColor = UIColor(red:0.80, green:0.80, blue:0.83, alpha:0.8)
        view.addSubview(orText)
        orText.anchor(top: forgotPassword.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 36, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        let seperator1 = UIView()
        view.addSubview(seperator1)
        seperator1.backgroundColor = UIColor(red:0.80, green:0.80, blue:0.83, alpha:0.8)
        seperator1.anchor(top: nil, left: passwordTextField.leftAnchor, bottom: nil, right: orText.leftAnchor, centerX: nil, centerY: orText.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 0, height: 1)
        let seperator2 = UIView()
        view.addSubview(seperator2)
        seperator2.backgroundColor = UIColor(red:0.80, green:0.80, blue:0.83, alpha:0.8)
        seperator2.anchor(top: nil, left: orText.rightAnchor, bottom: nil, right: passwordTextField.rightAnchor, centerX: nil, centerY: orText.centerYAnchor, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        signUpButton.anchor(top: orText.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - constant, height: 50)
        emailTextField.addTarget(self, action: #selector(changeButtonColor), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(changeButtonColor), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(pushSignUp), for: .touchUpInside)
        emailTextField.setLeftPaddingPoints(12)
        passwordTextField.setLeftPaddingPoints(12)
    }
    @objc func pushSignUp() {
        let signUp = SignUpController()
        navigationController?.pushViewController(signUp, animated: true)
    }
    @objc func pushLogin() {
        let login = LoginController()
        navigationController?.pushViewController(login, animated: true)
    }
    @objc func handleSignIn() {
        loginButton.showLoading()
        print("called")
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                self.loginButton.hideLoading()
                print("Failed sign in", err)
                guard let errorCode = AuthErrorCode(rawValue: err._code) else {return}
                switch errorCode {
                case .invalidEmail:
                    self.performIncorrectAnimation()
                    break
                case .wrongPassword:
                    self.performIncorrectAnimation()
                    break
                case .userDisabled:
                    self.performIncorrectAnimation()
                    break
                case .userNotFound:
                    self.performIncorrectAnimation()
                    break
                default: break
                }
                return
            }
            self.loginButton.hideLoading()
            print("Successfully logged in user", user?.uid ?? "")
            self.performLoginAnimation()
        }
    }
    func performIncorrectAnimation() {
        errorLabel.layer.opacity = 0
        let origin = errorLabel.frame.origin.y
        errorLabel.frame.origin.y += 7
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.errorLabel.layer.opacity = 1
            self.errorLabel.frame.origin.y = origin
        }) { (true) in
            UIView.animate(withDuration: 0.4, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.errorLabel.layer.opacity = 0
            }, completion: { (true) in
                return
            })
        }
    }
    
    func performLoginAnimation() {
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
        for (index,view) in view.subviews.enumerated() {
            let delay = 0.075 * Double(index)
            if view != errorLabel {
                view.alpha = 1
            }
            let origin = view.frame.origin.y
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                view.alpha = 0
                view.frame.origin.y -= 15
            }, completion: { (true) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.modalTransitionStyle = .crossDissolve
                    self.dismiss(animated: true, completion: nil)
                })
//                view.alpha = 1
//                view.frame.origin.y = origin
            })
        }
        mainTabBarController.setupControllers()
    }
    @objc func changeButtonColor() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        if isFormValid {
            loginButton.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha: 1.0)
            loginButton.tintColor = UIColor.white
            loginButton.titleLabel?.textColor = UIColor.white
            loginButton.isEnabled = true
            self.loginButton.layer.shadowColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0).cgColor
            self.loginButton.layer.shadowRadius = 4
            self.loginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.loginButton.layer.shadowOpacity = 0.85
        } else {
            loginButton.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha: 0.7)
            //loginButton.tintColor = UIColor.white
            //loginButton.titleLabel?.textColor = UIColor.white
            loginButton.isEnabled = false
            self.loginButton.layer.shadowRadius = 0
            self.loginButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.loginButton.layer.shadowOpacity = 0
        }
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
class LoadingButton: UIButton {
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    func showLoading() {
        //activityIndicator.color = UIColor.white
        //activityIndicator.activityIndicatorViewStyle = .white
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: UIControlState.normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: UIControlState.normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        activityIndicator.activityIndicatorViewStyle = .white
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}


