//
//  JHPhotoAddCollectController.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import Foundation
import UIKit
import JHBase
import Kingfisher
//新建图片集
class JHPhotoAddCollectController: JHPhotoAddController {
    
    override var addAmbient: AddambientM?{
        //TODO: 新建图片集
        if headerModel.ambientUrl == nil
            || headerModel.ambientDesc == nil {
            VCTools.toast("需要设置封面内容")
            return nil
        }
        var addAmbient = AddambientM()
        addAmbient.storeId = storeId
        addAmbient.type = "\(type)"
        addAmbient.isPicList = "1"
        addAmbient.brandPubId = picsId
        addAmbient.ambientList = dataArray.compactMap{ item -> AmbientModel? in
            if !item.selected {return nil}
            let model = AmbientModel(ambientDesc: item.ambientDesc, ambientUrl: item.ambientURL)
            return model
        }
        addAmbient.ambientList?.insert(headerModel, at: 0)
        return addAmbient
    }
    
    lazy var headerModel:AmbientModel = AmbientModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func createView() {
        super.createView()
        navTitle = "添加图片集"
        bottomBtn.isEnabled = true
    }
    
    override func showData() {
        super.showData()
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
            let handler = JHHandlerCoverPicsController()
            handler.handler = {model in
                wf.headerModel.ambientDesc = model.ambientDesc
                wf.headerModel.ambientUrl = model.ambientURL
                wf.descLab.text = model.ambientDesc
                wf.imgBtn.kf.setImage(with: URL(string: model.ambientURL), for: .normal, placeholder:UIImage(named: "addimgarr"))
                NotificationCenter.default.post(name: .init(rawValue: "JHPhotoBase_refreshList"), object: nil)
            }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        bottomBtn.isEnabled = true
    }
}
