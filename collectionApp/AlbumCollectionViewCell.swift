//
//  AlbumCollectionViewCell.swift
//  collectionApp
//
//  Created by mashimac_w on 2017/05/19.
//  Copyright © 2017年 Ryo Mashima. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var albumId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        albumNameLabel.adjustsFontSizeToFitWidth = true
    }

}
