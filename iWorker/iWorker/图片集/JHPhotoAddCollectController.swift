//
//  JHPhotoAddCollectController.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import Foundation
import UIKit
import JHBase

class JHPhotoAddCollectController: JHPhotoAddController {
    
    override var addAmbient: AddambientM?{
        //TODO: 添加图集
        guard let url = headerModel.ambientUrl else {
            VCTools.toast("需要设置封面内容")
            return nil
        }
        var addAmbient = AddambientM()
        addAmbient.storeId = storeId
        addAmbient.type = "\(type)"
        addAmbient.isPicList = "1"
        addAmbient.brandPubId = "00000000-0000-0000-0000-000000000000"
        addAmbient.ambientList = dataArray.compactMap{ item -> AmbientModel? in
            let model = AmbientModel(ambientDesc: item.ambientDesc, ambientUrl: item.ambientURL)
            return model
        }
        addAmbient.ambientList?.insert(headerModel, at: 0)
        return addAmbient
    }
    
    lazy var headerModel = AmbientModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func createView() {
        super.createView()
        // 设置tableview
        headerView.frame.size.height = 130
        tableView.tableHeaderView = headerView
    }
    
    lazy var headerView: UIView = {
        
        let header = UIView()
        
        header.addSubviews([imgBtn, descLab])
        
        imgBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 130, height: 115))
            make.top.equalTo(15)
            make.bottom.equalToSuperview()
            make.left.equalTo(12)
        }
        
        descLab.snp.makeConstraints { make in
            make.left.equalTo(imgBtn.snp.right).offset(8)
            make.top.equalTo(imgBtn.snp.top).offset(8)
            make.right.equalTo(-8)
            make.height.lessThanOrEqualTo(100)
        }
        
        return header
    }()
    
    lazy var imgBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 3
        btn.setImage(.init(named: "addimgarr"), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else { return }
            //TODO: 更新封面
            let handler = JHHandlePictureViewController()
            handler.storeId = wf.storeId
            handler.isPictureGroup = true
            wf.navigationController?.pushViewController(handler, animated: true)
        }
        return btn
    }()
    lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.text = "请输入封面名称"
        lab.textColor = .k99A0B6
        return lab
    }()
}
