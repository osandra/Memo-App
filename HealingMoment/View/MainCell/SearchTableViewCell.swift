//
//  SearchTableViewCell.swift
//  HealingMoment
//
//  Created by heawon on 2021/02/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchCell"

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.MyFont.SpoqeMedium(customSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.MyFont.SpoqeMedium(customSize: 13)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont.MyFont.SpoqeMedium(customSize: 11)
        textView.textAlignment = .left
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.contentInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        return textView
    }()
    
    var recordImage: UIImageView = {
        var image = UIImage(data: DefaultData.defaultData!)
        var imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var clovarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.MyColor.lightBeige
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(clovarImage)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(recordImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionTextView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let ratingSize: CGFloat = 24
        ratingLabel.frame = CGRect(x: width-24-10, y: 15, width: ratingSize, height: ratingSize)
        clovarImage.frame = CGRect(x: width-24-10, y: 15, width: ratingSize, height: ratingSize)
        recordImage.frame = CGRect(x: 0, y: 10, width: 110, height: 110)
        clovarImage.layer.cornerRadius = 12
        
        let wordWidth = width - recordImage.width - 24
        titleLabel.frame = CGRect(x: recordImage.right+15, y: 10, width: wordWidth, height: 30)
        descriptionTextView.frame = CGRect(x: recordImage.right+15, y: titleLabel.bottom+10, width: wordWidth, height: 70)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        ratingLabel.text = nil
        descriptionTextView.text = nil
        recordImage.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public func configure(with viewmodel: SearchTableViewCellViewModel){
        titleLabel.text = viewmodel.title
        descriptionTextView.text = viewmodel.description
        ratingLabel.text = viewmodel.ratingText
        recordImage.image = viewmodel.image
    }
}
