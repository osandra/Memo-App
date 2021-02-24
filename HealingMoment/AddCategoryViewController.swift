//
//  AddCategoryViewController.swift
//  healingMoments
//
//  Created by heawon on 2021/02/10.
//

import UIKit
import RealmSwift

class AddCategoryViewController: UIViewController {
    //MARK: - property
    let realm = try! Realm()
    var category: Category?
    var choosenColorIndex: Int = 0
    @IBOutlet weak var nameGuideText: UILabel!
    var choosenColorHexString: String {
        switch choosenColorIndex {
        case 0:
            return "lightBeige"
        case 1:
            return "lightOrange"
        case 2:
            return "lightBlue"
        case 3:
            return "lightWhite"
        case 4:
            return "lightPink"
        case 5:
            return "green"
        case 6:
            return "yellow"
        case 7:
            return "red"
        default:
            return "none"
        }
    }
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryBackgroundLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        categoryNameTextField.delegate = self
        colorCollectionView.backgroundColor = .systemBackground
        colorCollectionView.showsHorizontalScrollIndicator = false
        setFlowLayout()
        setLayout()
        if category != nil {
            showOriginData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "카테고리 추가"
        let rightBarbutton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightBarButtonAction))
        
        self.navigationItem.setRightBarButton(rightBarbutton, animated: true)
    }
    
    func showOriginData(){
        categoryNameTextField.text = category?.name
        choosenColorIndex = -1 //만약 색상을 다시 설정한 게 아니면 원래 색상대로 저장하기 위해
    }
    
    func setLayout(){
        //텍스트필드 & 가이드 라벨 폰트 변경
        categoryNameTextField.font = UIFont.MyFont.SpoqeMedium(customSize: 15)
        categoryNameLabel.font = UIFont.MyFont.SpoqeRegular(customSize: 15)
        categoryBackgroundLabel.font = UIFont.MyFont.SpoqeRegular(customSize: 15)

    }

    @objc func rightBarButtonAction() {
        guard let text = self.categoryNameTextField.text, text.count >= 1, text.count <= 14 else {
            nameGuideText.isHidden = false
            nameGuideText.font = UIFont.MyFont.SpoqeRegular(customSize: 12)
            nameGuideText.textColor = UIColor.MyColor.coral
            return
        }
        saveDate()
        let homeVC = self.navigationController!.viewControllers[0] as? HomeViewController
        homeVC?.emptyView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Save & Edit Data
    func saveDate(){
        if category == nil {
            do {
                try realm.write {
                    let newCategory = Category()
                    newCategory.name = self.categoryNameTextField.text!
                    newCategory.colorHex = choosenColorHexString
                    realm.add(newCategory)
                }
            } catch {
                print("Can't save category! \(error)")
            }
        }
        //기존 데이터를 수정해야 할 때
        else {
            do {
                try realm.write {
                    category?.name = self.categoryNameTextField.text!
                    if choosenColorIndex != -1 {
                        //다른 색상을 선택했을 때에만 색상 변경
                        category?.colorHex = choosenColorHexString
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } catch {
                print("can't edit Record!")
            }
        }
    }
    
    @objc func btnClick(sender: UIButton) {
        self.removeAllBorderExcept(sender.tag)
        switch sender.tag {
        case 0...UIColor.MyColor.colorArray.count:
            sender.layer.borderColor = UIColor.MyColor.coral.cgColor
            sender.clipsToBounds = true
            sender.layer.cornerRadius = 10
            sender.layer.borderWidth = 4
            choosenColorIndex = sender.tag
        default:
            print("NOTHING")
        }
    }
    // 콜렉션 뷰 레이아웃 관련 설정
    private func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumLineSpacing = 6
        let width = (UIScreen.main.bounds.width - 20) / 4 - 4.5
        flowLayout.itemSize = CGSize(width: width, height: width)
        self.colorCollectionView.collectionViewLayout = flowLayout
    }
}

//MARK: - textField 설정
extension AddCategoryViewController: UITextFieldDelegate {
    //텍스트 필드가 아닌 화면 클릭 시 키보드 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryNameTextField.resignFirstResponder()
        if let textLimit = categoryNameTextField.text {
            if textLimit.count <= 15 {
                nameGuideText.isHidden = true
            }
        }
        return true
    }
}

//MARK: - CollectionView Delegate & Datasoure
extension AddCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIColor.MyColor.colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
        cell.colorButton.backgroundColor = UIColor.MyColor.colorArray[indexPath.row]
        //버튼을 클릭하면 해당 이벤트 발생
        cell.colorButton.addTarget(self, action:#selector(btnClick(sender:)), for: .touchUpInside)
        cell.colorButton.tag = indexPath.item //0 1 2 3 4 번 이 붙음(5개의 색상이 있는 경우)
        cell.layer.borderWidth = 0
        return cell
    }
    
    //현재 클릭한 셀 버튼만 제외하고 나머지 버튼의 보더를 다 없애기
    private func removeAllBorderExcept(_ currentBtnTag: Int){
        for cell in colorCollectionView.visibleCells as! [ColorCollectionViewCell] {
            if cell.colorButton.tag != currentBtnTag {
                cell.colorButton.layer.borderWidth = 0
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        removeAllBorderExcept(choosenColorIndex)
    }
}
