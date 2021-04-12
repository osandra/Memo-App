//
//  EmptyView.swift
//  HealingMoment
//
//  Created by heawon on 2021/04/12.
//

import UIKit

class EmptyView: UIView {
    var guideText: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
        addSubview(guideLabel)
    }
    
    convenience init(guideText text: String) {
        self.init(frame: CGRect.zero)
        guideText = text
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = width/3
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 50, width: imageSize, height: imageSize)
        guideLabel.sizeToFit()
        guideLabel.frame = CGRect(x: (width-guideLabel.width)/2, y: imageView.bottom+40, width: guideLabel.width, height: 50)
        guideLabel.text = guideText
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "filledClover")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var guideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.MyFont.SpoqeMedium(customSize: 16)
        label.textAlignment = .center
        label.text = "카테고리를 추가해주세요."
        label.textColor = .label
        return label
    }()
  
}

