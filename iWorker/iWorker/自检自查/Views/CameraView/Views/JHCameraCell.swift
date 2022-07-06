//
//  JHCameraCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/5.
//

import UIKit
import JHBase

struct JHCameraModel:Equatable {
    var url:String?
    
}

class JHCameraBaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createView() {
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(10)
            make.right.equalTo(-10)
        }
    }
    
    lazy var photoView: UIImageView = {
        let photo = UIImageView(image: .init(named: "Inspectcamera"))
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 10
        photo.layer.masksToBounds = true
        return photo
    }()
}

class JHCameraCell: JHCameraBaseCell {
    
    var removeHandler:(JHCameraModel)->Void = {_ in}
    var ishowRemoveBtn:Bool{
        model?.url?.isEmpty ?? true
    }
    var model:JHCameraModel?{
        willSet{
            guard let new = newValue else { return }
            photoView.kf.setImage(with: URL(string: new.url), placeholder: UIImage(named: "Inspectcamera"))
        }
    }
    //详情时，刷新UI
    func refreshUI(_ detail:Bool) {
        if detail {
            removeBtn.isHidden = true
            photoView.snp.updateConstraints { make in
                make.right.top.equalToSuperview()
            }
        }else{
            removeBtn.isHidden = ishowRemoveBtn
            photoView.snp.updateConstraints { make in
                make.top.equalTo(10)
                make.right.equalTo(-10)
            }
        }
    }
    
    override func createView() {
        super.createView()
        contentView.addSubview(removeBtn)
        removeBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.top.right.equalToSuperview()
        }
    }
    
    lazy var removeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "Inspectshanchu"), for: .normal)
        btn.jh.setHandleClick {[weak self] btn in
            guard let wf  = self, let mm = wf.model else{return}
            wf.removeHandler(mm)
        }
        return btn
    }()
}
