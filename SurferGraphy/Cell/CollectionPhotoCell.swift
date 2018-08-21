//
//  CollectionPhotoCell.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 21..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit
import M13Checkbox

class CollectionPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var checkBoxView: UIView!
    
    var checkBox: M13Checkbox?
    
}
