//
//  CalendarBottomCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/8.
//

import UIKit

class CalendarBottomCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:InsYearModel?{
        willSet{
            guard let new = newValue else { return }
            titleLab.text = "\(new.inspectTimes ?? 0)/\(new.allTimes ?? 0)"
            subtitleLab.text = new.selfInspectType
        }
    }
    

    func createView() {
        contentView.addSubviews([titleLab, subtitleLab])
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        subtitleLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 15)
        lab.layer.borderColor = UIColor.gray.cgColor
        lab.layer.cornerRadius = 30
        lab.layer.borderWidth = 0.5
        lab.layer.masksToBounds = true
        return lab
    }()
    
    lazy var subtitleLab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
}
