//
//  JHCameraCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/5.
//

import UIKit

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
        
        return photo
    }()
}

class JHCameraCell: JHCameraBaseCell {
    
    var removeHandler:(JHCameraModel)->Void = {_ in}
    
    var model:JHCameraModel?{
        willSet{
            guard let new = newValue else { return }
            photoView.kf.setImage(with: URL(string: new.url), placeholder: UIImage(named: ""))
        }
    }
    
    override func createView() {
        super.createView()
        contentView.addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 22))
            make.top.right.equalToSuperview()
        }
    }
    
    lazy var cameraBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "Inspectshanchu"), for: .normal)
        return btn
    }()
}
