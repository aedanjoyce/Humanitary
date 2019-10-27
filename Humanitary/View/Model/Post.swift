//
//  Story.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/1/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import GooglePlaces
struct Post {
    var id: String?
    let user: Userr
    let title: String
    let subTitle: String
    let storyDesciption: String // What is the issue?
    let storyAnalysis: String // What is being done?
    let storyHelpDescription: String // How you can help
    let creationDate: Date
    let donateLink: String
    let location: String
    var hasTapped: Bool = false
    let imageUrl: String
    init(user: Userr, dictionary: [String: Any]){
        self.title = dictionary["title"] as? String ?? ""
        self.subTitle = dictionary["subTitle"] as? String ?? ""
        self.storyDesciption = dictionary["storyDesciption"] as? String ?? ""
        self.storyAnalysis = dictionary["storyAnalysis"] as? String ?? ""
        self.storyHelpDescription = dictionary["storyHelpDescription"] as? String ?? ""
        self.donateLink = dictionary["donateLink"] as? String ?? ""
        self.user = user
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
    }
}
struct LocationPost {
    let location: String
    let placeId: String
    let creationDate: Date
    init(dictionary: [String:Any]) {
        self.location = dictionary["location"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.placeId = dictionary["placeId"] as? String ?? ""
    }
}
struct Userr {
    let uid: String
    let username: String
    let email: String
    let profileImageUrl: String
    var followers: Int?
    var following: Int?
    let fcmToken: String
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fcmToken = dictionary["fcmToken"] as? String ?? ""
    }
}

struct SearchResult {
    let user: Userr
    let place: GMSPlace
}
