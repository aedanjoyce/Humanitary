//
//  SearchController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 11/9/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
protocol SearchDelegate {
    func refresh()
    func pushToUserProfile(user: Userr)
    func pushToStoryPlaceController(place: GMSPlace)
}

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, SearchDelegate  {
    func pushToStoryPlaceController(place: GMSPlace) {
        let storyController = StoriesByPlaceController(collectionViewLayout: UICollectionViewFlowLayout())
        storyController.gmsPlace = place
        navigationController?.pushViewController(storyController, animated: true)
    }
    
    func pushToUserProfile(user: Userr) {
        let profile = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        profile.userId = user.uid
        navigationController?.pushViewController(profile, animated: true)
    }
    
    func refresh() {
        self.collectionView?.reloadData()
    }
    
    var messagesController: MessagesController?
    var filteredUsers = [Userr]()
    var users = [Userr]()
    var searchResultsController: UserResultsController?
    var posts = [LocationPost]()
    var gmsPlacesClient: GMSPlacesClient?
    private let searchCellId = "searchCellId"
    private let headerId = "headerId"
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        collectionView?.backgroundColor = UIColor.white
        navigationItem.title = "Explore"
        collectionView?.alwaysBounceVertical = true
        view.backgroundColor = UIColor.lightGray
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: searchCellId)
        collectionView?.register(PopularHeaderAlternate.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "location"), style: .plain, target: self, action: #selector(locationSearch))
        configureSearchBar()
        fetchUsers()
        fetchPosts()
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    @objc func locationSearch() {
        let locationSearch = LocationSearchController()
        let nav = UINavigationController(rootViewController: locationSearch)
        locationSearch.delegate = self
        self.present(nav, animated: true, completion: nil)
    }
    func configureSearchBar() {
        let resultsController = SearchResultsController()
        resultsController.controller = self
        resultsController.delegate = self
        let searchController = UISearchController(searchResultsController: resultsController)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search for people and friends"
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.white
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        definesPresentationContext = true
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        filteredUsers = self.users.filter { (user) -> Bool in
            return user.username.lowercased().contains(searchTerm.lowercased())
        }
        if let resultsController = searchController.searchResultsController as? SearchResultsController {
            resultsController.filteredUsers = self.filteredUsers
            UIView.transition(with: resultsController.tableView, duration: 0.1, options: .transitionCrossDissolve , animations: {resultsController.tableView.reloadData()}, completion: nil)
            resultsController.tableView.reloadData()
        }
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
    fileprivate func fetchPosts() {
        let ref = Database.database().reference().child("location")
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let post = LocationPost(dictionary: dictionary)
            if post.location != "Add Location" {
             if self.posts.count != 10 {
                self.posts.append(post)
            } else if self.posts.count == 10 {
                self.posts.remove(at: 9)
                self.posts.append(post)
            }
            }
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellId, for: indexPath) as! SearchCell
        cell.numberLabel.text = String(describing: indexPath.row + 1)
        cell.post = posts[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 55)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PopularHeaderAlternate
        if indexPath.section == 0 {
        header.titleLabel.text = "What's New"
        } else {
        header.titleLabel.text = "People you may know"
        }
        header.backgroundColor = UIColor.white
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placeController = StoriesByPlaceController(collectionViewLayout: UICollectionViewFlowLayout())
        let placeId = posts[indexPath.item].placeId
        print("PlaceId", placeId)
        GMSPlacesClient.shared().lookUpPlaceID(placeId, callback: { (gmsPlace, err) in
                if let err = err {
                    print(err)
                    return
                }
                  guard let place = gmsPlace else {return}
                  print("UESSSs")
                  print("Found Place", place.placeID)
                  placeController.gmsPlace = place
            DispatchQueue.main.async {
                self.pushToStoryPlaceController(place: place)
            }
                
            })
        }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


