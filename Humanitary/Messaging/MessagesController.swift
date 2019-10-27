//
//  MessagesController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/3/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    private let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        navigationItem.title = "Messages"
        tableView.register(MessagesCell.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(newMessage))
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
    }
    func showChatController(user: Userr) {
        let chat = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chat.user = user
        chat.navigationItem.title = user.username
        navigationController?.pushViewController(chat, animated: true)
    }
    @objc func newMessage() {
        let search = NewMessageController(collectionViewLayout: UICollectionViewFlowLayout())
        search.messagesController = self
        let nav = UINavigationController(rootViewController: search)
        present(nav, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessagesCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {return}
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = Userr(uid: chatPartnerId, dictionary: dictionary)
            self.showChatController(user: user)
        }, withCancel: nil)
    }
    

func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    //self.messages.append(message)
                    if let toId = message.toId {
                        self.messagesDictionary[toId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            
                            return message1.timeStamp?.int32Value > message2.timeStamp?.int32Value
                        })
                        
                        //this will crash because of background thread, so lets call this on dispatch_async main thread
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
}

    
    
    
//    @objc func observeMessages() {
//        let ref = Database.database().reference().child("messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
//            let message = Message()
//            message.setValuesForKeys(dictionary)
//            //self.messages.append(message)
//            if let toId = message.toId {
//                self.messagesDictionary[toId] = message
//                self.messages = Array(self.messagesDictionary.values)
//                self.messages.sort(by: { (m1, m2) -> Bool in
//                    return m1.timeStamp?.intValue > m2.timeStamp?.intValue
//                })
//            }
//            DispatchQueue.main.async {
//            self.tableView.reloadData()
//            }
//        }, withCancel: nil)
//    }
//}
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

