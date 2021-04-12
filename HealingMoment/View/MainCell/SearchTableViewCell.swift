//
//  SearchTableViewCell.swift
//  HealingMoment
//
//  Created by heawon on 2021/02/23.
//

import UIKit
class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchCell"
    
    let ratingView: UIView = UIView.defaultView()
    let wordContrainerView: UIView = UIView.defaultView()
    let imageContrainerView: UIView = UIView.defaultView()
    
    var titleLabel: UILabel = UILabel.makeMediumLabel(fontSize: 15)
    var ratingLabel: UILabel = UILabel.makeMediumLabel(fontSize: 13)
    
    var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont.MyFont.SpoqeMedium(customSize: 11)
        textView.textAlignment = .left
        return textView
    }()
    
    func setPropety(){
        titleLabel.textAlignment = .left
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = .black
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 13)
        ratingLabel.textColor = UIColor(red: 0.00, green: 0.35, blue: 0.41, alpha: 1.00)
    }
    
    var recordImage: UIImageView = {
        var image = UIImage(data: DefaultData.defaultData!)
        var imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var clovarImage: UIImageView = {
        var image = UIImage(named: "filledClover")
        var imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setPropety()
        imageContrainerView.center.y = contentView.center.y
        imageContrainerView.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        ratingView.frame = CGRect(x: 0, y: imageContrainerView.height - 30, width: 30, height: 30)
        ratingLabel.frame = CGRect(x: 0, y: -3, width: 30, height: 30)
        clovarImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        recordImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
       
        wordContrainerView.center.y = contentView.center.y
        let wordWidth = UIScreen.main.bounds.width-imageContrainerView.width-30
        wordContrainerView.frame = CGRect(x: recordImage.right+20, y: contentView.top+10, width: wordWidth, height: 100)
        titleLabel.frame = CGRect(x: 5, y: 0, width: wordWidth, height: 30)
        descriptionTextView.frame = CGRect(x: 0, y: 30, width: wordWidth, height: 70)
    
        ratingView.addSubview(clovarImage)
        ratingView.addSubview(ratingLabel)
        imageContrainerView.addSubview(recordImage)
        imageContrainerView.addSubview(ratingView)
        self.contentView.addSubview(imageContrainerView)
        wordContrainerView.addSubview(titleLabel)
        wordContrainerView.addSubview(descriptionTextView)
        self.contentView.addSubview(wordContrainerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
