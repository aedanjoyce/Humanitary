//
//  SettingsController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 11/12/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
protocol EditProfileDelegate {
    func launchPhotoController(controller: UIImagePickerController)
    func dismissController()
}
class EditProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, EditProfileDelegate {
    func launchPhotoController(controller: UIImagePickerController) {
        self.present(controller, animated: true, completion: nil)
    }
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    var user: Userr?
    private let headerId = "headerId"
    private let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(EditProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(EditProfileCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(updateInformation))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.title = "Edit Profile"
    }
    @objc func updateInformation() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath) as! EditProfileCell
        guard let username = user?.username else {return}
        guard let titleText = cell.titleTextField.text else {return}
        if cell.titleTextField.text != username {
            print("Info Changed")
            guard let userId = user?.uid else {return}
            let ref = Database.database().reference().child("users").child(userId)
            let values = ["username": titleText]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print(err)
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            print("Nothing changed")
            self.dismiss(animated: true, completion: nil)
        } 
        
    }
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EditProfileHeader
        header.delegate = self
        header.user = self.user
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EditProfileCell
        cell.user = self.user
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "Name"
            cell.titleLabel.textColor = UIColor.black
        default:
            break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
        return CGSize(width: view.frame.width, height: 225)
        }
        return CGSize(width: view.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
class EditProfileHeader: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: EditProfileDelegate?
    var user: Userr? {
        didSet{
            guard let url = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: url)
        }
    }
    let titleContainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let titleHeader: UILabel = {
       let label = UILabel()
        label.tintColor = UIColor.black
        label.text = "Account Information"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return label
    }()
    let profileImageView: CustomImageView = {
        let view = CustomImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change profile picture", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews() {
        backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100/2
        addSubview(profileButton)
        profileButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        profileImageView.clipsToBounds = true
        profileButton.addTarget(self, action: #selector(changeProfilePicture), for: .touchUpInside)
        addSubview(titleContainer)
        titleContainer.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 50)
        titleContainer.addSubview(titleHeader)
        titleHeader.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: titleContainer.centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    @objc func changeProfilePicture() {
        print("called")
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let pickerController = UIImagePickerController()
                    pickerController.delegate = self
                    pickerController.allowsEditing = true
                    self.delegate?.launchPhotoController(controller: pickerController)
                }
            }
    }
    static let updateFeedNotificationName = NSNotification.Name("UpdateFeed")
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = editedImage.withRenderingMode(.alwaysOriginal)
            DispatchQueue.main.async {
                self.changePicture()
            }
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        delegate?.dismissController()
        NotificationCenter.default.post(name: HelpController.updateFeedNotificationName, object: nil)
    }
    func changePicture() {
        guard let image = self.profileImageView.image else {return}
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
        let fileName = NSUUID().uuidString
        
        Storage.storage().reference().child("profile_image").child(fileName).putData(uploadData, metadata: nil, completion: { (metadata, err) in
            if let err = err {
                print("Failed to upload profile image", err)
                return
            }
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
            print("Successfully uploaded profile image:", profileImageUrl)
            guard let uid = self.user?.uid else {return}
            let profileImage = ["profileImageUrl": profileImageUrl]
           // let value = [uid: profileImage]
            
            Database.database().reference().child("users").child(uid).updateChildValues(profileImage, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to update user info", err)
                    return
                }
                print("Successfully updated user info")
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class EditProfileCell: UICollectionViewCell {
    var user: Userr? {
        didSet{
            guard let username = user?.username else {return}
            titleTextField.text = username
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        return label
    }()
    let titleTextField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        field.clearButtonMode = .whileEditing
        return field
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(titleTextField)
        titleTextField.anchor(top: nil, left: titleLabel.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 0)
        addSeperator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UICollectionViewCell {
    func addSeperator() {
        let seperator = UIView()
        seperator.backgroundColor = UIColor.lightGray
        addSubview(seperator)
        seperator.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 1)
        seperator.layer.opacity = 0.10
    }
}
