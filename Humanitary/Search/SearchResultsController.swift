//
//  SearchResultsController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/25/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class SearchResultsController: UITableViewController {
    var delegate: SearchDelegate?
    private let cellId = "cellId"
    var filteredUsers = [Userr]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    var controller: SearchController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        self.dismiss(animated: true) {
            self.delegate?.pushToUserProfile(user: user)
        }
    }
}
