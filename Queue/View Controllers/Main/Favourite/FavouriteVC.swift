//
//  FavouriteVC.swift
//  Queue
//
//  Created by ios2 on 27/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class FavouriteVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.set(title: kEmptyString)
    }

}


//MARK: - UITableViewDataSource
extension FavouriteVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kFavouriteMoieCell) as! FavouriteMoieCell
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FavouriteVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: kMovieDetailsVC) as! MovieDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
