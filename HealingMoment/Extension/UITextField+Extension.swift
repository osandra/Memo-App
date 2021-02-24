//
//  UITextField+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/17.
//

import UIKit
extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 250))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 14, *) {
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        barButton.tintColor = UIColor(named: "darkmodelabel")
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    //cancel 누르면 키보드 닫기
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    //textfield 칸 안 보이고 밑줄로만 보이게끔
    func underline(sender: UITextField, color: CGColor){
        sender.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: sender.frame.size.height-1, width: sender.frame.width, height: 1)
        border.backgroundColor = color //UIColor.black.cgColor
        sender.layer.addSublayer(border)
        sender.textAlignment = .left
    }
}
