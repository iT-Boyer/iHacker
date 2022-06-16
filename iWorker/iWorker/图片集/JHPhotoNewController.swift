//
//  JHPhotoNewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD
///图片集中添加图片
class JHPhotoNewController: JHPictureGroupController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        super.createView()
        navTitle = "添加图片集"
        
        let addBtn = UIButton()
        navBar.addSubview(addBtn)
        addBtn.setTitle("添加", for: .normal)
        addBtn.titleLabel?.font = .systemFont(ofSize: 14)
        addBtn.setTitleColor(.k428BFE, for: .normal)
        addBtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            //TODO: 添加图片
            let add = JHPhotoAddController()
            add.type = 1
            add.picsId = wf.picsId
            add.storeId = wf.storeId
            wf.navigationController?.pushViewController(add, animated: true)
        }
        addBtn.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.size.equalTo(CGSize(width: 40, height: 25))
        }
        
    }

}

extension JHPhotoNewController
{
    override func numberOfRowsInSection() -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoCollectCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCollectCell") as! PhotoCollectCell
        cell.model = dataArray[indexPath.row]
        cell.collectImageView.isHidden = indexPath.row > 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //TODO: 修改封面
            let handler = JHHandlerCoverPicsController()
            handler.picsId = dataArray.first?.brandPubID
            handler.handler = {[weak self] model in
                guard let wf = self, var first = wf.dataArray.first else { return }
                first.picDES = model.ambientDesc
                first.picURL = model.ambientURL
                wf.tableView.reloadData()
            }
            navigationController?.pushViewController(handler, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: 删除品牌宣传图片,图片集
        let model = dataArray[indexPath.row]
        guard let itemId = model.brandPubID else{return}
        let param:[String:Any] = ["BrandPubUrlId":itemId]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/DelStoreBrandPubUrl")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                //                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            let msg = json["Message"].string
            if result {
                weakSelf.dataArray.remove(at: indexPath.row)
                weakSelf.tableView.reloadData()
            }
            //MBProgressHUD.displayError(msg)
        }
    }
}
