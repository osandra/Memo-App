//
//  EventViewController.swift
//  healingMoments
//
//  Created by heawon on 2021/02/12.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController {
    let realm = try! Realm()
    let emptyView = UIView()
    //MARK: - Property
    var recordArray: Results<Record>?
    var parentCategory: Category? {
        didSet {
            //값이 넘어오면 해당 값을 통해 해당 카테고리에 등록템 record 객체 배열을 가져오기
            getRecordData()
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordCollectionView.backgroundColor = .systemBackground
        setFlowLayout()
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
    @IBOutlet weak var recordCollectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        //다음 뷰에서 Back글자 안 보이게
        self.navigationItem.title = " "
        recordCollectionView.reloadData()

        self.view.backgroundColor = .white
        // Record 추가하기 버튼 생성
        let rightBarbutton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        self.navigationItem.setRightBarButton(rightBarbutton, animated: true)

        checkEmpty()
        recordCollectionView.delegate = self
        recordCollectionView.dataSource = self
        recordCollectionView.register(UINib(nibName: "RecordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RecordCollectionViewCell.identifier)

    }
    @objc func addRecord(){
        //기록을 추가하는 페이지로 이동
        performSegue(withIdentifier: "AddRecord", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addRecordVc = segue.destination as? AddRecordViewController else { return }
        addRecordVc.getParentCategory = parentCategory
    }
    func getRecordData(){
        recordArray = parentCategory?.records.sorted(byKeyPath: "date", ascending: true)
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
            image.removeFromSuperview()
            guideLabel.removeFromSuperview()
            emptyView.removeFromSuperview()
        }
    }
}
