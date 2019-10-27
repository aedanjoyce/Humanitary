//
//  ChatController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/12/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    var user: Userr? {
        didSet{
            navigationItem.title = user?.username
            observeMessages()
        }
    }
    var messages = [Message]()
    private let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        messagesTextField.inputAccessoryView = containerView
    }
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                let message = Message()
                message.setValuesForKeys(dictionary)
                if message.chatPartnerId() == self.user?.uid {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSubmit()
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    let messagesTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Write a Message..."
        field.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        field.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Send", for: .normal)
        submitButton.setTitleColor(UIColor.humanitaryBlue, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        containerView.addSubview(self.messagesTextField)
        self.messagesTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let lineSeperatorView = UIView()
        lineSeperatorView.backgroundColor = UIColor.lightGray
        containerView.addSubview(lineSeperatorView)
        lineSeperatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        return containerView
    }()
    @objc func handleSubmit() {
    print("pressed")
    let ref = Database.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let toId = user!.uid
        let fromId = Auth.auth().currentUser!.uid
    let timeStamp = Date().timeIntervalSince1970
    let values = ["text": messagesTextField.text ?? "", "toId": toId, "fromId": fromId, "timestamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Problem sending message", err)
                return
            }
        print("Successfully uploaded message")
        
    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
        let messageId = childRef.key
        userMessagesRef.updateChildValues([messageId: 1])
            
            let recepientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recepientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
}


