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
    var categoryArray: Results<Category>?
    
    private var viewModels = [HomeCategoryCollectionViewCellViewModel]()
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var addCategoryButton: UIButton!
    
    @IBOutlet weak var buttonBackgroundLabel: UILabel!
    
    let emptyView = EmptyView(guideText: "카테고리를 추가해주세요.")

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoryData()

        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.identifier)
        
        addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
        setFlowLayout()
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
        getCategoryData()
        self.navigationItem.title = "힐링 모먼트"
        self.navigationController?.navigationBar.shadowImage = UIImage() //nav 바 밑에 있는 라인 없어지게
        self.navigationController?.navigationBar.tintColor = UIColor.MyColor.coral
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 2.0,height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.MyFont.SpoqeMedium(customSize: 16)]
        
        // 오른쪽 검색 버튼 생성
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
    
    func getCategoryData(){
        self.viewModels = []
        //가장 먼저 등록한 순서대로 정렬해서 보여주기
        categoryArray = realm.objects(Category.self).sorted(byKeyPath: "date", ascending: true)
        categoryArray?.forEach({ (category) in
            viewModels.append(HomeCategoryCollectionViewCellViewModel(
                                name: category.name,
                                buttonColorName: category.colorHex,
                                tag: category.hashValue))
        })

        self.homeCollectionView.reloadData()
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, HomeCategoryCollectionViewCellDelegate {
    
    func HomeCategoryCollectionViewCellDidTapImage(_ cell: HomeCategoryCollectionViewCell) {
        showDeleteAlert(tag: cell.moreimageView.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //다른 스토리보드로 이동
        let recordStoryboard = UIStoryboard.init(name: "Event", bundle: nil)
        guard let recordVC = recordStoryboard.instantiateViewController(identifier: "RecordViewController") as? RecordViewController else { return }
        recordVC.parentCategory = categoryArray?[indexPath.row]
        self.navigationController?.pushViewController(recordVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = homeCollectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCategoryCollectionViewCell.identifier,
                for: indexPath) as? HomeCategoryCollectionViewCell else {
            fatalError()
        }
        cell.delegate = self
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}


//MARK: - Alert: 카테고리 삭제 및 수정(색상, 이름)
extension HomeViewController {
    @objc func showDeleteAlert(tag: Int){
        guard let categoryIndex = self.categoryArray?.firstIndex(where: { (category) -> Bool in
            category.hashValue == tag
        }) else {return}
        let categoryItemName = self.categoryArray?[categoryIndex].name ?? ""
        let alert = UIAlertController(title: "\(categoryItemName) 카테고리", message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default) { (action) in
            guard let addCategoryVC = self.storyboard?.instantiateViewController(identifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
            addCategoryVC.category = self.categoryArray?[categoryIndex]
            self.navigationController?.pushViewController(addCategoryVC, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (action) in
            //카테고리 삭제 시 해당 카테고리에 있는 모든 기록이 삭제된다는 것을 알려주는 팝업 뷰 보여주기
            let popUpVC = self.storyboard?.instantiateViewController(identifier: "CustomPopUpViewController") as! CustomPopUpViewController
            popUpVC.modalPresentationStyle = .overCurrentContext
            popUpVC.modalTransitionStyle = .crossDissolve
            popUpVC.deleteClosure = {
                if let categoryItem = self.categoryArray?[categoryIndex] {
                    do {
                        let childRecords = categoryItem.records
                        try self.realm.write {
                            self.realm.delete(childRecords)

                            self.realm.delete(categoryItem)
                            DispatchQueue.main.async {
                                self.viewModels = []
                                self.getCategoryData()
                                
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
            }
            self.present(popUpVC, animated: true, completion: nil)
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
        if categoryArray?.count == 0 {
            view.addSubview(emptyView)
            emptyView.frame = CGRect(x: 0, y: view.safeAreaInsets.top+150, width: view.width, height: view.height-200)
            UIView.transition(with: self.view, duration: 1, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(self.emptyView)
            }, completion: nil)
        } else {
            view.willRemoveSubview(emptyView)
            emptyView.removeFromSuperview()
        }
    }
}
