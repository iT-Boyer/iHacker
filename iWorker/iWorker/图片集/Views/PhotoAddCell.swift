//
//  PhotoAddCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import UIKit

class PhotoAddCell: PhotoBaseCell {

    override func createView() {
        super.createView()
        contentView.addSubview(checkBox)
        checkBox.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.centerY.equalTo(titleLab.snp.centerY)
        }
    }
    
    var recommend:JHRecommendModel?{
        didSet{
            guard let mm = recommend else { return }
            titleLab.text = mm.name
            iconView.kf.setImage(with: URL(string: mm.imageURL), placeholder: UIImage(named: "videoplaceholdersmall"))
            let icon = mm.selected ? "btnselected":"btnselect"
            checkBox.image = UIImage(named: icon)
        }
    }
    var model:StoreAmbientModel?{
        didSet{
            guard let mm = model else { return }
            titleLab.text = mm.ambientDesc
            iconView.kf.setImage(with: URL(string: mm.ambientURL), placeholder: UIImage(named: "videoplaceholdersmall"))
            let icon = mm.selected ? "btnselected":"btnselect"
            checkBox.image = UIImage(named: icon)
        }
    }
    
    lazy var checkBox: UIImageView = {
        let icon = UIImageView(image: .init(named: "btnselect"))
        return icon
    }()
}
