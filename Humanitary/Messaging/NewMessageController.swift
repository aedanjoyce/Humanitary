//
//  NewMessageController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/17/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        filteredUsers = self.users.filter { (user) -> Bool in
            return user.username.lowercased().contains(searchTerm.lowercased())
        }
        if let resultsController = searchController.searchResultsController as? UserResultsController {
            resultsController.filteredUsers = self.filteredUsers
            UIView.transition(with: resultsController.tableView, duration: 0.1, options: .transitionCrossDissolve , animations: {resultsController.tableView.reloadData()}, completion: nil)
            resultsController.tableView.reloadData()
        }
    }
    var messagesController: MessagesController?
    var filteredUsers = [Userr]()
    var users = [Userr]()
    var searchResultsController: UserResultsController?
    private let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.title = "New Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        configureSearchBar()
        fetchUsers()
    }
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    func callRootPushForUser(user: Userr) {
        dismiss(animated: true) {
            self.messagesController?.showChatController(user: user)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    fileprivate func fetchUsers() {
        print("Fetching users..")
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                if key == Auth.auth().currentUser?.uid {
                    print("Found myself, omit from list")
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = Userr(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                
                return u1.username.compare(u2.username) == .orderedAscending
                
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
    }
    func configureSearchBar() {
        let resultsController = UserResultsController()
        resultsController.newMessageController = self
        let searchController = UISearchController(searchResultsController: resultsController)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search for people and friends"
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    
    
}
