//
//  ChatMessageCell.swift
//  Humanitary
//
//  Created by Aedan Joyce on 1/19/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import Firebase

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
       let view = UITextView()
        view.text = "Sample For Now"
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.humanitaryBlue
        addSubview(textView)
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
