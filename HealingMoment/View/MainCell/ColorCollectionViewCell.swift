//
//  ColorCollectionViewCell.swift
//  healingStation
//
//  Created by heawon on 2021/02/11.
//

import UIKit
import Foundation

class ColorCollectionViewCell: UICollectionViewCell {
    static let identifier = "ColorCollectionCell"
    @IBOutlet weak var colorButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        
    }
}

