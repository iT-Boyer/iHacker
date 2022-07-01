//
//  CheckNoteCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import UIKit

class CheckNoteCell: CheckEditBaseCell {

    override func updateUI() {
        iconView.image = .init(named: "Inspect备注")
        actionView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        return tv
    }()
}

extension CheckNoteCell:UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        model?.note = textView.text
        actionHandler(model)
    }
}
