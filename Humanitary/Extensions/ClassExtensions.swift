//
//  ClassExtensions.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/7/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField, UITextFieldDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSeperatorandLabel()
        delegate = self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        setupSeperatorandLabel()
    }
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    let smallLabel: UILabel = {
        let label = UILabel()
        label.text = "LINK"
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    func setSeperator(width: CGFloat) {
        seperator.anchor(top: nil, left: nil, bottom: self.bottomAnchor, right: nil, centerX: self.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: 1)
    }
    func setupSeperatorandLabel() {
        self.addSubview(seperator)
        self.addSubview(smallLabel)
        smallLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: -6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        smallLabel.layer.opacity = 0
        self.addTarget(self, action: #selector(appendLabel), for: .allEditingEvents)
        self.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        seperator.layer.opacity = 0.25
    }
    
    
    var animationHasShown = false
    @objc func appendLabel() {
        let textCount = self.text?.characters.count ?? 0 > 0
        if textCount {
            if animationHasShown == false {
                fadeInLabel(label: smallLabel)
                animationHasShown = true
            }
        } else {
            fadeOutLabel(label: smallLabel)
            animationHasShown = false
        }
    }
    func setLabelText(text: String) {
        smallLabel.text = text
    }
    func setLabelSize(size: CGFloat) {
        smallLabel.font = UIFont.systemFont(ofSize: size)
    }
    func changeColor() {
        seperator.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        seperator.layer.opacity = 1
    }
    func normalColor() {
        seperator.backgroundColor = UIColor.lightGray
        seperator.layer.opacity = 0.25
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeColor()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        normalColor()
    }
}

