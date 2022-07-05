//
//  JHCameraCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/5.
//

import UIKit
import JHBase

struct JHCameraModel {
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
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.left.top.equalTo(10)
            make.center.equalToSuperview()
        }
    }
    
    lazy var photoView: UIImageView = {
        let photo = UIImageView(image: .init(named: "Inspectcamera"))
        photo.layer.cornerRadius = 10
        photo.layer.masksToBounds = true
        return photo
    }()
}

class JHCameraCell: JHCameraBaseCell {
    
    var removeHandler:(JHCameraModel)->Void = {_ in}
    
    var model:JHCameraModel?{
        willSet{
            guard let new = newValue else { return }
            if let url = new.url {
                removeBtn.isHidden = false
                photoView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: ""))
            }else{
                removeBtn.isHidden = true
                photoView.image = .init(named: "Inspectcamera")
            }
        }
    }
    
    override func createView() {
        super.createView()
        contentView.addSubview(removeBtn)
        removeBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 27, height: 27))
            make.top.right.equalToSuperview()
        }
    }
    
    lazy var removeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "Inspectshanchu"), for: .normal)
        return btn
    }()
}
