//
//  SettingsController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 2/8/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class SettingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    private let headerId = "headerId"
    var user: Userr?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(SettingsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        navigationItem.title = "Settings"
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        
        if indexPath.section == 0 {
            cell.cellLabel.text = "Privacy Policy"
        } else {
            if indexPath.item == 0 {
            if let username = self.user?.username {
            cell.cellLabel.text = "Logout " + username
            cell.cellLabel.textColor = UIColor.humanitaryBlue
            }
            }
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SettingsHeader
        if indexPath.section == 0 {
            header.titleHeader.text = "Privacy"
        } else {
            header.titleHeader.text = "Account"
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 35)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.item == 0 {self.handleLogOut()}
        }
    }
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                let loginController = OnboardController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
class SettingsHeader: UICollectionViewCell {
    let titleHeader: UILabel = {
        let label = UILabel()
        label.tintColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(titleHeader)
        titleHeader.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SettingsCell: UICollectionViewCell {
    let cellLabel: UILabel = {
        let button = UILabel()
        button.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(cellLabel)
        cellLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSeperator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
