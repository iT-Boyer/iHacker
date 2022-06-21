//
//  PhotoEditCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/15.
//

import Foundation
import UIKit

class PhotoEditCell: UITableViewCell {

    var updateBlock:(StoreAmbientModel)->() = {_ in}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textViewEditChanged(_ obj: Notification) {
        guard var mm = model else { return }
        mm.ambientDesc = textView.text
        updateBlock(mm)
    }
    
    var model: StoreAmbientModel? {
        didSet{
            guard let mm = model else { return }
            textView.delegate = self    //解决TextView代理不执行问题
            if let desc = mm.ambientDesc{
                textView.text = desc
            }else{
                textView.placeholder = "请输入图片描述"
            }
            iconView.kf.setImage(with: URL(string: mm.ambientURL), placeholder: UIImage(named:"videoplaceholdersmall"))
        }
    }
    
    func createView() {
        contentView.addSubviews([iconView,textView])
        iconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 130, height: 115))
            make.top.equalTo(15)
            make.bottom.equalToSuperview()
            make.left.equalTo(12)
        }
        textView.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.left.equalTo(iconView.snp.right).offset(8)
            make.top.equalTo(iconView.snp.top).offset(8)
//            make.height.equalTo(22)
            make.bottom.lessThanOrEqualTo(iconView.snp.bottom).offset(-10)
        }
        layoutIfNeeded()
    }
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 8
        icon.layer.masksToBounds = true
        icon.image = .init(named: "videoplaceholdersmall")
        return icon
    }()
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.font = .systemFont(ofSize: 16, weight: .bold)
        text.textColor = .k2F3856
//        text.autoHeight = true
//        text.limitLength = 130
//        text.backgroundColor = .orange
        return text
    }()
}

extension PhotoEditCell:UITextViewDelegate
{
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty{
            guard var mm = model else { return }
            mm.ambientDesc = textView.text
            updateBlock(mm)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if range.location > 10 {
            return false
        }
        return true
    }
}
