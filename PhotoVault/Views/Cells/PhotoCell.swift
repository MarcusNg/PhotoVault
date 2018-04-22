//
//  PhotoCell.swift
//  PhotoVault
//
//  Created by Marcus Ng on 4/22/18.
//  Copyright © 2018 Marcus Ng. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(imageData: Data) {
        imageView.image = UIImage(data: imageData, scale: 1.0)
    }
    
}
