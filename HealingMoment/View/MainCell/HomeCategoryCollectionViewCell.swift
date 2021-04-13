//
//  HomeCategoryCollectionViewCell.swift
//  healingStation
//
//  Created by heawon on 2021/02/11.
//

import UIKit

protocol HomeCategoryCollectionViewCellDelegate: AnyObject{
    func HomeCategoryCollectionViewCellDidTapImage(_ cell: HomeCategoryCollectionViewCell)
}

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCategoryCollectionViewCell"
    weak var delegate: HomeCategoryCollectionViewCellDelegate?
    public let categoryName: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.MyFont.SpoqeRegular(customSize: 22)
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    public let moreimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "more")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
        imageView.layer.shadowRadius = 1.0
        imageView.layer.shadowOpacity = 0.2
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20

        contentView.addSubview(categoryName)
        contentView.addSubview(moreimageView)
        
        moreimageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        moreimageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        categoryName.sizeToFit()
        categoryName.frame = CGRect(x: 10, y: 10, width: categoryName.width, height: 30)
        moreimageView.frame = CGRect(x: contentView.right-45, y: 10, width: 30, height: 35)

    }
    
    @objc func didTapImage(){
        delegate?.HomeCategoryCollectionViewCellDidTapImage(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryName.text = nil
        self.layer.backgroundColor = nil
    }
    public func configure(with viewModel: HomeCategoryCollectionViewCellViewModel){
        self.layer.backgroundColor = UIViewController.returnColor(name: viewModel.buttonColorName).cgColor
        categoryName.text = viewModel.name
        moreimageView.tag = viewModel.tag //tag를 통해 해당 카테고리 추후 삭제
    }
}
