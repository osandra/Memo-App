//
//  RecordDetailViewController.swift
//  healingMoments
//
//  Created by heawon on 2021/02/17.
//

import UIKit
import RealmSwift
class RecordDetailViewController: UIViewController {
    //MARK: - Property
    let realm = try! Realm()
    var recordData: Record?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var recordImage: UIImageView!
    @IBOutlet weak var RatingBtn: UIButton!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "")
        }
        let rightBarbutton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(editAndDelete))
        self.navigationItem.rightBarButtonItem = rightBarbutton
        
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = " "
        setData()
        setLayout()
        //사진을 tap하면 사진이 크게 보이는 뷰 컨트롤러로
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showPhotoDetail(tapGesture:)))
        recordImage.addGestureRecognizer(tapGesture)
        recordImage.isUserInteractionEnabled = true
        
    }
    @objc func showPhotoDetail(tapGesture: UITapGestureRecognizer){
        guard let photoVC = self.storyboard?.instantiateViewController(identifier: "ShowOnlyPhotoViewController") as? ShowOnlyPhotoViewController else {return}
        photoVC.recordData = recordData
        if photoVC.recordData?.imageData != nil {
            self.navigationController?.pushViewController(photoVC, animated: true)
        }
    }

    func setData(){
        titleLabel.text = recordData?.title
        recordImage.image = UIImage(data: recordData?.imageData ?? DefaultData.defaultData!)
        dateLabel.text = recordData?.date.toString()
        memoTextView.text = recordData?.descriptionText
    }
    func setLayout(){

        dateLabel.font = UIFont.MyFont.SpoqeRegular(customSize: 13)
        
        titleLabel.font = UIFont.MyFont.SpoqeMedium(customSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = UIColor(named: "darkmodelabel")
        
        dateLabel.textColor = UIColor(named: "darkmodelabel")
        RatingBtn.setTitle(String(recordData!.healingRating), for: .normal)
        RatingBtn.setTitleColor(UIColor(red: 0.00, green: 0.35, blue: 0.41, alpha: 1.00), for: .normal)
        
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = 10
        memoTextView.textColor = UIColor(named: "darkmodelabel")
        memoTextView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        memoTextView.backgroundColor = .systemBackground
        memoTextView.font = UIFont.MyFont.SpoqeRegular(customSize: 15)
        if recordData?.descriptionText.count != 0 {
            memoTextView.isHidden = false
        } else {
            memoTextView.isHidden = true
        }
    }
    
    @objc func editAndDelete(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default) { (action) in
            guard let recordVC = self.storyboard?.instantiateViewController(identifier: "AddRecordViewController") as? AddRecordViewController else { return }
            recordVC.getParentCategory = self.recordData?.parentCategory as? Category
            recordVC.editRecord = self.recordData
            self.navigationController?.pushViewController(recordVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            //delete item from database & 해당카테고리의 기록들 보이는 화면으로 되돌아가기
            do {
                if let deleteRecord = self.recordData {
                    try self.realm.write {
                        self.realm.delete(deleteRecord)
                        print("deleted!")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Can't delete record \(error)")
            }
        }
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.showPop(sender: alert, superView: self.view)
        self.present(alert, animated: true, completion: nil)
    }
}
