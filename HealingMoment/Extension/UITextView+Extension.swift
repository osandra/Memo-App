//
//  UITextField+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/17.
//

import UIKit
extension UITextView {
    func setBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone))
        barButton.tintColor = UIColor(named: "darkmodelabel")
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    @objc func tapDone() {
        self.resignFirstResponder()
    }
}
