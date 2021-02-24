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
    var descriptionLabel: UILabel = UILabel.makeMediumLabel(fontSize: 11)
    var ratingLabel: UILabel = UILabel.makeMediumLabel(fontSize: 13)

    func setPropety(){
        titleLabel.textAlignment = .left
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        
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
        
        imageContrainerView.addSubview(recordImage)
        ratingView.addSubview(clovarImage)
        ratingView.addSubview(ratingLabel)
        imageContrainerView.addSubview(ratingView)
        self.contentView.addSubview(imageContrainerView)
        
        wordContrainerView.addSubview(titleLabel)
        wordContrainerView.addSubview(descriptionLabel)
        self.contentView.addSubview(wordContrainerView)
        
        //레이아웃 설정
        NSLayoutConstraint.activate([
   
        imageContrainerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
        imageContrainerView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 10),
        imageContrainerView.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 10),
        imageContrainerView.widthAnchor.constraint(equalToConstant:100),
        imageContrainerView.heightAnchor.constraint(equalToConstant:100),
            
        ratingView.bottomAnchor.constraint(equalTo:self.imageContrainerView.bottomAnchor),
        ratingView.leadingAnchor.constraint(equalTo: self.imageContrainerView.leadingAnchor),
        ratingView.widthAnchor.constraint(equalToConstant:30),
        ratingView.heightAnchor.constraint(equalToConstant:30),
            
        ratingLabel.leadingAnchor.constraint(equalTo:self.ratingView.leadingAnchor),
        ratingLabel.trailingAnchor.constraint(equalTo:self.ratingView.trailingAnchor),
        ratingLabel.topAnchor.constraint(equalTo:self.ratingView.topAnchor, constant: -3),
        ratingLabel.bottomAnchor.constraint(equalTo:self.ratingView.bottomAnchor),
            
        clovarImage.leadingAnchor.constraint(equalTo:self.ratingView.leadingAnchor),
        clovarImage.trailingAnchor.constraint(equalTo:self.ratingView.trailingAnchor),
        clovarImage.topAnchor.constraint(equalTo:self.ratingView.topAnchor),
        clovarImage.bottomAnchor.constraint(equalTo:self.ratingView.bottomAnchor),
         
        recordImage.leadingAnchor.constraint(equalTo:self.imageContrainerView.leadingAnchor),
        recordImage.trailingAnchor.constraint(equalTo:self.imageContrainerView.trailingAnchor),
        recordImage.topAnchor.constraint(equalTo:self.imageContrainerView.topAnchor),
        recordImage.bottomAnchor.constraint(equalTo:self.imageContrainerView.bottomAnchor),
            
        wordContrainerView.leadingAnchor.constraint(equalTo:self.recordImage.trailingAnchor, constant: 20),
        wordContrainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
        wordContrainerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10),
        wordContrainerView.heightAnchor.constraint(equalToConstant:100),
 
        titleLabel.topAnchor.constraint(equalTo:self.wordContrainerView.topAnchor),
        titleLabel.leadingAnchor.constraint(equalTo:self.wordContrainerView.leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo:self.wordContrainerView.trailingAnchor),
        titleLabel.heightAnchor.constraint(equalToConstant: 30),

        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor),
        descriptionLabel.leadingAnchor.constraint(equalTo:self.wordContrainerView.leadingAnchor),
        descriptionLabel.trailingAnchor.constraint(equalTo:self.wordContrainerView.trailingAnchor),
        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.wordContrainerView.bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
