//
//  ViewController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 9/29/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Hero
class ViewManager: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    let globalId = "globalId"
    let localId = "localId"
    //added weak
    weak var localCell: LocalCell?
    weak var globalCell: GlobalCell?
    var userId: String?
    var user: Userr?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    var animationHasShown = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func setupCollectionView() {

        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        collectionView?.reloadData()
        navigationItem.title = "Humanitary"
        setupMenuBar()
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.backgroundColor = UIColor.white
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createStory))
        navigationItem.setRightBarButton(addButton, animated: true)
         collectionView?.register(GlobalCell.self, forCellWithReuseIdentifier: globalId)
         collectionView?.register(LocalCell.self, forCellWithReuseIdentifier: localId)
        collectionView?.isPagingEnabled = true
        navigationController?.navigationBar.shadowImage = UIImage()
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMenuBar()
    }
    lazy var menuBar: Menubar = {
        let mb = Menubar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.viewManager = self
        return mb
    }()
     private func setupMenuBar() {
        view.addSubview(menuBar)
        menuBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let localCell = collectionView.dequeueReusableCell(withReuseIdentifier: localId, for: indexPath) as! LocalCell
            localCell.viewManager = self
            return localCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: globalId, for: indexPath) as! GlobalCell
        cell.viewManager = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func showStoryDetail(post: Post) {
//        let detailView = StoryDetailController(collectionViewLayout: UICollectionViewFlowLayout())
//        detailView.post = post
//        //detailView.navigationItem.title = post.title
//        navigationController?.pushViewController(detailView, animated: true)
        isHeroEnabled = true
        
        let storyManager = StoryManager(collectionViewLayout: UICollectionViewFlowLayout())
        storyManager.post = post
        storyManager.isHeroEnabled = true
        storyManager.heroModalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        present(storyManager, animated: true, completion: nil)
    }
    @objc func createStory() {
//        let story = StoryController()
//        navigationController?.pushViewController(story, animated: true)
//
        
        
        let storyManager = NewStoryController()
        navigationController?.pushViewController(storyManager, animated: true)
    }
}
