//
//  ViewController.swift
//  healingMoments
//
//  Created by heawon on 2021/02/10.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    let realm = try! Realm()
    //MARK: - property
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var categoryArray: Results<Category>?
    
    @IBOutlet weak var addCategoryButton: UIButton!
    
    @IBOutlet weak var buttonBackgroundLabel: UILabel!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(UINib(nibName: "HomeCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.identifier)
        addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        setFlowLayout()
        getCategoryData()
        checkEmpty()
        setLayout()
    }
    func setLayout(){
        homeCollectionView.showsVerticalScrollIndicator = false
        buttonBackgroundLabel.layer.cornerRadius = buttonBackgroundLabel.frame.height/2
        buttonBackgroundLabel.clipsToBounds = true
        buttonBackgroundLabel.backgroundColor = UIColor.MyColor.coral
        addCategoryButton.setTitle(nil, for: .normal)
        //버튼에 들어가는 이미지 크기를 조금 더 작게 수정
        addCategoryButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addCategoryButton.adjustsImageWhenHighlighted = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "힐링 모먼트"
        self.navigationController?.navigationBar.shadowImage = UIImage() //nav 바 밑에 있는 라인 없어지게
        self.navigationController?.navigationBar.tintColor = UIColor.MyColor.coral
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 2.0,height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.MyFont.SpoqeMedium(customSize: 16)]
        
        // 검색 버튼 생성
        let rightBarbutton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearchView))
        self.navigationItem.setRightBarButton(rightBarbutton, animated: true)
        homeCollectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
    }

    @objc func goToSearchView(){
        guard let searchRecordVC = self.storyboard?.instantiateViewController(identifier: "SeachViewController") as? SeachViewController else {return}
        self.navigationController?.pushViewController(searchRecordVC, animated: true)
    }
    
    let emptyView = UIView()
    
    func getCategoryData(){
        //가장 먼저 등록한 순서대로 정렬해서 보여주기
        categoryArray = realm.objects(Category.self).sorted(byKeyPath: "date", ascending: true)
        homeCollectionView.reloadData()
    }
    // 콜렉션 뷰 레이아웃 관련 설정
    private func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 30, left: 20, bottom: 0, right: 20)
        flowLayout.minimumLineSpacing = 20
        let width = (UIScreen.main.bounds.width - 40)
        let ipadWidth = (UIScreen.main.bounds.width - 60)
        let height = CGFloat(100.0)
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            flowLayout.itemSize = CGSize(width: ipadWidth, height: height)
        } else {
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
        self.homeCollectionView.collectionViewLayout = flowLayout
    }
    
    //카테고리를 추가하는 컨트롤러로 이동
    @IBAction @objc func addCategory(_ sender: Any) {
        performSegue(withIdentifier: "addCategory", sender: self)
    }
}

//MARK: - collection View Delegate & Datasource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //다른 스토리보드로 이동
        let recordStoryboard = UIStoryboard.init(name: "Event", bundle: nil)
        guard let recordVC = recordStoryboard.instantiateViewController(identifier: "RecordViewController") as? RecordViewController else { return }
        recordVC.parentCategory = categoryArray?[indexPath.row]
        self.navigationController?.pushViewController(recordVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionViewCell.identifier, for: indexPath) as! HomeCategoryCollectionViewCell
        let colorName = categoryArray?[indexPath.row].colorHex ?? "white"
        cell.cartegoryBtnColor.backgroundColor = UIViewController.returnColor(name: colorName)
        cell.categoryName.text = categoryArray?[indexPath.row].name
        cell.categoryName.textColor = .black
        //추후 해당 row에 있는 카테고리를 사용하여 카테고리를 삭제할 것이므로, 이와 같은 값을 가지는 태그 생성
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(self.showDeleteAlert), for: .touchUpInside)
        return cell
    }
}

//MARK: - Alert: 카테고리 삭제 및 수정(색상, 이름)
extension HomeViewController {
    @objc func showDeleteAlert(sender: UIButton){
        let categoryItemName = self.categoryArray?[sender.tag].name ?? ""
        let alert = UIAlertController(title: "\(categoryItemName) 카테고리", message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default) { (action) in
            guard let addCategoryVC = self.storyboard?.instantiateViewController(identifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
            addCategoryVC.category = self.categoryArray?[sender.tag]
            self.navigationController?.pushViewController(addCategoryVC, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (action) in
            //선택한 카테고리를 데이터베이스에서 삭제하기
            if let categoryItem = self.categoryArray?[sender.tag] {
                do {
                    let childRecords = categoryItem.records
                    try self.realm.write {
                        self.realm.delete(childRecords)

                        self.realm.delete(categoryItem)
                        DispatchQueue.main.async {
                            UIView.transition(with: self.homeCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.homeCollectionView.reloadData()},
                                  completion: { action in
                                    UIView.transition(with: self.homeCollectionView, duration: 0.5, options: .curveLinear, animations: {self.checkEmpty()}, completion: nil)
                                  })
                        }
                    }
                } catch {
                    print("Can't delete category \(error)")
                }
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        //아이패드
        alert.showPop(sender: alert, superView: self.view)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - add Empty View
extension HomeViewController {
    func checkEmpty(){
        emptyView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
        let image: UIImageView = {
            let emptyImage = UIImageView()
            emptyImage.image = UIImage(named: "filledClover")
            emptyImage.contentMode = .scaleAspectFit
            emptyImage.translatesAutoresizingMaskIntoConstraints = false
            return emptyImage
        }()
        
        let guideLabel: UILabel = UILabel.makeMediumLabel(fontSize: 16)
        guideLabel.textAlignment = .center
        guideLabel.text = "카테고리를 추가해주세요."

        if categoryArray?.count == 0 {
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
            UIView.transition(with: self.view, duration: 1, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(self.emptyView)
            }, completion: nil)
        } else {
            image.removeFromSuperview()
            guideLabel.removeFromSuperview()
            emptyView.removeFromSuperview()
        }
    }
}
