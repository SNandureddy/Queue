//
//  SearchResultCell.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    // MARK:- IBOutlet
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var cinemaNameLabel: UILabel!
    @IBOutlet weak var cinemaAdressLabel: UILabel!
    @IBOutlet weak var telephoneNumberLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    // MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
