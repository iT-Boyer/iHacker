//
//  PhotoCollectCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/9.
//

import Foundation
import UIKit
import JHBase

class PhotoCollectCell: PhotoBaseCell {
    
    override func createView() {
        super.createView()
        contentView.addSubviews([collectImageView,descLab])
        collectImageView.snp.makeConstraints { make in
            make.center.equalTo(iconView.snp.center)
            make.size.equalTo(iconView)
        }
        descLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.leading.equalTo(titleLab.snp.leading)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(showBigImageView))
        iconView.addGestureRecognizer(tap)
    }
    
    @objc func showBigImageView() {
        //TODO: 大图预览
        print("大图预览:\(model?.picURL)")
    }
    
    
    
    var model:JHPhotosModel?{
        didSet{
            guard let mm = model else { return }
            collectImageView.isHidden = !mm.isPicList
            iconView.kf.setImage(with: URL(string: mm.picURL), placeholder: UIImage(named: "videoplaceholdersmall"))
            titleLab.text = mm.picDES
            numLab.text = "\(mm.picTotal)"
        }
    }
    
    
    lazy var collectImageView: UIImageView = {
        let icon = UIImageView(image: .init(named: "photocollect"))
        icon.addSubview(numLab)
        numLab.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 18))
            make.bottom.equalToSuperview()
        }
        return icon
    }()
    
    lazy var numLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 12, weight: .bold)
        lab.backgroundColor = .init(white: 0, alpha: 0.5)
        lab.layer.cornerRadius = 3
        lab.layer.masksToBounds = true
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.isHidden = true
        lab.textColor = .kFF6A34
        lab.text = "点击修改封面"
        lab.font = .systemFont(ofSize: 13)
        return lab
    }()
}
