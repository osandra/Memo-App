//
//  HomeCategoryCollectionViewCell.swift
//  healingStation
//
//  Created by heawon on 2021/02/11.
//

import UIKit

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var cartegoryBtnColor: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    static let identifier = "HomeCategoryCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 20 //셀 모서리 둥글게 설정
        
        //deleButton에 그림자 주기
        deleteButton.layer.shadowColor = UIColor.gray.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        deleteButton.layer.shadowRadius = 1.0
        deleteButton.layer.shadowOpacity = 0.2
    }
}
