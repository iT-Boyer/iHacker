//
//  JHCameraAlertController.swift
//  iWorker
//
//  Created by boyer on 2022/7/5.
//

import UIKit

class JHCameraAlertController: UIViewController {

    var dataArray:[JHCameraModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
    }
    
    func createView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(90)
            make.left.equalTo(20)
        }
    }
    
    
    lazy var collectionView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.itemSize = .init(width: 90, height: 90)
        flowlayout.sectionInset = .zero
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.register(JHCameraBaseCell.self, forCellWithReuseIdentifier: "JHCameraBaseCell")
        collection.register(JHCameraCell.self, forCellWithReuseIdentifier: "JHCameraCell")
        return collection
    }()
}

extension JHCameraAlertController:UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:JHCameraCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JHCameraCell", for: indexPath) as! JHCameraCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
