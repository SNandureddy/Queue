//
//  TimingDetailsCell.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class TimingDetailsCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cinemaNameLabel: UILabel!
    @IBOutlet weak var showTimingCollectionView: UICollectionView!
    @IBOutlet weak var timingCollectionViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        bookNowButton.set(radius: 5.0)
    }

    func  setupCollectionView(delegate: UICollectionViewDelegate & UICollectionViewDataSource , forRow row : Int) {
        self.showTimingCollectionView.delegate = delegate
        self.showTimingCollectionView.dataSource = delegate
        self.showTimingCollectionView.tag = row
        self.showTimingCollectionView.reloadData()
    }
}
