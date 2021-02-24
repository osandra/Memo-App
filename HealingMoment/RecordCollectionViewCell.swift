//
//  RecordCollectionViewCell.swift
//  healingStation
//
//  Created by heawon on 2021/02/16.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recordPhoto: UIImageView!
    @IBOutlet weak var recordTitle: UILabel!
    var getBackgroundColor: UIColor = UIColor.white
    @IBOutlet weak var ratingNum: UIButton!
    static let identifier = "RecordCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10 //셀 모서리
        self.backgroundColor = getBackgroundColor
    }
}
