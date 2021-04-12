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
            showTable()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyFooterLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        searchBar.frame = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width - 50, height: 20)
    }

    lazy var tableviewHeight: CGFloat = 0.0
    
    @IBOutlet weak var resultTableView: UITableView!
    
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
        showTable()
        let rightBarbutton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    func showTable(){
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
        let cell = resultTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.recordImage.image = UIImage(data: resultRecordArray?[indexPath.row].imageData ?? DefaultData.defaultData!)
        cell.titleLabel.text = resultRecordArray?[indexPath.row].title
        cell.descriptionTextView.text = resultRecordArray?[indexPath.row].descriptionText
        cell.ratingLabel.text = String((resultRecordArray?[indexPath.row].healingRating)!)
        cell.selectionStyle = .none
        return cell
    }
    
    //각 셀의 높이 120으로 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
