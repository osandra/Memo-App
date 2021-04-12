//
//  CustomPopUpViewController.swift
//  HealingMoment
//
//  Created by heawon on 2021/03/05.
//

import UIKit

class CustomPopUpViewController: UIViewController {
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var contentArea: UIButton!
    @IBOutlet weak var delteGuideLabel: UILabel!
    @IBAction func backgroundBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var deleteClosure: (()->Void)?
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let deleteClosureAction = deleteClosure {
            //삭제 버튼 누를 경우 클로저 함수 실행
            deleteClosureAction()
        }
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    func setLayout(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentArea.layer.cornerRadius = 20
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.MyColor.lightGray.cgColor
        
        deleteBtn.layer.cornerRadius = 10
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor = UIColor.MyColor.lightGray.cgColor
        
        delteGuideLabel.textColor = .black
        delteGuideLabel.textAlignment = .center
        deleteLabel.textColor = .black
        deleteLabel.textAlignment = .center
        delteGuideLabel.font = UIFont.MyFont.SpoqeRegular(customSize: 14)
        deleteLabel.font = UIFont.MyFont.SpoqeMedium(customSize: 16)
    }

}
