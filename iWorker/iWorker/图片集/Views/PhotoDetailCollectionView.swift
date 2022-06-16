//
//  PhotoDetailCollectionView.swift
//  iWorker
//
//  Created by boyer on 2022/6/16.
//

import UIKit

class PhotoDetailCollectionView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:StoreAmbientModel?{
        didSet{
            guard let mm = model else { return }
            titleLab.text = mm.ambientDesc
            imageView.kf.setImage(with: URL(string: mm.ambientURL), placeholder: UIImage(named: "videoplaceholdersmall"))
        }
    }
    
    func createView() {
        contentView.addSubviews([imageView, titleLab])
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(29)
            make.bottom.right.left.equalToSuperview()
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageV = UIImageView(image: .init(named: ""))
        imageV.layer.cornerRadius = 5
        imageV.clipsToBounds = true
        return imageV
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.layer.masksToBounds = true
        lab.font = .systemFont(ofSize: 16, weight: .bold)
        lab.textColor = .white
        lab.backgroundColor = .init(white: 0, alpha: 0.3)
        lab.textAlignment = .center
        return lab
    }()
}
