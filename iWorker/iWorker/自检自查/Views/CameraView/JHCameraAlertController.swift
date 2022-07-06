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
    var isDetail:Bool { cameraHandler == nil }
    var originArray:[JHCameraModel] = []
    var dataArray: [JHCameraModel] {
        if isDetail {
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
    //Bool添加或删除图片操作
    var cameraHandler:((Bool,JHCameraModel)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshUI()
    }
    
    // 自适应高度
    func refreshUI() {
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        
        view.frame.size = CGSize(width: kScreenWidth - 40, height: height)
        view.frame.origin = CGPoint(x: 20, y: (kScreenHeight - height)/2)
    }
    
    func createView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
            make.left.equalToSuperview()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
//        flowlayout.itemSize = .init(width: 90, height: 90)
//        flowlayout.sectionInset = .zero
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
        cell.refreshUI(isDetail)
        if !isDetail {
            cell.removeHandler = {[weak self] item in
                guard let wf = self, let handler = wf.cameraHandler else { return }
                wf.originArray.removeAll(item)
                handler(false,item)
                wf.collectionView.reloadData()
                wf.refreshUI()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = dataArray.last?.url else {
            //TODO: 拍照
            vctools.showCamera(count: 1) {[weak self] model in
                guard let wf = self, let handler = wf.cameraHandler else { return }
                wf.originArray.append(model)
                handler(true,model)
                wf.collectionView.reloadData()
                wf.refreshUI()
            }
            return
        }
        //TODO: 大图预览
    }
}

extension JHCameraAlertController:UICollectionViewDelegateFlowLayout
{
    // 返回cell的尺寸大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (kScreenWidth - 40 - 10 * 4)/3
        return CGSize(width: width, height: width)
    }
    // 返回cell之间行间隙
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    // 返回cell之间列间隙
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    // section 边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
