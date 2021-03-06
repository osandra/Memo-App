//
//  EventViewController.swift
//  healingMoments
//
//  Created by heawon on 2021/02/12.

import UIKit
import RealmSwift

class RecordViewController: UIViewController {
    @IBOutlet weak var showSelectedSortText: UIButton!
    @IBOutlet weak var changeSortView: UIStackView!
    let realm = try! Realm()
    let emptyView = UIView()
    //MARK: - Property
    var recordArray: Results<Record>?
    var parentCategory: Category?
    var sortStandard: String?
    //info.plist
    @IBOutlet weak var recordCollectionView: UICollectionView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordCollectionView.backgroundColor = .systemBackground
        self.view.backgroundColor = .systemBackground
        self.showSelectedSortText.setTitleColor(.label, for: .normal)
        
        setFlowLayout()
        //changeSortView에 Tap Gesture 추가
        changeSortView.isUserInteractionEnabled = true
        let didTapGesture = UITapGestureRecognizer(target: self, action: #selector(showChoicePopUp))
        changeSortView.addGestureRecognizer(didTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        //데이터 불러오기
        getRecordData()

        self.navigationItem.title = parentCategory?.name
        recordCollectionView.reloadData()

        // Record 추가하기 버튼 생성
        let rightBarbutton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        self.navigationItem.setRightBarButton(rightBarbutton, animated: true)
        //현제 저장된 데이터가 하나도 없는지 확인
        checkEmpty()
        
        recordCollectionView.delegate = self
        recordCollectionView.dataSource = self
        recordCollectionView.register(UINib(nibName: "RecordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RecordCollectionViewCell.identifier)
    }
    
    func getRecordData(){
        //저장한 UserDefaults 불러옴
        sortStandard = UserDefaults.standard.string(forKey: "sort")
        if sortStandard == "" || sortStandard == "time" {
            recordArray = parentCategory?.records.sorted(byKeyPath: "date", ascending: true)
            self.showSelectedSortText.setTitle("시간순", for: .normal)
        } else  {
            recordArray = parentCategory?.records.sorted(byKeyPath: "healingRating", ascending: false)
            self.showSelectedSortText.setTitle("만족도순", for: .normal)
        }
        self.recordCollectionView.reloadData()
    }
    
    @objc func showChoicePopUp(){
        var topHeight: CGFloat {
            //changeSortView의 bottom을 기준으로 팝업 프레임 설정하기 위해
            return self.changeSortView.bottom
        }
        
        let popUpFilterVC = self.storyboard?.instantiateViewController(identifier: "FilterPopViewController") as! FilterPopViewController
        popUpFilterVC.modalPresentationStyle = .overCurrentContext
        popUpFilterVC.modalTransitionStyle = .crossDissolve
        popUpFilterVC.topHeight = Int(topHeight)

        popUpFilterVC.ratingSortClosure = {
            self.sortStandard = "rating"
            //정렬 기준을 UserDefaults에 저장
            UserDefaults.standard.set(self.sortStandard, forKey: "sort")
            self.getRecordData()
        }
        popUpFilterVC.timeSortClosure = {
            self.sortStandard = "time"
            UserDefaults.standard.set(self.sortStandard, forKey: "sort")
            self.getRecordData()
        }
        self.present(popUpFilterVC, animated: true, completion: nil)
    }
    
    private func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let width = (UIScreen.main.bounds.width - 30) / 2
        let ipadWidth = (UIScreen.main.bounds.width - 40) / 3
        let height = CGFloat(200.0)
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            flowLayout.itemSize = CGSize(width: ipadWidth, height: height)
        } else {
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
        self.recordCollectionView.collectionViewLayout = flowLayout
    }

    @objc func addRecord(){
        //기록을 추가하는 페이지로 이동
        performSegue(withIdentifier: "AddRecord", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addRecordVc = segue.destination as? AddRecordViewController else { return }
        addRecordVc.getParentCategory = parentCategory
    }
}

extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recordDetailVC = self.storyboard?.instantiateViewController(identifier: "RecordDetailViewController") as? RecordDetailViewController else { return }
        recordDetailVC.recordData = recordArray?[indexPath.row]
        self.navigationController?.pushViewController(recordDetailVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordCollectionView.dequeueReusableCell(withReuseIdentifier: RecordCollectionViewCell.identifier, for: indexPath) as! RecordCollectionViewCell
        cell.recordPhoto.image = UIImage(data: recordArray?[indexPath.row].imageData ?? DefaultData.defaultData!)
        cell.recordTitle.text = recordArray?[indexPath.row].title
        cell.recordTitle.font = UIFont.MyFont.SpoqeRegular(customSize: 13)
        cell.ratingNum.setTitleColor(UIColor(red: 0.00, green: 0.35, blue: 0.41, alpha: 1.00), for: .normal)
        cell.backgroundColor = UIViewController.returnColor(name: parentCategory!.colorHex)
        if let ratingNum = recordArray?[indexPath.row].healingRating {
            cell.ratingNum.setTitle(String(ratingNum), for: .normal)
        }
        return cell
    }
}


extension RecordViewController {
    func checkEmpty(){
        let image: UIImageView = {
            let emptyImage = UIImageView()
            emptyImage.image = UIImage(named: "filledClover")
            emptyImage.contentMode = .scaleAspectFit
            emptyImage.translatesAutoresizingMaskIntoConstraints = false
            return emptyImage
        }()
        let guideLabel: UILabel = UILabel.makeMediumLabel(fontSize: 16)
        guideLabel.textAlignment = .center
        guideLabel.text = "기록을 추가해주세요."
        if recordArray?.count == 0 {
            self.changeSortView.isHidden = true
            emptyView.addSubview(image)
            emptyView.addSubview(guideLabel)
             let sizeWidth = UIScreen.main.bounds.width / 3
            NSLayoutConstraint.activate([
                image.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 50),
                image.widthAnchor.constraint(equalToConstant: sizeWidth),
                image.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
                image.heightAnchor.constraint(equalToConstant: sizeWidth),
                guideLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40),
                guideLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            ])
            self.view.addSubview(emptyView)
            emptyView.frame = CGRect(x:0, y: 150, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            
            UIView.transition(with: self.view, duration: 0.5, options: [.curveEaseIn], animations: {
                self.emptyView.frame.origin.y = 100
            }, completion: nil)
        } else {
            self.changeSortView.isHidden = false
            image.removeFromSuperview()
            guideLabel.removeFromSuperview()
            emptyView.removeFromSuperview()
        }
    }
}
