//
//  ShowOnlyPhotoViewController.swift
//  healingMoments
//
//  Created by heawon on 2021/02/20.
//

import UIKit
import RealmSwift
class ShowOnlyPhotoViewController: UIViewController, UIScrollViewDelegate {
    //MARK: - property
    var recordData: Record?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recordPhoto: UIImageView!
    let realm = try! Realm()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setLayout()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        recordPhoto.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        recordPhoto.addGestureRecognizer(pinchGesture)
        recordPhoto.image = UIImage(data: recordData!.imageData!)
    }
    
    //이미지 레이아웃 설정
    func setLayout(){
        recordPhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            recordPhoto.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            recordPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func pinchGesture(sender:UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        //원본이미지 크기보다 축소는 불가능하고 확대만 가능하게
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return recordPhoto
    }
}
