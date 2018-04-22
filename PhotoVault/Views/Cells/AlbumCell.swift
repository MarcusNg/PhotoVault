//
//  AlbumCell.swift
//  PhotoVault
//
//  Created by Marcus Ng on 4/22/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var photoCountLbl: UILabel!
    
    func configure(title: String, photoCount: Int) {
        titleLbl.text = title
        photoCountLbl.text = "\(photoCount) photos"
    }

}
