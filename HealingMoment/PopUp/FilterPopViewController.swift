//
//  filterPopViewController.swift
//  HealingMoment
//
//  Created by heawon on 2021/03/06.
//

import UIKit

class FilterPopViewController: UIViewController {

    @IBOutlet var Choices: [UIButton]!
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var recentBtn: UIButton!
    
    var ratingSortClosure: (()->Void)?
    var timeSortClosure: (()->Void)?
    
    var topHeight: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        contentView.translatesAutoresizingMaskIntoConstraints = true
        recentBtn.translatesAutoresizingMaskIntoConstraints = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setLayout(){
        contentView.frame = CGRect(x: self.view.frame.width-90, y:CGFloat(topHeight ?? 0)+5, width: 80, height: 80)
        contentView.layer.cornerRadius = 5
        recentBtn.frame = CGRect(x: 0, y: 10, width: 80, height: 20)
        ratingBtn.frame = CGRect(x: 0, y: 30, width: 80, height: 20)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func recentBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let recentClosure = timeSortClosure {
            recentClosure()
        }
    }
    
    @IBAction func ratingBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let ratingClosure = ratingSortClosure {
            ratingClosure()
        }
    }
}
