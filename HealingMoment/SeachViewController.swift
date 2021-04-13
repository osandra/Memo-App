//
//  seachViewController.swift
//  HealingMoment
//
//  Created by heawon on 2021/02/23.
//

import UIKit
import RealmSwift

class SeachViewController: UIViewController {
    //MARK: - Property
    let realm = try! Realm()
    var resultRecordArray: Results<Record>? {
        didSet {
            setViewModel()
        }
    }
    var emptyFooterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.MyFont.SpoqeMedium(customSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "제목과 내용으로 검색하기"
        searchBar.searchTextField.backgroundColor = .systemBackground
        searchBar.layer.shadowColor = UIColor.gray.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        searchBar.layer.shadowRadius = 1.0
        searchBar.layer.shadowOpacity = 0.2
        return searchBar
    }()
    @IBOutlet weak var resultTableView: UITableView!



    lazy var tableviewHeight: CGFloat = 0.0
    
    var viewModels = [SearchTableViewCellViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        resultTableView.showsVerticalScrollIndicator = false
        resultTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        resultTableView.tableFooterView = emptyFooterLabel
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewModel()
        let rightBarbutton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyFooterLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        searchBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width - 50, height: 20)
    }
    
    func setViewModel(){
        resultRecordArray?.forEach({ (record) in
            let image = UIImage(data: record.imageData ?? DefaultData.defaultData!)
            viewModels.append(SearchTableViewCellViewModel(
                                title: record.title,
                                image: image,
                                description: record.descriptionText,
                                ratingText: "\(record.healingRating)"))
        })
        
        resultTableView.reloadData()
    }
    
    @objc func goToHome(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension SeachViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
        resultRecordArray = realm.objects(Record.self).filter("title CONTAINS[cd] '\(searchedText)' OR descriptionText CONTAINS[cd] '\(searchedText)'")
            self.searchBar.endEditing(true)
            if resultRecordArray?.count == 0 {
                emptyFooterLabel.text = "\(searchedText)의 검색 결과가 없어요."
            } else {
                emptyFooterLabel.text = ""
            }
        }
    }

    //사용자가 x버튼 누르면
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultRecordArray = nil
            emptyFooterLabel.text = ""
        }
    }
}

//MARK: - TableView
extension SeachViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let eventStoryboard = UIStoryboard(name: "Event", bundle: nil)
        guard let recordDetailVC =
                eventStoryboard.instantiateViewController(identifier: "RecordDetailViewController") as? RecordDetailViewController else { return }
                
        recordDetailVC.recordData = resultRecordArray?[indexPath.row]
        self.navigationController?.pushViewController(recordDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultRecordArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { fatalError() }
        cell.configure(with: viewModels[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    //각 셀의 높이 120으로 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
