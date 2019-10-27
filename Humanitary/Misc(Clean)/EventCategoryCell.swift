//
//  EventCategoryCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 9/29/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import UIKit

class EventCategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private let cellId = "cellId"
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupViews()
    }
    func setupViews() {
        addSubview(eventCollectionView)
        eventCollectionView.register(PopularCell.self, forCellWithReuseIdentifier: cellId)
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        eventCollectionView.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: frame.height)
    }
    let eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PopularCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 20, height: frame.height-20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(eventCollectionView.contentOffset.x + (self.eventCollectionView.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<eventCollectionView.visibleCells.count {
            let cell = eventCollectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = eventCollectionView.indexPath(for: cell)!.row
            }
            eventCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        }
        if closestCellIndex != -1 {
            self.eventCollectionView.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell()
        }
    }
}

class PopularCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Irma"))
        //imageView.backgroundColor = UIColor.red
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Problems in Puerto Rico"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 2
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
        backgroundColor = UIColor.yellow
    
        addSubview(imageView)
        imageView.addSubview(titleLabel)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: frame.height)
        titleLabel.anchor(top: nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0, paddingLeft: 6, paddingBottom: -12, paddingRight: 0, width: imageView.frame.width, height: 0)
    }
}
