//
//  RatingControl.swift
//  healingMoments
//
//  Created by heawon on 2021/02/14.
//

import UIKit
 
protocol GetRatingNumberProtocol {
    func sendRatingValue(value: Int)
}

class RatingControl: UIStackView {
    var delegate: GetRatingNumberProtocol?

    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtons()
        }
    }
    //스토리보드에서도 설정할 수 있게 IBInspectable
    @IBInspectable var ratingSize: CGSize = CGSize(width: 44, height: 44) {
        didSet { //사이즈 변경되면 다시 그리기
            setButtons()
        }
    }
    @IBInspectable var ratingCount: Int = 5 {
        didSet {
            setButtons()
        }
    }
    
    //programatically initializing the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtons()
    }
    // 스토리보드로 부터 뷰 로딩하기
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setButtons()
    }

    private func setButtons(){
        //rating 수나 사이즈가 바뀌면 기존 버튼 모두 다 제거하고 다시 생성
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //버튼 이미지 로드하기
        let bundle = Bundle(for: RatingControl.self)
        let filledRating = UIImage(named: "filledClover", in: bundle, compatibleWith: self.traitCollection)
        let emptyRating = UIImage(named: "emptyClover", in: bundle, compatibleWith: self.traitCollection)
        let highlightedRating = UIImage(named: "highlightClover", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<ratingCount {
            let button = UIButton()
            button.setImage(emptyRating, for: .normal)
            button.setImage(filledRating, for: .selected)
            button.setImage(highlightedRating, for: .highlighted)
            
            //이미 2를 선택한 상태에서 1을 선택할 경우에도 .highlighted로 보여주기 위해
            button.setImage(highlightedRating, for: [.highlighted, .selected])

            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button) //스택뷰에 추가
            ratingButtons.append(button)
        }
        updateButtons()
    }
    private func updateButtons(){
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating //유저가 4클릭해서 별점이 4이면
            //0부터 3까지 총 4개 버튼 isSelected상태로
        }
        self.delegate?.sendRatingValue(value: rating)
    }
    @objc func ratingButtonTapped(button: UIButton){
        //버튼을 담고 있는 배열에서 누른 버튼의 인덱스 찾기.
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        rating = index + 1
    }
}
