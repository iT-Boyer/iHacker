//
//  JHCameraAlertController.swift
//  iWorker
//
//  Created by boyer on 2022/7/5.
//

import UIKit
import JHBase

class JHCameraAlertController: UIViewController {

    lazy var vctools = VCTools()
    
    var detail = false
    var originArray:[JHCameraModel] = []
    var dataArray: [JHCameraModel] {
        if detail {
            return originArray
        }else{
            if originArray.count == 6 {
                return originArray
            }
            return originArray + [addModel]
        }
    }
    
    //占位
    lazy var addModel = JHCameraModel()
    
    var cameraHandler:(JHCameraModel)->Void = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataArray.count > 3{
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            collectionView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.frame.size = CGSize(width: kScreenWidth - 40, height: 180)
        view.frame.origin = CGPoint(x: 20, y: kScreenHeight/2 - 90)
    }
    
    func createView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
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
        
        collection.layer.cornerRadius = 10
        collection.layer.masksToBounds = true
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
        guard let url = dataArray.last?.url else {
            //TODO: 拍照
            vctools.showCamera(count: 1) {[weak self] model in
                guard let wf = self else { return }
                wf.originArray.append(model)
                wf.cameraHandler(model)
                wf.collectionView.reloadData()
                if wf.dataArray.count > 3{
                    let height = wf.collectionView.collectionViewLayout.collectionViewContentSize.height
                    wf.collectionView.snp.updateConstraints { make in
                        make.height.equalTo(height)
                    }
                }
            }
            return
        }
    }
}
