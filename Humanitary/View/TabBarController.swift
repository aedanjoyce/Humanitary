//
//  TabBarController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 10/13/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//
import UIKit
import Firebase

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        if Auth.auth().currentUser == nil {
            print("auth called")
            DispatchQueue.main.async {
                let loginController = OnboardController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: false, completion: nil)
            }
            return
        }
        setupControllers()
        checkForFcmToken()
    }
    var userId: String?
    //var user: Userr?
    func setupControllers() {
        print("Called")
        let homeController = ViewManager(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNav = UINavigationController(rootViewController: homeController)
        homeNav.tabBarItem.image = UIImage(named: "news")
        
        let profilePage = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let profileNav = UINavigationController(rootViewController: profilePage)
        profileNav.tabBarItem.image = UIImage(named: "user")
       // guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        profilePage.userId = uid
        let searchPage = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNav = UINavigationController(rootViewController: searchPage)
        searchNav.tabBarItem.image = UIImage(named: "search")
        let messages = MessagesController()
        let messageNav = UINavigationController(rootViewController: messages)
        messageNav.tabBarItem.image = UIImage(named: "mail")
        viewControllers = [homeNav, searchNav, profileNav]
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor.humanitaryBlue
        tabBar.unselectedItemTintColor = UIColor(red:0.67, green:0.71, blue:0.75, alpha:1.0)
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor(red:0.83, green:0.84, blue:0.85, alpha:1.0).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        topBorder.opacity = 0.88
        removeTabbarItemsText()
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
        }
    }
    func removeTabbarItemsText() {
        if let items = tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            }
        }
    }
    func checkForFcmToken() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            if user.fcmToken == "" {
                print("nofcmtoken")
                guard let fcmToken = Messaging.messaging().fcmToken else {return}
                let ref = Database.database().reference().child("users").child(uid)
                let values = ["fcmToken": fcmToken]
                ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print(err)
                    }
                    print("Sucessfully assigned an fcm token for user", user.uid)
                })
            } else {
                print("fcmToken found")
            }
        }
    }
}
