//
//  MoviesCell.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {

    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  setupCollectionView(delegate: UICollectionViewDelegate & UICollectionViewDataSource , forRow row : Int) {
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = delegate
        self.collectionView.tag = row
        self.collectionView.reloadData()
    }
}
