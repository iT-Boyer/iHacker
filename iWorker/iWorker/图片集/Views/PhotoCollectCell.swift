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
        contentView.addSubview(collectImageView)
        collectImageView.snp.makeConstraints { make in
            make.center.equalTo(iconView.snp.center)
            make.size.equalTo(iconView)
        }
    }
    
    var model:JHPhotosModel?{
        didSet{
            guard let mm = model else {
                return
            }
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
}
