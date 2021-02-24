//
//  AddRecordViewController.swift
//  healingMoments
//
//  Created by heawon on 2021/02/12.
//

import UIKit
import Photos
import RealmSwift

class AddRecordViewController: UIViewController, GetRatingNumberProtocol {
    //MARK: - Properties
    let realm = try! Realm()
    var imageData: Data?
    var getParentCategory: Category?
    var editRecord: Record? {
        //만약 수정하러 온 거면 수정으로 네비게이션 아이템 이름 바꾸기
        didSet {
            rightButtonTitle = "완료"
        }
    }
    @IBOutlet weak var textViewCount: UILabel!
    
    @IBOutlet weak var emptyTitleGuide: UILabel!
    @IBOutlet weak var ratingStackView: RatingControl!
    
    @IBOutlet weak var memoTextView: UITextView! {
        didSet {
            memoTextView.delegate = self
            memoTextView.autocorrectionType = .no
            memoTextView.setBar()
        }
    }
    
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var titleField: UITextField! {
        didSet {
            titleField.delegate = self
            titleField.autocorrectionType = .no //자동완성 끄기
        }
    }
    @IBOutlet weak var dateTitleField: UITextField!
    @IBOutlet weak var memoGuideText: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    var rightButtonTitle: String = "저장"
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editRecord != nil {
            //이전에 입력했던 데이터 세팅
            showStoredData()
        }
        ratingStackView.delegate = self
        setLayout()
        self.dateTitleField.setInputViewDatePicker(target: self, selector: #selector(tabDone))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "기록 추가"

        //오른쪽 버튼 추가
        let rightBarbutton = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(recordAdded))
        rightBarbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.MyFont.SpoqeMedium(customSize: 16)], for: .normal)
        self.navigationItem.setRightBarButton(rightBarbutton, animated: true)
        
        //keyboard가 보이고 가려지는 순간에 대한 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //keyboard가 보이고 가려지는 순간에 대한 알림 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //데이터베이스에 rating값 저장하기위해 라벨에 태그로 선언
    func sendRatingValue(value: Int) {
        ratingValueLabel.tag = value
    }
    
    //수정하고자 할 때 기존의 데이터를 보여주기
    func showStoredData(){
        titleField.text = editRecord?.title
        dateTitleField.text = editRecord?.date.toString()
        memoTextView.text = editRecord?.descriptionText
        memoGuideText.isHidden = true
        photoView.image = UIImage(data: editRecord?.imageData ?? DefaultData.defaultData!)
        ratingStackView.rating = editRecord!.healingRating
        ratingValueLabel?.tag = editRecord!.healingRating
    }
    
    @objc func tabDone(){
        if let datePicker = self.dateTitleField.inputView as? UIDatePicker {
            self.dateTitleField.text = datePicker.date.toString()
        }
        self.dateTitleField.resignFirstResponder()
    }
    
    //레이아웃 관련
    func setLayout(){
        memoGuideText.textColor = UIColor.placeholderText
        textViewCount.textAlignment = .right
        textViewCount.textColor = UIColor.gray
        titleField.underline(sender: self.titleField, color: UIColor.gray.cgColor)
        dateTitleField.underline(sender: self.dateTitleField, color: UIColor.gray.cgColor)
        //memo 칸 둥글게
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = 10
        
        //이미지가 탭 제스처에 반응하도록 -> 카메라, 앨범 선택 가능
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchSettingImage(tapGesture:)))
        photoView.addGestureRecognizer(tapGesture)
        photoView.isUserInteractionEnabled = true
        photoView.tintColor = UIColor.MyColor.lightGray
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = 10


        memoTextView.textColor = UIColor(named: "darkmodelabel")
        memoTextView.layer.cornerRadius = 6
        memoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        //유저의 화면 모드에 따라 메모 배경색 및 보더 변경하기
        if self.traitCollection.userInterfaceStyle == .dark {
            //유저가 다크모드일 때
            memoTextView.backgroundColor = UIColor.systemBackground
            memoTextView.layer.borderColor = UIColor.gray.cgColor
            memoTextView.layer.borderWidth = 1
        } else {
            memoTextView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.97, alpha: 1.00)
            memoTextView.layer.borderWidth = 0
        }
    }
    
    @objc func recordAdded(){
        //사용자가 입력한 데이터 realm에 저장
        saveDate()
    }
    
    //MARK: - 데이터 저장 관련 로직(수정과 생성에 공통 적용)
    func saveDataLogic(data: Record){
        if let string = dateTitleField.text, string != "" {
            data.date = string.toDate()!
        } else {
            //날짜를 저장하지 않으면 현재 날짜로
            data.date = Date()
        }
        data.healingRating = ratingValueLabel.tag
        data.title = titleField.text ?? ""
        data.descriptionText = memoTextView.text
        //if로 처리 안해도 없으면 nil 저장
        if editRecord == nil {
            //새로운 데이터를 저장
            getParentCategory?.records.append(data)
            data.imageData = imageData
        } else if imageData != nil { //글을 수정할 때 이미지를 새로 선택한 경우에만 이미지 변경
            data.imageData = imageData
        }
    }
    
    func saveDate(){
        //타이틀 텍스트 필드에 아무것도 안 적었으면 데이터 저장 X
        guard let titleCheck = titleField.text, titleCheck != "" else {
            titleField.underline(sender: self.titleField, color: UIColor.MyColor.green.cgColor)
            emptyTitleGuide.isHidden = false
            emptyTitleGuide.textColor = UIColor.MyColor.green
            return
        }
        // 기존 데이터를 수정할 때
        if editRecord != nil {
            if let storedRecordData = editRecord {
                do {
                    try realm.write {
                        saveDataLogic(data: storedRecordData)
                        let recordDetailVC = self.navigationController!.viewControllers[2] as? RecordDetailViewController
                        //수정된 데이터를 담고 있는
                        recordDetailVC?.recordData = realm.objects(Record.self).filter("_id == %@", storedRecordData._id).first
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                catch {
                    print("Can't edit Record!")
                    }
                }
            }
        // 새로운 데이터를 저장할 때
            else {
                do {
                    try realm.write {
                        let newRecord = Record()
                        saveDataLogic(data: newRecord)
                        let recordViewVC = self.navigationController!.viewControllers[1] as? RecordViewController
                        recordViewVC?.emptyView.removeFromSuperview()
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    print("Can't save category! \(error)")
                }
            }
    }
}

//MARK: - Camera(카메라, 앨범 선택 관련)
extension AddRecordViewController {
    @objc func touchSettingImage(tapGesture: UITapGestureRecognizer) {
        showImageAlert()
    }
    //카메라 촬영과 앨범에서의 사진 선택 중 하나 선택하기
    @objc private func showImageAlert() {
        let alert = UIAlertController(title: "사진 선택", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "카메라로 사진 촬영", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(SourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(SourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        //아이패드
        alert.showPop(sender: alert, superView: self.view)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - KeyBoard 관련
extension AddRecordViewController {
    //키보드가 보이면 키보드의 높이 만큼 현재 뷰를 아래로 밀기
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //텍스트 필드가 아닌 화면 클릭 시 키보드 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //전달받은 타입(카메라, 라이브러리)에 따라 다른 imagePicker 보여주기
    private func getImage(SourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    //유저가 사진을 선택하고 나면 할 행동. info에 선택한 미디어 정보가 담긴다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self?.photoView
                .image = image
            self?.photoView.contentMode = .scaleAspectFit
            //유저가 사진을 선택하고 난 뒤 실행되는 거니까 강제 언래핑해서 imageData에 저장하기
            self?.imageData = NSData(data: image.jpegData(compressionQuality: 0.9)!) as Data
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddRecordViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleField.text != "" {
            emptyTitleGuide.isHidden = true
            titleField.underline(sender: self.titleField, color: UIColor.gray.cgColor)
        }
    }
}

extension AddRecordViewController:UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        memoGuideText.isHidden = true
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var returnVal: Bool = false
        //만약 200자가 넘으면 더 이상 안 적히게 하기
        if let stringLength = memoTextView.text?.count {
            textViewCount.text = "\(stringLength)/200"
            returnVal = stringLength < 200 ? true : false
        }
        return returnVal
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let memoText = memoTextView.text, memoText == "" {
            //사용자가 아무것도 입력 안 했으면 다시 메모 안내 텍스트 보이게 하기
            memoGuideText.isHidden = false
        }
        return true
    }
}
