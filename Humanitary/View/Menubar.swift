//
//  Menubar.swift
//  Humanitary
//
//  Created by Aedan Joyce on 9/29/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit

class Menubar: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private let cellId = "cellId"
    let sectionNames = ["NEWS", "FOLLOWING"]
    var viewManager: ViewManager?
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(collectionView)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addContraintsWithFormatView("H:|[v0]|", views: collectionView)
        addContraintsWithFormatView("V:|[v0]|", views: collectionView)
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        setupHorizontalBar()
    }
    let seperator: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0.5
        return view
    }()
    var hbLeftConstraint: NSLayoutConstraint?
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        hbLeftConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        hbLeftConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        addSubview(seperator)
        seperator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewManager?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.backgroundColor = UIColor.white
        cell.titleView.text = sectionNames[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class MenuCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            titleView.textColor = isHighlighted ? UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0) : UIColor.lightGray
            
        }
    }
    override var isSelected: Bool {
        didSet {
            titleView.textColor = isSelected ? UIColor(red:0.39, green:0.65, blue:1.00, alpha:1.0) : UIColor.lightGray
        }
    }
    var titleView: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = UIColor.lightGray
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        addSubview(titleView)
        titleView.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
extension UICollectionViewCell {
func addContraintsWithFormat(_ format: String, views: UIView...) {
    var viewDict = [String: UIView]()
    
    for (index, view) in views.enumerated() {
        let key = "v\(index)"
        view.translatesAutoresizingMaskIntoConstraints = false
        viewDict[key] = view
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
}
}
extension UIView {
    func addContraintsWithFormatView(_ format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}

