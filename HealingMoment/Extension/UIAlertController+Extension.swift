//
//  UIPopoverPresentationController+Extension.swift
//  healingMoments
//
//  Created by heawon on 2021/02/20.
//
import UIKit
extension UIAlertController {
    //아이패드일 경우 팝오버로 보여주기
    func showPop(sender: UIAlertController, superView: UIView){
        if let popoverController = sender.popoverPresentationController {
          popoverController.sourceView = superView
          popoverController.sourceRect = CGRect(x: superView.bounds.midX, y: superView.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
    }
}
